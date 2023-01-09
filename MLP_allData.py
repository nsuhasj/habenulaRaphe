# neural network for Hb
import tensorflow as tf
import numpy as np
from keras.models import Sequential
from keras.layers import Dense
import matplotlib.pyplot as plt

# load the dataset
X = np.loadtxt('hb_all_for_mlp.csv', delimiter=',')
y = np.loadtxt('raphe_all_for_mlp.csv', delimiter=',')

# Plot original datasets
plt.subplot(1,2,1)
plt.plot(X)
plt.subplot(1,2,2)
plt.plot(y)


accuracy_recorder = []
history_recorder = []
loss_recorder = []

for i in range(20):

    # define the keras model
    model = Sequential()
    model.add(Dense(2, input_shape=(6,), activation='relu'))
    model.add(Dense(1))
    callback = tf.keras.callbacks.EarlyStopping(monitor='loss', patience = 25)
    # compile the keras model
    model.compile(loss='mean_squared_error', optimizer='adam',metrics=['accuracy'])

    # fit the keras model on the dataset
    history = model.fit(X, y, epochs=500, callbacks=[callback])
    
    #Save accuracy metrics
    accuracy_model = history.history['accuracy'][-1]
    loss_model = history.history['loss'][-1]
    accuracy_recorder.insert(len(accuracy_recorder),accuracy_model)
    loss_recorder.insert(len(loss_recorder),loss_model)
    history_recorder.append(history.history)
    
    #Save Model and Weights
    NAME = "model-{}-2022-nodes".format(i)
    print(NAME)
    model.save(NAME)
    
# Identify model with the minimum loss    
min_loss_model_index = loss_recorder.index(min(loss_recorder))
min_loss_model_name = "model-{}-2022-nodes".format(min_loss_model_index)

min_loss_model = tf.keras.models.load_model(min_loss_model_name, custom_objects=None, compile=True)
pred_y = min_loss_model.predict(X)


plt.subplot(1,2,1)
plt.title('Measured Y values')
plt.plot(y)



plt.subplot(1,2,2)
plt.title('Predicted Y values')
plt.plot(pred_y)
plt.show()

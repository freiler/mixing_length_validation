import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

##Re 180##
#DNS
fdata = np.loadtxt('DNS_590')
plt.loglog(fdata[:,0],fdata[:,1],label='DNS')
'''
#StarCCM
nu = 2/13700
ut = np.sqrt(4.1634e-3)
fdata = pd.read_csv('channel_flow_180_u.csv')
ys = np.array(fdata['u'])
xs = np.array(fdata['y'])
xs = xs-1
xs = np.abs(xs)
ys = ys/ut
xs = xs*ut/nu
plt.loglog(xs,ys,label='STARCCM')
'''
#1#
nu = 2/21600
x1 = np.array([0.1665,0.4995,0.8325])
y1 = np.array([0.84521,1.0526,1.1019])
ut1 = np.sqrt(0.0026762)
y1 = y1/ut1
x1 = x1*ut1/nu

plt.loglog(x1,y1,'o-',label='2_Coarse')

#2#
ut2 = np.sqrt(0.0027982)
v = np.linspace(0.333,1,21)
dx = 0.667/(2*20)
v += dx
v[1:] = v[0:-1]
v [0] = 0.1665 
x2 = v
x2 = x2*ut2/nu

fdata = pd.read_csv('2.csv')
y2 = np.array([fdata['u'][0]])
flag = y2[0]

for i in fdata['u']:
    if i!=flag:
        y2 = np.append(y2,i)
        flag = i
y2[:] = y2[::-1]

y2 = y2/ut2
plt.loglog(x2,y2,'o-',label='2_Fine')

#3#
x3 = np.array([0.1,0.3,0.5,0.7,0.9])
y3 = np.array([0.76731,0.98936,1.0544,1.0864,1.1025])
ut3 = np.sqrt(0.0026061)
y3 = y3/ut3
x3 = x3*ut3/nu

plt.loglog(x3,y3,'o-',label='3_Coarse')

#4#
ut4 = np.sqrt(0.0027334)
v = np.linspace(0.2,1,21)
dx = 0.8/(2*20)
v += dx
v[1:] = v[0:-1]
v [0] = 0.1
x4 = v
x4 = x4*ut4/nu

fdata = pd.read_csv('4.csv')
y4 = np.array([fdata['u'][0]])
flag = y4[0]

for i in fdata['u']:
    if i!=flag:
        y4 = np.append(y4,i)
        flag = i
y4[:] = y4[::-1]

y4 = y4/ut4
plt.loglog(x4,y4,'o-',label='3_Fine')

#5#
x5 = np.array([0.05,0.15,0.25,0.35,0.45,0.55,0.65,0.75,0.85,0.95])
y5 = np.array([0.66972,0.89743,0.97116,1.0128,1.0404,1.06,1.0744,1.0849,1.0923,1.097])
ut5 = np.sqrt(0.0025474)
y5 = y5/ut5
x5 = x5*ut5/nu

plt.loglog(x5,y5,'o-',label='4_Coarse')

#6#
ut6 = np.sqrt(0.0026434)
v = np.linspace(0.1,1,19)
dx = 0.9/(2*18)
v += dx
v[1:] = v[0:-1]
v [0] = 0.05
x6 = v
x6 = x6*ut6/nu

fdata = pd.read_csv('6.csv')
y6 = np.array([fdata['u'][0]])
flag = y6[0]

for i in fdata['u']:
    if i!=flag:
        y6 = np.append(y6,i)
        flag = i
y6[:] = y6[::-1]

y6 = y6/ut6
plt.loglog(x6,y6,'o-',label='4_Fine')



def dns(yplus,uplus, file):
    fdata = np.loadtxt(file)
    y = fdata[:,0]
    u = fdata[:,1]
    for i in range(len(y)):
        if y[i] > yplus:
            ymin = y[i-1]
            ymax = y[i]
            umin = u[i-1]
            umax = u[i]
            print(ymin,umin)
            break
    dns_u = (yplus-ymin)/(ymax-ymin) * (umax-umin) + umin
    error = np.abs((dns_u - uplus) / dns_u)
    print('The DNS u+ is: ',dns_u,'and the error is: ',error)

    
plt.ylabel('u+')
plt.xlabel('y+')
plt.legend()
plt.grid()




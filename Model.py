# -*- coding: utf-8 -*-
"""
Created on Mon Aug 14 16:08:47 2017

@author: xujing
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from  sklearn.cluster import KMeans
from sklearn.cross_validation import StratifiedKFold
import datetime

#矩阵化欧式距离

def EuclidDis1(A,B):
    BT = B.transpose()
    vecProd = A * BT
    SqA =  A.getA()**2
    sumSqA = np.matrix(np.sum(SqA, axis=1))
    sumSqAEx = np.tile(sumSqA.transpose(), (1, vecProd.shape[1]))    
    SqB = B.getA()**2
    sumSqB = np.sum(SqB, axis=1)
    sumSqBEx = np.tile(sumSqB, (vecProd.shape[0], 1))    
    SqED = sumSqBEx + sumSqAEx - 2*vecProd   
    ED = (SqED.getA())**0.5
    return np.matrix(ED)

#数据建模

def recomm(dfold,df,bh,ywy,topn,ncluster):
    clf = KMeans(n_clusters=ncluster,init = 'k-means++',random_state=123,max_iter=1000,algorithm="auto").fit(dfold)
    #label0 = clf.labels_
    #n_cluster = len(np.unique(label0))
    #N = len(label0)
    #Ni0=[]
     
    #dist = np.zeros((n_cluster,np.shape(df)[0]))
    #bh = df.ajbh
    #recommond = {}
    #recommond_last = []
    A = np.matrix(clf.cluster_centers_)
    B = np.matrix(df)
    dist = EuclidDis1(A, B)
    dist = np.array(dist)
    
    #for i in np.arange(0,n_cluster):
        #Ni0.append([i,len(label0[label0 ==i])])
        #dist_sort=[]
        # for j in np.arange(0,np.shape(df)[0]):
        #     dist[i][j] = np.linalg.norm(clf.cluster_centers_[i]-map(float,np.array(df.iloc[j])))
                
    dist1 = dist.copy()
    dist_sort = pd.DataFrame({'bh':bh,'cluster':list(np.argmax(dist1,axis=0)),'distance':list(np.max(dist1,axis=0))})
    N = len(list(dist_sort.bh))
    Ni = pd.DataFrame(dist_sort.cluster.value_counts())
    Ni.reset_index(inplace=True)
    Ni.rename(columns={"index":0,"cluster":1},inplace=True)
    #Ni =pd.DataFrame(np.array(Ni0))
    Ni.rename(columns={0:'class',1:'counts'},inplace=True)

    dist_sort["group_sort"] = dist_sort['distance'].groupby(dist_sort['cluster']).rank(ascending=1,method='first')
    
    dist_sort = dist_sort.merge(Ni,left_on='cluster',right_on='class',how="left")
    
        
    dist_sort1 = dist_sort.groupby('cluster').apply(lambda x: x[x.group_sort <= topn*x.counts/float(N)])    #可能会出bug

 
    recommend = pd.DataFrame({'bh':np.array(dist_sort1['bh']),'ywy':list(np.unique(ywy))*len(np.array(dist_sort1['bh']))})
    
    #print u"*************************法务员：%s 的智能推荐案件******************************" %np.unique(ywy)   
    #print recommend
    #print "==============================================================================="
    #print '===========智能推荐结果会保存在本地D盘IntelligentRecommendationSystem.xlsx=========='
    return recommend



def IRSwritedb(dfold0,df0,bhywy0,ncluster):
    recommend_last  =pd.DataFrame({"bh":[np.NaN],"ywy":[np.NaN]})
    dflst = df0.copy()
    ywylist = list(np.unique(list(bhywy0.ywy0)))
    #li = []
    for ywy in ywylist:
        if len(list(df0.ajbh)) >=1:
            dfold = dfold0[dfold0.ywy0==ywy]
            dfold1 = dfold.drop("ywy0",axis=1)
            dfold2 = dfold1.drop("ajbh",axis=1)
            bh = list(df0.ajbh)
            df1 =df0.drop('ajbh',axis=1)
            df2 = df1.drop('ywy0',axis=1)
            topn = int(np.unique(list(bhywy0[bhywy0.ywy0== ywy].topn0)))
            recommend = recomm(dfold2,df2,bh,ywy,topn,ncluster)
            recommend_last = recommend_last.append(recommend)
            #df0 = df0[[list(df0.ajbh)[i] not in list(recommend.bh)  for i in xrange(0,len(list(df0.ajbh)))]] 慢的原因在这
            df0 = df0[np.invert(df0['ajbh'].isin(list(recommend.bh)))]
            
            #li.append(ywy)
            #lil = np.ceil(len(li)/float(len(ywylist)))*100
            #view_bar(lil, 100)

    recommend_last.reset_index(drop=True,inplace=True)
    set1 = set(recommend_last.bh)
    set2 = set(dflst.ajbh)
    if len(set2-set1) == 0:
        recommend_last1 = recommend_last
    else:
        dfno=pd.DataFrame({'bh':list(set2-set1),'ywy':list(np.random.choice ( ywylist,size=len(set2-set1)))})
        frames = [recommend_last,dfno]
        recommend_last1 = pd.concat(frames)

    writer = pd.ExcelWriter('D:/IntelligentRecommendationSystem.xlsx', engine='xlsxwriter')
    recommend_last1.to_excel(writer, sheet_name='Sheet1')
    writer.save()
  
    
  
    

#数据读入

realdb = pd.read_csv("data/realdata1.csv")
df = realdb.copy()

df.rename(columns={"ywy":"ywy0"},inplace=True)

topn = np.ceil(df.shape[0]/float(len(np.unique(list(df.ywy0)))))

bhywy0 = pd.DataFrame({'ajbh0':list(df.ajbh),'ywy0':list(df.ywy0),'topn0':topn})

df0=df
#df0.rename(columns={"ywy":"ywy0"},inplace=True)
dfold0=df0.copy()

IRSwritedb(df0,df0,bhywy0,5)





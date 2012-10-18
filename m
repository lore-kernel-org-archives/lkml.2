Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2JRCaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:30:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16570 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2JRCaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:30:11 -0400
X-AuditID: cbfee60f-b7f656d000001a3b-56-507f69b1f84c
Date: Thu, 18 Oct 2012 02:30:09 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM / OPP: predictable fail results for opp_find* functions
To: Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121018022815467@myungjoo.ham
Msgkey: 20121018022815467@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121018022815467@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25178027.160161350527407382.JavaMail.weblogic@epml06>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zLd2NmfUBBgf7dSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG/CXr2Qoe8VV0zrrN0sC4hq+LkZNDSEBdYtGSk2wgtoSAicTi
	66eZIWwxiQv31gPFuYBqljFKXP78kBmmaN7jj+wQifmMEotvfWIHSbAIqEpc/7+FtYuRg4NN
	QE9i5udkkLCwgL/Ep4PXwUpEBCIlmm/sZAbpZRY4xSjx4OkmNogrlCTW7HvFAmLzCghKnJz5
	hAVimarErwer2SDiahIrDr9nh4hLSMyafoEVwuaVmNH+FKpeTmLa1zVQh0pLnJ+1gRHmm8Xf
	H0PF+SWO3d7BBHInSO+T+8EwY3Zv/gINCAGJqWcOQrVqSaxovgM1nk9izcK3LDBjdp1azgzT
	e3/LXCYQm1lAUWJK90N2CFtL4suPfWzo3uIVcJKY+LWLaQKj8iwkqVlI2mchaUdWs4CRZRWj
	aGpBckFxUnqqqV5xYm5xaV66XnJ+7iZGSGLg38G4qMHiEKMAB6MSD2/A0toAIdbEsuLK3EOM
	EhzMSiK8Nc71AUK8KYmVValF+fFFpTmpxYcYfYAROJFZSjQ5H5i08kriDY0NjA0NLQ3NTC1N
	DXAIK4nzlnmkBAgJpCeWpGanphakFsGMY+LglGpgzOtVONTIs/bk+eeiTGe6bacwam/Y6/BW
	pWmS78sdov+Cnuke/7mi+M3s1HbdycanGQ5n9MQeseRdWVR+ySZr35bH1RtnSIdeiTRKZ+B6
	Kdf+5vbblOTnOd3LV1vXNak8D/u1+5eq/DXNw3rRTyefaSzKOu6zw/L+2zkshhPmBQuV3Pzc
	HmG4XYmlOCPRUIu5qDgRABVWSho5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t/t6bobM+sDDDZ+Vbe4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GfOXrGcreMRX0TnrNksD4xq+LkZODiEBdYlFS06ygdgSAiYS8x5/ZIewxSQu3FsPFOcCqpnP
	KLH41iewBIuAqsT1/1tYuxg5ONgE9CRmfk4GCQsL+Et8OngdrEREIFKi+cZOZpBeZoFTjBIP
	nm5ig1imJLFm3ysWEJtXQFDi5MwnLBDLVCV+PVjNBhFXk1hx+D3UERISs6ZfYIWweSVmtD+F
	qpeTmPZ1DTOELS1xftYGRpijF39/DBXnlzh2ewcTyJ0gvU/uB8OM2b35C9S/AhJTzxyEatWS
	WNF8B2o8n8SahW9ZYMbsOrWcGab3/pa5TCA2s4CixJTuh+wQtpbElx/72NC9xSvgJDHxaxfT
	BEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9FRTveLE3OLSvHS95PzcTYzgFPWMfwfjogaL
	Q4wCHIxKPLwBS2sDhFgTy4orcw8xSnAwK4nw1jjXBwjxpiRWVqUW5ccXleakFh9i9AFG4ERm
	KdHkfGD6zCuJNzQ2MDY0tDQ3MDU0ssAhrCTOW+aREiAkkJ5YkpqdmlqQWgQzjomDU6qBcXKW
	6Ks56orspTc+vWzYw/IpY6+zt9t6TW4zi7er7vwNTGKcsMRYU3iRZvpblaBr2UKmvLGREVwX
	fBabJyTmHBV6evPTs07laHGuV8emsJetfnmvaZpT8p+wbQ3zd0jckW9yOjlx0k/jN3XL79dd
	us7wI9a/aHeW/QUGR/mPhWE2PB5GVw0uKrEUZyQaajEXFScCADvEKm1+AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9I2UKnS008188

> Currently the opp_find* functions return -ENODEV when:
> a) it cant find a device (e.g. request for an OPP search on device
>    which was not registered)
> b) When it cant find a match for the search strategy used
> 
> This makes life a little in-efficient for users such as devfreq
> to make reasonable judgement before switching search strategies.
> 
> So, standardize the return results as following:
>  -EINVAL for bad pointer parameters
>  -ENODEV when device cannot be found
>  -ERANGE when search fails
> 
> This has the following benefit for devfreq implementation:
> 
> Current code:
> opp = opp_find_freq_floor(dev, freq);
> /* Following search triggers even for un-registered device */
> if (opp == ERR_PTR(-ENODEV))
> 	opp = opp_find_freq_ceil(dev, freq);
> 
> Vs (after this change):
> opp = opp_find_freq_floor(dev, freq);
> /* Will only be triggered if search logic fails: intended usage */
> if (opp == ERR_PTR(-ERANGE))
> 	opp = opp_find_freq_ceil(dev, freq);
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Thanks.


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

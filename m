Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2LUIJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:09:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22752 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2LUIJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:09:47 -0500
X-AuditID: cbfee61b-b7f616d00000319b-6d-50d419493367
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        sylvester.nawrocki@gmail.com, thomas.abraham@linaro.org,
        t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v3] usb: phy: samsung: Add support to set pmu isolation
Date: Fri, 21 Dec 2012 13:46:18 +0530
Message-id: <1356077779-5759-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkRtdT8kqAwYc1shaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZZzqa2ApuMFTsf3RDtYGxk1cXYycHBICJhK/
	Nn9ngrDFJC7cW8/WxcjFISSwlFHi7beprDBFsy6vZgGxhQSmM0qsaDOEKJrMJLF74RawBJuA
	rkTT212MILaIgKzE4Su/mUGKmAXeMUt073rLDJIQFnCXePHhGlgDi4CqRGP/LHYQmxco3vLk
	INQZChJvbj9jhqgRkPg2+RBQPQdQXFZi0wGwmRICR9gkVk+4wwxRLylxcMUNlgmMggsYGVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAba6X/PpHcwrmqwOMQowMGoxMMbaXE5QIg1say4
	MvcQowQHs5IIL9NXoBBvSmJlVWpRfnxRaU5q8SFGH6BLJjJLiSbnA6MgryTe0NjE3NTY1NLI
	yMzUFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGWZOzbnUVPNfZGL0rKv1Uq6TAS7WA
	vXYv56v6hP8P5dTO9dHklT0tYFsYLRPkYSXbtzNt/sJHv5c4fzWZ6Sy62l+8dWLN8Wctd572
	XVPQ8Lg8gb2pv3jWscITIudYc/tLL/cdTW2tZdhS23c+Q0Q06a3KqbNrlmXVHvZcreP4IfxM
	+YlOk0AlluKMREMt5qLiRADS5mh2YQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQV1PySsBBqfOCltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxqq+B
	peAGT8X2RztYGxg3cXUxcnJICJhIzLq8mgXCFpO4cG89G4gtJDCdUWJFm2EXIxeQPZlJYvfC
	LWBFbAK6Ek1vdzGC2CICshKHr/xmBiliFnjHLNG96y0zSEJYwF3ixYdrYA0sAqoSjf2z2EFs
	XqB4y5ODTBDbFCTe3H7GPIGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4DB+Jr2D
	cVWDxSFGAQ5GJR7eSIvLAUKsiWXFlbmHGCU4mJVEeJm+AoV4UxIrq1KL8uOLSnNSiw8x+gBt
	n8gsJZqcD4yxvJJ4Q2MTc1NjU0sTCxMzSxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoY
	tyTUK29Zez62eb+HaMULD07D3S6tF2U+bXr+P0KHIXjl57NHvx2WMpDaUqG3Xa+VqZBLPCNZ
	Z8Nf/ra1Zzaka+fN/2g8mbdMiXVbj/UDjd15EsszqqvOp68KuRDZvKegRURFxFvU9LF94GvH
	Kzf8Ks5P0fSYEctZ6xh/56T6sqeWNgcML/IosRRnJBpqMRcVJwIABvULyZACAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:
 - Removed the phandle type of device node properties, instead using
   sub-nodes now.
 - Removed the property 'samsung,enable-mask' since it is SoC dependent
   (SoCs like S5PV210 and S3C64XX have different bits to enable/disable
   phy controller in comparison to exysno4210 onwards).
 - Maintaining the phy enable mask (which is SoC dependent) for device type phy
   and host type phy in the driver data.
 - Re-structuring to get device properties using sub-nodes for 'usbphy-pmu'

Changes from v1:
 - Changed the name of property for phy handler from'samsung,usb-phyctrl'
   to 'samsung,usb-phyhandle' to make it look more generic.
 - Similarly 'samsung,phyctrl-reg' is changed to 'samsung,phyhandle-reg'
 - Added a check for 'samsung,usb-phyhandle' before getting node from
   phandle.
 - Putting the node using 'of_node_put()' which had been missed.
 - Adding necessary check for the pointer in 'samsung_usbphy_set_isolation()'
   to avoid any NULL pointer dereferencing.
 - Unmapping the register ioremapped in 'samsung_usbphy_parse_dt_param()'.

Based on usb-next branch with Praveen Paneri's patches on top of it.
- http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/134476.html
- http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/131763.html

Vivek Gautam (1):
  usb: phy: samsung: Add support to set pmu isolation

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   28 ++++
 drivers/usb/phy/samsung-usbphy.c                   |  145 +++++++++++++++++---
 2 files changed, 152 insertions(+), 21 deletions(-)

-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2LRPds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:33:48 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46216 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2LRPdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:33:45 -0500
X-AuditID: cbfee61b-b7f616d00000319b-5a-50d08cd83eb5
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com, balbi@ti.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        p.paneri@samsung.com
Subject: [PATCH 0/2] ARM: Exynos5250: Enabling samsung usb phy
Date: Tue, 18 Dec 2012 21:09:40 +0530
Message-id: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkVvdGz4UAg5/HuSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyvg+Q7NgKUfF7b3CDYxd7F2MnBwSAiYSS/9N
	hrLFJC7cW8/WxcjFISSwlFHi4qx9zDBFp378YoFILGKU2DVjKhNIQkhgMpPE4feqIDabgK5E
	09tdjCC2iICqxOe2BewgDcwCfUwSF4/tBVshLGAnsfrRIRYQmwWo6OGa+UBxDg5eAQ+Jl5+9
	IZYpSLy5/YwZokRA4ttkkHIOoLisxKYDzCAjJQROsElMfDSNEaJeUuLgihssExgFFzAyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIDLHT/55J72Bc1WBxiFGAg1GJh/dn/PkAIdbEsuLK
	3EOMEhzMSiK8Cq0XAoR4UxIrq1KL8uOLSnNSiw8x+gBdMpFZSjQ5Hxj+eSXxhsYm5qbGppZG
	RmampjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwGvbPLzigqph+9xPDWTN+33PWXK7q
	NSvas4wXHU79du/+bInYeg2jFzfbvVsvqfLdL9ugKP1gu+gjbenPjr+XX47Vv/abpVq6seqJ
	y5bG/g1H7F5xPjoiwmrKP+eZJqul41m1H+cvHA3lXDfH+k5RsE+q38IHH40vTLkZIiE9V8zx
	OpP4OrkYJZbijERDLeai4kQAr18mbl4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAd3rPRcCDF7csbC4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj+wzN
	gqUcFbf3CjcwdrF3MXJySAiYSJz68YsFwhaTuHBvPVsXIxeHkMAiRoldM6YygSSEBCYzSRx+
	rwpiswnoSjS93cUIYosIqEp8blvADtLALNDHJHHx2F6wqcICdhKrHx0Cm8oCVPRwzXygOAcH
	r4CHxMvP3hDLFCTe3H7GPIGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4AB+Jr2D
	cVWDxSFGAQ5GJR7en/HnA4RYE8uKK3MPMUpwMCuJ8Cq0XggQ4k1JrKxKLcqPLyrNSS0+xOgD
	tHwis5Rocj4wuvJK4g2NTcxNjU0tTSxMzCxxCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRq
	YOw7oMYUpvjC8mOlKIdWlNYfbw850e09zp7sAgnies0a7xOjnq+3STD5NvXGmrlvitYbSn3y
	/s7bfEdorxTzu+OCsgEV/s/W8ClG/393Vnvxkifp6/IfWt5YO3uPctTVG5y66wTam/M8GWLn
	blnPGiE6p2ii5Wod2zueJw6vm7l3x9TMf4F7niqxFGckGmoxFxUnAgBVooUAjQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set enables the samsung-usbphy driver on exynos5250,
which enables the support for USB2 type and USB3 type phys.
The corresponding phy driver patches are available at:
 1) https://lkml.org/lkml/2012/12/18/201
 2) https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/024559.html

Tested this patch-set on exynos5250 with following patch-sets for
USB 2.0 and USB 3.0:
 - https://patchwork.kernel.org/patch/1794651/
 - https://lkml.org/lkml/2012/12/18/201
 - https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/024559.html
 - http://comments.gmane.org/gmane.linux.usb.general/76352
 - https://lkml.org/lkml/2012/12/13/492

Vivek Gautam (2):
  ARM: Exynos5250: Enabling samsung-usbphy driver
  ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy driver

 arch/arm/boot/dts/exynos5250.dtsi       |   23 +++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c  |    2 ++
 3 files changed, 26 insertions(+), 0 deletions(-)

-- 
1.7.6.5


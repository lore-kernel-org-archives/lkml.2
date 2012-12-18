Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2LRPEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:04:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48576 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab2LRPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:03:58 -0500
X-AuditID: cbfee61b-b7f616d00000319b-88-50d085ddc3d7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, av.tikhomirov@samsung.com,
        yulgon.kim@samsung.com, kishon@ti.com, p.paneri@samsung.com
Subject: [PATCH v2] Adding USB 3.0 DRD-phy support for exynos5250
Date: Tue, 18 Dec 2012 20:40:25 +0530
Message-id: <1355843426-13613-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkTvdu64UAgwsvRS0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgypg3tY+9YAd7xcs3B9gbGLvZuhg5OSQETCTO
	Hr3IDGGLSVy4tx4sLiSwlFFi+yk/mJrla+czdjFyAcWnM0rsa5nGDlE0mUni+nwDEJtNQFei
	6e0uRhBbREBW4vCV38wgDcwCP5gk7j37B9YgLOAoceriMyCbg4NFQFVix+0kkDCvgIfE4Q+d
	UEcoSLy5/QzMZhEQkPg2+RALSLkE0MxNB8BGSgicYJO42b6MCaJeUuLgihssExgFFzAyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIDLLT/55J72Bc1WBxiFGAg1GJh/dn/PkAIdbEsuLK
	3EOMEhzMSiK8b+IuBAjxpiRWVqUW5ccXleakFh9i9AG6ZCKzlGhyPjAC8kriDY1NzE2NTS2N
	jMxMTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgNONYEBgpa639vLB3l9HPaZphx2wm
	shUfSfMOya6oPaplq2peZH8mt/z5KsGP+xZW1h+MiI5fcjPvekuAlMKPk4uEHj/z/eURP/ON
	f47PjCmuZ39U+U7LFs5W53OZPuv3N+cr1r7/5weL/f3lslSVY9WB3rbwfpOzn7Z2f/yVNn2u
	wnO3m0/uKrEUZyQaajEXFScCAACmFb9fAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jQd27rRcCDC49YbW4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj3tQ+
	9oId7BUv3xxgb2DsZuti5OSQEDCRWL52PiOELSZx4d56oDgXh5DAdEaJfS3T2EESQgKTmSSu
	zzcAsdkEdCWa3u4CaxARkJU4fOU3M0gDs8APJol7z/6BNQgLOEqcuvgMyObgYBFQldhxOwkk
	zCvgIXH4QyczxDIFiTe3nzFPYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4iJ9J
	72Bc1WBxiFGAg1GJh/dn/PkAIdbEsuLK3EOMEhzMSiK8b+IuBAjxpiRWVqUW5ccXleakFh9i
	9AFaPpFZSjQ5HxhheSXxhsYm5qbGppYmFiZmljiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFw
	SjUwro33uj0jOusf9z37eescFq7by14r8qLw+Vxv0/0vM0/5pagGqU/Sa3xmcK9wOavrxV9b
	0o25NZdPvfInrcrnZecZ46SPFYFzCvfO+9egfiBNIv3enU8q/SFi3xzXJC09+9aqfqnHv1fG
	Fvecsus2fetRFXu19KrB36NbJE+YbH9swDT1Y9d9JiWW4oxEQy3mouJEADrg9k+PAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes form v1:
 - Moved architecture related patch out of this patch-set.
 - Replaced unnecessary multi-line macro definitions by
   single line definitions.
 - Creating new data structure for USB 3.0 phy type and embedding
   it in 'samsung_usbphy' structure.
 - Adding a flag in 'samsung_usbphy' structure to check if device
   has usb 3.0 type phy or not.
 - Restructuring probe sequence for USB 3.0 phy, such that we are
   initializing only when device has usb3.0 type phy.

This patchset is based on the following patch-sets:
 - https://lkml.org/lkml/2012/12/18/201
 - http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/134476.html
 - https://lkml.org/lkml/2012/12/18/187

Vivek Gautam (1):
  usb: phy: samsung: Add support for USB 3.0 phy for exynos5250

 drivers/usb/phy/samsung-usbphy.c |  339 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 337 insertions(+), 2 deletions(-)

-- 
1.7.6.5


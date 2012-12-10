Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2LJGUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:20:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63186 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2LJGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:20:36 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b6-50c57f3341e8
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: dianders@chromium.org, olof@lixom.net, grant.likely@secretlab.ca,
        thomas.abraham@linaro.org, kgene.kim@samsung.com,
        sameo@linux.intel.com, Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [RFC PATCH 3/3] dt: Document: Add optional MAX77686 operating mode
 bindings
Date: Mon, 10 Dec 2012 11:56:24 +0530
Message-id: <1355120784-31118-4-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.6.6.1
In-reply-to: <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkSte4/miAwco35haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjz/yX7AVtnBVv501lbmC8zN7FyMkhIWAi8enVb1YIW0ziwr31
	bF2MXBxCAksZJdo+/GeBKVr7eQUjRGIRo8TUBX0sEM5yJolHNw+AjWIT0JNY8O8rM4gtIhAs
	MftnA9goZoHdjBIP3iwBSwgLhEksO/GIDcRmEVCV6Hl4C2w3r4CrxMx/n6DWKUic/rAWbCin
	gJvE/Uv3WSG27WWU6DrcwgTRLCDxbfIhoAYOoAZZiU0HmEFqJAQus0ncvXcC6iFJiYMrbrBM
	YBRewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMwEE//eya9g3FVg8UhRgEORiUe3gDF
	owFCrIllxZW5hxglOJiVRHi5jh0JEOJNSaysSi3Kjy8qzUktPsToA3TJRGYp0eR8YJTklcQb
	GpuYmxqbWhoZmZma4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cDou5O1TnN/QBi3Tcz6
	VZUXJ/IaLvo3L5M9ZY3wpn6lw7sCZA2jZ07tz9wiI5ZgZVfIr7Nz9i/+1VX7Ou4fUlzPdvbm
	5A1nXFtF3q8Nda67ZHuzUYNDT7zs3e2/UrM9Xi5RU7T48ffNp5onU3OtO0VfF58PMeu+11CU
	5rL4V/m+Qv9YAU216flKLMUZiYZazEXFiQD9iYLXcQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgK5x/dEAg80LdSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxp75L9kL2jgr3s6bytzA
	eJm9i5GTQ0LARGLt5xWMELaYxIV769m6GLk4hAQWMUpMXdDHAuEsZ5J4dPMAWAebgJ7Egn9f
	mUFsEYFgidk/G8A6mAV2M0o8eLMELCEsECax7MQjNhCbRUBVoufhLVYQm1fAVWLmv08sEOsU
	JE5/WAs2lFPATeL+pfusENv2Mkp0HW5hmsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcJg/k97BuKrB4hCjAAejEg9vgOLRACHWxLLiytxDjBIczEoivFzHjgQI8aYkVlalFuXH
	F5XmpBYfYvQBOmsis5Rocj4wBvNK4g2NTcxNjU0tTSxMzCxxCCuJ8zZ7pAQICaQnlqRmp6YW
	pBbBjGPi4JRqYMzt3Hvt4iqtBWe1im5FLdikrasb/Oi2XdDPmmNugqcbly5gXLHK7u87w9zX
	UoHxKZNU+XNXm4ecC/WOPza15Ub4Gn6TBnl/7ug10T1tesw71yjesTf9trVH8XmZkOrfNzUW
	fNcdBWR2MnG8WVSs4czHxHnoWfQnR55HptYSLrdSJjG84z7/XImlOCPRUIu5qDgRANs2LEOg	AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documenatation for various operating mode capabilities of
the MAX77686 PMIC.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index c6a3469..f2867a9 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -13,6 +13,12 @@ Required properties:
 - interrupts : This i2c device has an IRQ line connected to the main SoC.
 - interrupt-parent : The parent interrupt controller.
 
+optional properties:
+- max77686-opmode : The regulators of max77686 have various operating mode
+  capabilities such as low power mode, standby mode (controlled by PWRREQ
+  signal) etc. Check the regulator CTRL register for the bits setting these
+  modes.
+
 Optional node:
 - voltage-regulators : The regulators of max77686 have to be instantiated
   under subnode named "voltage-regulators" using the following format.
-- 
1.7.8.6


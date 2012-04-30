Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab2D3Upy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:45:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61742 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2D3Upx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:45:53 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jj@chaosbits.net, dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging: rtl8192u Fix a typo.
Date: Mon, 30 Apr 2012 13:45:41 -0700
Message-Id: <1335818741-10706-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---

NOTE:
I had not realized that my previous applied patch had created a typo. Thanks to Larry Finger
for pointing this out to me. So either you take this one on top of the original and/or I send you
the original with the updated fix.

The below patch removes an "s" from "thanks" to make it proper.

 drivers/staging/rtl8192u/r8180_93cx6.c |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.h |    2 +-
 drivers/staging/rtl8192u/r8192U.h      |    2 +-
 drivers/staging/rtl8192u/r8192U_hw.h   |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.c   |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.h   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index 0e8ff75..3c515b7 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -14,7 +14,7 @@
 
    Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
 
-   We want to thanks the Authors of those projects and the Ndiswrapper
+   We want to thank the Authors of those projects and the Ndiswrapper
    project Authors.
 */
 
diff --git a/drivers/staging/rtl8192u/r8180_93cx6.h b/drivers/staging/rtl8192u/r8180_93cx6.h
index 3527d32..5cea51e 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.h
+++ b/drivers/staging/rtl8192u/r8180_93cx6.h
@@ -7,7 +7,7 @@
 	Parts of this driver are based on the rtl8180 driver skeleton from Patric Schenke & Andres Salomon
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-	We want to thanks the Authors of such projects and the Ndiswrapper project Authors.
+	We want to thank the Authors of such projects and the Ndiswrapper project Authors.
 */
 
 /*This files contains card eeprom (93c46 or 93c56) programming routines*/
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index adeb724..ebcb5b0 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -11,7 +11,7 @@
 
    Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-   We want to thanks the Authors of those projects and the Ndiswrapper
+   We want to thank the Authors of those projects and the Ndiswrapper
    project Authors.
 */
 
diff --git a/drivers/staging/rtl8192u/r8192U_hw.h b/drivers/staging/rtl8192u/r8192U_hw.h
index b0ee4dd..1bfe871 100644
--- a/drivers/staging/rtl8192u/r8192U_hw.h
+++ b/drivers/staging/rtl8192u/r8192U_hw.h
@@ -10,7 +10,7 @@
 	Parts of this driver are based on the Intel Pro Wireless
 	2100 GPL driver.
 
-	We want to thanks the Authors of those projects
+	We want to thank the Authors of those projects
 	and the Ndiswrapper project Authors.
 */
 
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 2ce0fc8..71f2d23 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -13,7 +13,7 @@
 
    Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
 
-   We want to thanks the Authors of those projects and the Ndiswrapper
+   We want to thank the Authors of those projects and the Ndiswrapper
    project Authors.
 */
 
diff --git a/drivers/staging/rtl8192u/r8192U_wx.h b/drivers/staging/rtl8192u/r8192U_wx.h
index 1388664..9f6b105 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.h
+++ b/drivers/staging/rtl8192u/r8192U_wx.h
@@ -7,7 +7,7 @@
 	Parts of this driver are based on the rtl8180 driver skeleton from Patric Schenke & Andres Salomon
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-	We want to thanks the Authors of such projects and the Ndiswrapper project Authors.
+	We want to thank the Authors of such projects and the Ndiswrapper project Authors.
 */
 
 /* this file (will) contains wireless extension handlers*/
-- 
1.7.5.4


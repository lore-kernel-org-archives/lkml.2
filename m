Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2KKMZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:25:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2KKMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:12 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 7/8] staging: line6: wrap lines to 80 chars in usbdefs.h
Date: Sun, 11 Nov 2012 13:24:45 +0100
Message-Id: <1352636686-31170-8-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/usbdefs.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index 353d59d..43eb540 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -83,11 +83,15 @@ enum {
 	LINE6_BIT(VARIAX),
 
 	LINE6_BITS_PRO = LINE6_BIT_BASSPODXTPRO | LINE6_BIT_PODXTPRO,
-	LINE6_BITS_LIVE = LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_PODXTLIVE | LINE6_BIT_PODX3LIVE,
-	LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE | LINE6_BIT_PODXTPRO,
+	LINE6_BITS_LIVE = LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_PODXTLIVE |
+			  LINE6_BIT_PODX3LIVE,
+	LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE |
+			      LINE6_BIT_PODXTPRO,
 	LINE6_BITS_PODX3ALL = LINE6_BIT_PODX3 | LINE6_BIT_PODX3LIVE,
 	LINE6_BITS_PODHDALL = LINE6_BIT_PODHD300 | LINE6_BIT_PODHD500,
-	LINE6_BITS_BASSPODXTALL	= LINE6_BIT_BASSPODXT |	LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_BASSPODXTPRO
+	LINE6_BITS_BASSPODXTALL	= LINE6_BIT_BASSPODXT |
+				  LINE6_BIT_BASSPODXTLIVE |
+				  LINE6_BIT_BASSPODXTPRO
 };
 
 /* device supports settings parameter via USB */
-- 
1.7.12.1


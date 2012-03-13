Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab2CMAsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:48:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:48240 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943Ab2CMAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 121/196] Staging: rtl8192su: add device ids
Date: Mon, 12 Mar 2012 20:20:34 -0400
Message-Id: <1331598109-31424-76-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Schilhabel <florian.c.schilhabel@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 15d93ed070125d51693f102a0f94045dcaf30d9b upstream.

This patch adds some device ids.
The list of supported devices was extracted from realteks driver package.
(0x050d, 0x815F) and (0x0df6, 0x004b) are not in the official list of
supported devices  and may not work correctly.
In case of problems with these, they should probably be removed from the list.

Signed-off-by: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/rtl8192su/r8192U_core.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index f4cc5f0..a813a7b 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -113,14 +113,30 @@ u32 rt_global_debug_component = \
 #define CAM_CONTENT_COUNT 8
 
 static const struct usb_device_id rtl8192_usb_id_tbl[] = {
-	/* Realtek */
-	{USB_DEVICE(0x0bda, 0x8171)},
-	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
-	{USB_DEVICE(0x0df6, 0x004b)},	/* WL-349 */
-	/* Guillemot */
-	{USB_DEVICE(0x06f8, 0xe031)},
-	//92SU
+	{USB_DEVICE(0x0bda, 0x8171)}, /* Realtek */
 	{USB_DEVICE(0x0bda, 0x8172)},
+	{USB_DEVICE(0x0bda, 0x8173)},
+	{USB_DEVICE(0x0bda, 0x8174)},
+	{USB_DEVICE(0x0bda, 0x8712)},
+	{USB_DEVICE(0x0bda, 0x8713)},
+	{USB_DEVICE(0x07aa, 0x0047)},
+	{USB_DEVICE(0x07d1, 0x3303)},
+	{USB_DEVICE(0x07d1, 0x3302)},
+	{USB_DEVICE(0x07d1, 0x3300)},
+	{USB_DEVICE(0x1740, 0x9603)},
+	{USB_DEVICE(0x1740, 0x9605)},
+	{USB_DEVICE(0x050d, 0x815F)},
+	{USB_DEVICE(0x06f8, 0xe031)},
+	{USB_DEVICE(0x7392, 0x7611)},
+	{USB_DEVICE(0x7392, 0x7612)},
+	{USB_DEVICE(0x7392, 0x7622)},
+	{USB_DEVICE(0x0DF6, 0x0045)},
+	{USB_DEVICE(0x0E66, 0x0015)},
+	{USB_DEVICE(0x0E66, 0x0016)},
+	{USB_DEVICE(0x0b05, 0x1786)},
+	/* these are not in the official list */
+	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
+	{USB_DEVICE(0x0df6, 0x004b)}, /* WL-349 */
 	{}
 };
 
-- 
1.7.9.3


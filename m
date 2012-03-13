Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab2CMAr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:47:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:48243 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab2CMAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 120/196] Staging: rtl8192su: remove device ids
Date: Mon, 12 Mar 2012 20:20:33 -0400
Message-Id: <1331598109-31424-75-git-send-email-paul.gortmaker@windriver.com>
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

commit 60b42de30ad6fb131dc8e9dbd11a8a9ea0ab394c upstream.

This patch removes some device-ids.
The list of unsupported devices was extracted from realteks driver package.
removed IDs are:
(0x0bda, 0x8192)
(0x0bda, 0x8709)
(0x07aa, 0x0043)
(0x050d, 0x805E)
(0x0df6, 0x0031)
(0x1740, 0x9201)
(0x2001, 0x3301)
(0x5a57, 0x0290)
These devices are _not_ rtl819su based.

Signed-off-by: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/rtl8192su/r8192U_core.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 7946cf6..f4cc5f0 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -115,22 +115,8 @@ u32 rt_global_debug_component = \
 static const struct usb_device_id rtl8192_usb_id_tbl[] = {
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8171)},
-	{USB_DEVICE(0x0bda, 0x8192)},
-	{USB_DEVICE(0x0bda, 0x8709)},
-	/* Corega */
-	{USB_DEVICE(0x07aa, 0x0043)},
-	/* Belkin */
-	{USB_DEVICE(0x050d, 0x805E)},
 	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
-	/* Sitecom */
-	{USB_DEVICE(0x0df6, 0x0031)},
 	{USB_DEVICE(0x0df6, 0x004b)},	/* WL-349 */
-	/* EnGenius */
-	{USB_DEVICE(0x1740, 0x9201)},
-	/* Dlink */
-	{USB_DEVICE(0x2001, 0x3301)},
-	/* Zinwell */
-	{USB_DEVICE(0x5a57, 0x0290)},
 	/* Guillemot */
 	{USB_DEVICE(0x06f8, 0xe031)},
 	//92SU
-- 
1.7.9.3


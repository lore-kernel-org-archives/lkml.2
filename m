Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1BFMcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:32:12 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:49782 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1BFMcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:32:08 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] eeepc-wmi: comments keymap to clarify the meaning of some keys
Date: Sun,  6 Feb 2011 13:30:48 +0100
Message-Id: <1296995448-5591-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995448-5591-1-git-send-email-corentincj@iksaif.net>
References: <1296995448-5591-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found while checking PDF manuals...

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index bbcbd0f..9445ec0 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -111,15 +111,15 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
-	{ KE_KEY, 0x5c, { KEY_F15 } },
+	{ KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
 	{ KE_KEY, 0x5d, { KEY_WLAN } },
 	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
 	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
 	{ KE_KEY, 0x88, { KEY_WLAN } },
 	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
-	{ KE_KEY, 0xe0, { KEY_PROG1 } },
-	{ KE_KEY, 0xe1, { KEY_F14 } },
+	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
+	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
 	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
 	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
 	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
-- 
1.7.4.rc3


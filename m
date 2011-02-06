Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1BFM3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:29:10 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:44644 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1BFM3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:06 -0500
X-Originating-IP: 217.70.178.35
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/18] eeepc-wmi: reorder keymap
Date: Sun,  6 Feb 2011 13:28:26 +0100
Message-Id: <1296995324-5462-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 4d38f98..350b7bc 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -74,18 +74,18 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 
 static const struct key_entry eeepc_wmi_keymap[] = {
 	/* Sleep already handled via generic ACPI code */
-	{ KE_KEY, 0x5d, { KEY_WLAN } },
-	{ KE_KEY, 0x32, { KEY_MUTE } },
-	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
-	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_IGNORE, NOTIFY_BRNDOWN_MIN, { KEY_BRIGHTNESSDOWN } },
 	{ KE_IGNORE, NOTIFY_BRNUP_MIN, { KEY_BRIGHTNESSUP } },
-	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
+	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
+	{ KE_KEY, 0x32, { KEY_MUTE } },
+	{ KE_KEY, 0x5c, { KEY_F15 } },
+	{ KE_KEY, 0x5d, { KEY_WLAN } },
 	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
+	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0xe0, { KEY_PROG1 } },
 	{ KE_KEY, 0xe1, { KEY_F14 } },
 	{ KE_KEY, 0xe9, { KEY_DISPLAY_OFF } },
-	{ KE_KEY, 0xe0, { KEY_PROG1 } },
-	{ KE_KEY, 0x5c, { KEY_F15 } },
 	{ KE_END, 0},
 };
 
-- 
1.7.4.rc3


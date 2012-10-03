Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2JCJ17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:27:59 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59321 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab2JCJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:27:55 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] asus-{nb-wmi|laptop}.c: sync keymaps
Date: Wed,  3 Oct 2012 11:26:26 +0200
Message-Id: <1349256392-20320-4-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
References: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this should be shared in another module...

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   36 ++++++++++++++++++------------------
 drivers/platform/x86/asus-nb-wmi.c |   24 ++++++++++++------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 68257ed..09c477a 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -304,40 +304,40 @@ static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{KE_KEY, 0x32, { KEY_MUTE } },
-	{KE_KEY, 0x33, { KEY_SWITCHVIDEOMODE } },
-	{KE_KEY, 0x34, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x33, { KEY_DISPLAYTOGGLE } }, /* LCD on */
+	{KE_KEY, 0x34, { KEY_DISPLAY_OFF } }, /* LCD off */
 	{KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{KE_KEY, 0x41, { KEY_NEXTSONG } },
-	{KE_KEY, 0x43, { KEY_STOPCD } },
+	{KE_KEY, 0x43, { KEY_STOPCD } }, /* Stop/Eject */
 	{KE_KEY, 0x45, { KEY_PLAYPAUSE } },
-	{KE_KEY, 0x4c, { KEY_MEDIA } },
+	{KE_KEY, 0x4c, { KEY_MEDIA } }, /* WMP Key */
 	{KE_KEY, 0x50, { KEY_EMAIL } },
 	{KE_KEY, 0x51, { KEY_WWW } },
 	{KE_KEY, 0x55, { KEY_CALC } },
 	{KE_IGNORE, 0x57, },  /* Battery mode */
 	{KE_IGNORE, 0x58, },  /* AC mode */
 	{KE_KEY, 0x5C, { KEY_SCREENLOCK } },  /* Screenlock */
-	{KE_KEY, 0x5D, { KEY_WLAN } },
-	{KE_KEY, 0x5E, { KEY_WLAN } },
-	{KE_KEY, 0x5F, { KEY_WLAN } },
+	{KE_KEY, 0x5D, { KEY_WLAN } }, /* WLAN Toggle */
+	{KE_KEY, 0x5E, { KEY_WLAN } }, /* WLAN Enable */
+	{KE_KEY, 0x5F, { KEY_WLAN } }, /* WLAN Disable */
 	{KE_KEY, 0x60, { KEY_SWITCHVIDEOMODE } },
-	{KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } },
-	{KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } },
-	{KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } },
-	{KE_KEY, 0x6B, { KEY_F13 } }, /* Lock Touchpad */
+	{KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } }, /* LCD Only */
+	{KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } }, /* CRT Only */
+	{KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } }, /* LCD + CRT */
+	{KE_KEY, 0x6B, { KEY_TOUCHPAD_TOGGLE } }, /* Lock Touchpad */
 	{KE_KEY, 0x6C, { KEY_SLEEP } }, /* Suspend */
 	{KE_KEY, 0x6D, { KEY_SLEEP } }, /* Hibernate */
 	{KE_IGNORE, 0x6E, },  /* Low Battery notification */
-	{KE_KEY, 0x7E, { KEY_BLUETOOTH } },
-	{KE_KEY, 0x7D, { KEY_BLUETOOTH } },
+	{KE_KEY, 0x7D, { KEY_BLUETOOTH } }, /* Bluetooth Enable */
+	{KE_KEY, 0x7E, { KEY_BLUETOOTH } }, /* Bluetooth Disable */
 	{KE_KEY, 0x82, { KEY_CAMERA } },
-	{KE_KEY, 0x88, { KEY_WLAN  } },
-	{KE_KEY, 0x8A, { KEY_PROG1 } },
+	{KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
+	{KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
 	{KE_KEY, 0x95, { KEY_MEDIA } },
 	{KE_KEY, 0x99, { KEY_PHONE } },
-	{KE_KEY, 0xc4, { KEY_KBDILLUMUP } },
-	{KE_KEY, 0xc5, { KEY_KBDILLUMDOWN } },
-	{KE_KEY, 0xb5, { KEY_CALC } },
+	{KE_KEY, 0xB5, { KEY_CALC } },
+	{KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
+	{KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{KE_END, 0},
 };
 
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b70425c..9f1caa7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -168,9 +168,9 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x34, { KEY_DISPLAY_OFF } }, /* LCD off */
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
-	{ KE_KEY, 0x43, { KEY_STOPCD } },
+	{ KE_KEY, 0x43, { KEY_STOPCD } }, /* Stop/Eject */
 	{ KE_KEY, 0x45, { KEY_PLAYPAUSE } },
-	{ KE_KEY, 0x4c, { KEY_MEDIA } },
+	{ KE_KEY, 0x4c, { KEY_MEDIA } }, /* WMP Key */
 	{ KE_KEY, 0x50, { KEY_EMAIL } },
 	{ KE_KEY, 0x51, { KEY_WWW } },
 	{ KE_KEY, 0x55, { KEY_CALC } },
@@ -181,25 +181,25 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x5E, { KEY_WLAN } }, /* Wireless console Enable */
 	{ KE_KEY, 0x5F, { KEY_WLAN } }, /* Wireless console Disable */
 	{ KE_KEY, 0x60, { KEY_SWITCHVIDEOMODE } },
-	{ KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } },
-	{ KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } },
-	{ KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } }, /* LCD Only */
+	{ KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } }, /* CRT Only */
+	{ KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } }, /* LCD + CRT */
 	{ KE_KEY, 0x6B, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_IGNORE, 0x6E, },  /* Low Battery notification */
-	{ KE_KEY, 0x7D, { KEY_BLUETOOTH } },
-	{ KE_KEY, 0x7E, { KEY_BLUETOOTH } },
+	{ KE_KEY, 0x7D, { KEY_BLUETOOTH } }, /* Bluetooth Enable */
+	{ KE_KEY, 0x7E, { KEY_BLUETOOTH } }, /* Bluetooth Disable */
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
-	{ KE_KEY, 0x88, { KEY_RFKILL  } },
-	{ KE_KEY, 0x8A, { KEY_PROG1 } },
+	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
+	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
 	{ KE_KEY, 0x95, { KEY_MEDIA } },
 	{ KE_KEY, 0x99, { KEY_PHONE } },
 	{ KE_KEY, 0xA0, { KEY_SWITCHVIDEOMODE } }, /* SDSP HDMI only */
 	{ KE_KEY, 0xA1, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + HDMI */
 	{ KE_KEY, 0xA2, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + HDMI */
 	{ KE_KEY, 0xA3, { KEY_SWITCHVIDEOMODE } }, /* SDSP TV + HDMI */
-	{ KE_KEY, 0xb5, { KEY_CALC } },
-	{ KE_KEY, 0xc4, { KEY_KBDILLUMUP } },
-	{ KE_KEY, 0xc5, { KEY_KBDILLUMDOWN } },
+	{ KE_KEY, 0xB5, { KEY_CALC } },
+	{ KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
+	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{ KE_END, 0},
 };
 
-- 
1.7.8.6


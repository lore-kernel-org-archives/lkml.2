Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2ARToa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:44:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab2ARTo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:44:26 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] toshiba_acpi: Support additional hotkey scancodes
Date: Wed, 18 Jan 2012 13:44:10 -0600
Message-Id: <1326915852-19896-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
References: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Azael Avalos <coproscefalo@gmail.com>

These scancodes are used by many of the models now supported with
the addition of TOS1900 device support.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 1d83884..6824bf7 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -150,6 +150,8 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_KEY, 0x101, { KEY_MUTE } },
 	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
 	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{ KE_KEY, 0x12c, { KEY_KBDILLUMTOGGLE } },
+	{ KE_KEY, 0x139, { KEY_ZOOMRESET } },
 	{ KE_KEY, 0x13b, { KEY_COFFEE } },
 	{ KE_KEY, 0x13c, { KEY_BATTERY } },
 	{ KE_KEY, 0x13d, { KEY_SLEEP } },
@@ -158,7 +160,7 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_KEY, 0x140, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
 	{ KE_KEY, 0x142, { KEY_WLAN } },
-	{ KE_KEY, 0x143, { KEY_PROG1 } },
+	{ KE_KEY, 0x143, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_KEY, 0x17f, { KEY_FN } },
 	{ KE_KEY, 0xb05, { KEY_PROG2 } },
 	{ KE_KEY, 0xb06, { KEY_WWW } },
@@ -168,6 +170,7 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_KEY, 0xb32, { KEY_NEXTSONG } },
 	{ KE_KEY, 0xb33, { KEY_PLAYPAUSE } },
 	{ KE_KEY, 0xb5a, { KEY_MEDIA } },
+	{ KE_IGNORE, 0x1430, { KEY_RESERVED } },
 	{ KE_END, 0 },
 };
 
-- 
1.7.8.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356Ab2CFDbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:31:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2CFDam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:30:42 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 2/3] toshiba_acpi: Support additional hotkey scancodes
Date: Mon,  5 Mar 2012 21:30:32 -0600
Message-Id: <1331004633-11862-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
References: <20120305220407.GA16312@ubuntu-macmini>
 <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
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
index f49330a..621b207 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -152,6 +152,8 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_KEY, 0x101, { KEY_MUTE } },
 	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
 	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{ KE_KEY, 0x12c, { KEY_KBDILLUMTOGGLE } },
+	{ KE_KEY, 0x139, { KEY_ZOOMRESET } },
 	{ KE_KEY, 0x13b, { KEY_COFFEE } },
 	{ KE_KEY, 0x13c, { KEY_BATTERY } },
 	{ KE_KEY, 0x13d, { KEY_SLEEP } },
@@ -160,7 +162,7 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_KEY, 0x140, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
 	{ KE_KEY, 0x142, { KEY_WLAN } },
-	{ KE_KEY, 0x143, { KEY_PROG1 } },
+	{ KE_KEY, 0x143, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_KEY, 0x17f, { KEY_FN } },
 	{ KE_KEY, 0xb05, { KEY_PROG2 } },
 	{ KE_KEY, 0xb06, { KEY_WWW } },
@@ -170,6 +172,7 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_KEY, 0xb32, { KEY_NEXTSONG } },
 	{ KE_KEY, 0xb33, { KEY_PLAYPAUSE } },
 	{ KE_KEY, 0xb5a, { KEY_MEDIA } },
+	{ KE_IGNORE, 0x1430, { KEY_RESERVED } },
 	{ KE_END, 0 },
 };
 
-- 
1.7.9


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2K2INk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:13:40 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:34065 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2K2INf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:13:35 -0500
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] asus-nb-wmi: correct a touchpad hotkey mapping
Date: Thu, 29 Nov 2012 09:12:34 +0100
Message-Id: <1354176759-630-7-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
References: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

0x60 is touchpad enable key, but is misdefined in the keymap.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-nb-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 9f1caa7..75ce18c 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -180,7 +180,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x5D, { KEY_WLAN } }, /* Wireless console Toggle */
 	{ KE_KEY, 0x5E, { KEY_WLAN } }, /* Wireless console Enable */
 	{ KE_KEY, 0x5F, { KEY_WLAN } }, /* Wireless console Disable */
-	{ KE_KEY, 0x60, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x60, { KEY_TOUCHPAD_ON } },
 	{ KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } }, /* LCD Only */
 	{ KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } }, /* CRT Only */
 	{ KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } }, /* LCD + CRT */
-- 
1.7.8.6


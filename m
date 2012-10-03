Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2JCJ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:28:10 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:49618 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab2JCJ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:28:04 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] asus-laptop: correct a touchpad hotkey mapping
Date: Wed,  3 Oct 2012 11:26:27 +0200
Message-Id: <1349256392-20320-5-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
References: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

0x60 is touchpad enable key, but is misdefined in the keymap.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 09c477a..73d0198 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -320,7 +320,7 @@ static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x5D, { KEY_WLAN } }, /* WLAN Toggle */
 	{KE_KEY, 0x5E, { KEY_WLAN } }, /* WLAN Enable */
 	{KE_KEY, 0x5F, { KEY_WLAN } }, /* WLAN Disable */
-	{KE_KEY, 0x60, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x60, { KEY_TOUCHPAD_ON } },
 	{KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } }, /* LCD Only */
 	{KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } }, /* CRT Only */
 	{KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } }, /* LCD + CRT */
-- 
1.7.8.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2CTIya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:54:30 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39076 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545Ab2CTIyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:16 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] asus-nb-wmi: set panel_power correctly
Date: Tue, 20 Mar 2012 09:53:11 +0100
Message-Id: <1332233594-13099-12-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenuc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if it's currently unused.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-nb-wmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b12038c..99a30b5 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/fb.h>
 
 #include "asus-wmi.h"
 
@@ -58,6 +59,7 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 {
 	driver->quirks = &quirk_asus_unknown;
 	driver->quirks->wapf = wapf;
+	driver->panel_power = FB_BLANK_UNBLANK;
 }
 
 static const struct key_entry asus_nb_wmi_keymap[] = {
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2BSPuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:50:00 -0500
Received: from eq4.michisoft.net ([178.63.1.138]:45886 "EHLO
	mail.michisoft.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754232Ab2BSPt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:49:58 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 10:49:58 EST
From: Michael Thalmeier <michael@thalmeier.at>
To: Peter Feuerer <peter@piie.net>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Thalmeier <michael@thalmeier.at>
Subject: [PATCH] acerhdf: add support for Acer Aspire 1810T BIOS v1.3314
Date: Sun, 19 Feb 2012 16:43:04 +0100
Message-Id: <1329666184-7336-1-git-send-email-michael@thalmeier.at>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in commit

b06862b: acerhdf: add support for Aspire 1810TZ BIOS v1.3314

Acer Aspire 1810T also supports Bios v1.3314.

Signed-off-by: Michael Thalmeier <michael@thalmeier.at>
---
 drivers/platform/x86/acerhdf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 760c6d7..e8df42f 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -183,6 +183,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 531 */
 	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
 	/* Gateway */
-- 
1.7.9


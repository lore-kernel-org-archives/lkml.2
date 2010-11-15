Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0KODFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1183 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab0KODFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:40 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: [PATCH 19/44] drivers/platform/x86: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:38 -0800
Message-Id: <eda82bcfaad265fc5cd3901bc4f41bfcfac2403b.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/classmate-laptop.c |    2 +-
 drivers/platform/x86/thinkpad_acpi.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 341cbfe..d2b7720 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -653,7 +653,7 @@ static void cmpc_keys_handler(struct acpi_device *dev, u32 event)
 
 	if ((event & 0x0F) < ARRAY_SIZE(cmpc_keys_codes))
 		code = cmpc_keys_codes[event & 0x0F];
-	inputdev = dev_get_drvdata(&dev->dev);;
+	inputdev = dev_get_drvdata(&dev->dev);
 	input_report_key(inputdev, code, !(event & 0x10));
 }
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2d61186..3cd7814 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6345,7 +6345,7 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 			"as change notification\n");
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 				| TP_ACPI_HKEY_BRGHTUP_MASK
-				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
+				| TP_ACPI_HKEY_BRGHTDWN_MASK);
 	return 0;
 }
 
-- 
1.7.3.1.g432b3.dirty


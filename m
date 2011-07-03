Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1GCBaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 21:30:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58541 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1GCBaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 21:30:19 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Massimo Dal Zotto <dz@debian.org>
Cc: linux-kernel@vger.kernel.org, Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] drivers: char: i8k: Use __packed
Date: Sun,  3 Jul 2011 13:30:05 +1200
Message-Id: <1309656605-20812-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced __attribute__ ((packed)) with __packed

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/char/i8k.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 6e40072..d9c93d4 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -103,11 +103,11 @@ static const struct file_operations i8k_fops = {
 
 struct smm_regs {
 	unsigned int eax;
-	unsigned int ebx __attribute__ ((packed));
-	unsigned int ecx __attribute__ ((packed));
-	unsigned int edx __attribute__ ((packed));
-	unsigned int esi __attribute__ ((packed));
-	unsigned int edi __attribute__ ((packed));
+	unsigned int ebx __packed;
+	unsigned int ecx __packed;
+	unsigned int edx __packed;
+	unsigned int esi __packed;
+	unsigned int edi __packed;
 };
 
 static inline const char *i8k_get_dmi_data(int field)
-- 
1.7.4.1


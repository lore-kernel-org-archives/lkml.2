Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0G0XwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:52:04 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29491 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0G0Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:59 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 07/15] Group defines only used by NMI sourcing together
Date: Tue, 27 Jul 2010 17:50:55 -0600
Message-Id: <1280274663-9160-8-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 796fcb8..f337c22 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -34,16 +34,16 @@
 #include <linux/notifier.h>
 #include <asm/cacheflush.h>
 
+#define SECS_TO_TICKS(secs) ((secs) * 1000 / 128)
+#define TICKS_TO_SECS(ticks) ((ticks) * 128 / 1000)
+#define HPWDT_MAX_TIMER	TICKS_TO_SECS(65535)
+#define HPWDT_VERSION			"1.1.1"
+
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324
 #define PCI_BIOS32_PARAGRAPH_LEN	16
 #define PCI_ROM_BASE1			0x000F0000
 #define ROM_SIZE			0x10000
-#define HPWDT_VERSION			"1.1.1"
-
-#define SECS_TO_TICKS(secs) ((secs) * 1000 / 128)
-#define TICKS_TO_SECS(ticks) ((ticks) * 128 / 1000)
-#define HPWDT_MAX_TIMER	TICKS_TO_SECS(65535)
 
 struct bios32_service_dir {
 	u32 signature;
-- 
1.7.1


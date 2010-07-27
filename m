Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0G0XwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:52:22 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44616 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0G0XwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:01 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 15/15] Bump version to 1.2.0
Date: Tue, 27 Jul 2010 17:51:03 -0600
Message-Id: <1280274663-9160-16-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making NMI sourcing a compile-time option is probably a significant-
enough change to warrant a minor version bump.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 68f5e37..e008788 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -39,7 +39,7 @@
 #define SECS_TO_TICKS(secs) ((secs) * 1000 / 128)
 #define TICKS_TO_SECS(ticks) ((ticks) * 128 / 1000)
 #define HPWDT_MAX_TIMER	TICKS_TO_SECS(65535)
-#define HPWDT_VERSION			"1.1.1"
+#define HPWDT_VERSION			"1.2.0"
 
 #ifdef CONFIG_HPWDT_NMI_DECODING
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
-- 
1.7.1


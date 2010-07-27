Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0G0XwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:52:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:41647 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0G0Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:59 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 05/15] Group together includes specific to NMI sourcing
Date: Tue, 27 Jul 2010 17:50:53 -0600
Message-Id: <1280274663-9160-6-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 391bb43..b8b791f 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -17,14 +17,11 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/nmi.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/kdebug.h>
 #include <linux/moduleparam.h>
-#include <linux/notifier.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/types.h>
@@ -32,6 +29,9 @@
 #include <linux/watchdog.h>
 #include <linux/dmi.h>
 #include <linux/spinlock.h>
+#include <linux/nmi.h>
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
 #include <asm/cacheflush.h>
 
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0G0XwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:52:19 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44595 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0G0Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:59 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 02/15] remove unnecessary includes
Date: Tue, 27 Jul 2010 17:50:50 -0600
Message-Id: <1280274663-9160-3-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 64ea6fc..fc81122 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -16,30 +16,20 @@
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/irq.h>
 #include <linux/nmi.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
-#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
 #include <linux/moduleparam.h>
 #include <linux/notifier.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
-#include <linux/reboot.h>
-#include <linux/sched.h>
-#include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
 #include <linux/dmi.h>
-#include <linux/efi.h>
-#include <linux/string.h>
-#include <linux/bootmem.h>
-#include <asm/desc.h>
 #include <asm/cacheflush.h>
 
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
-- 
1.7.1


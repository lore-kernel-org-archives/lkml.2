Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0G0XwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:52:17 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44598 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab0G0Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:59 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 03/15] include spinlock.h
Date: Tue, 27 Jul 2010 17:50:51 -0600
Message-Id: <1280274663-9160-4-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a spinlock, but lacked the include

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index fc81122..48bb536 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
 #include <linux/dmi.h>
+#include <linux/spinlock.h>
 #include <asm/cacheflush.h>
 
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
-- 
1.7.1


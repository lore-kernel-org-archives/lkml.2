Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1FILTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:19:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:41241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab1FILTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:19:15 -0400
Date: Thu, 9 Jun 2011 11:19:00 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-d49a40fb35042368fffd28c247fa82f07fa35ec4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ralf@linux-mips.org, mattst88@gmail.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, mattst88@gmail.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net
In-Reply-To: <20110601180610.608083130@duck.linux-mips.net>
References: <20110601180610.608083130@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] alpha: i8253: Cleanup remaining users of i8253pit.h
Git-Commit-ID: d49a40fb35042368fffd28c247fa82f07fa35ec4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:19:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d49a40fb35042368fffd28c247fa82f07fa35ec4
Gitweb:     http://git.kernel.org/tip/d49a40fb35042368fffd28c247fa82f07fa35ec4
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:04 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:50 +0200

alpha: i8253: Cleanup remaining users of i8253pit.h

The Alpha <asm/i8253pit.h> header is empty so this inclusion can just be
removed.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Link: http://lkml.kernel.org/r/20110601180610.608083130@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/alpha/kernel/sys_ruffian.c |    1 -
 arch/alpha/kernel/time.c        |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/sys_ruffian.c b/arch/alpha/kernel/sys_ruffian.c
index 8de1046..f33648e 100644
--- a/arch/alpha/kernel/sys_ruffian.c
+++ b/arch/alpha/kernel/sys_ruffian.c
@@ -26,7 +26,6 @@
 #include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
-#include <asm/8253pit.h>
 
 #include "proto.h"
 #include "irq_impl.h"
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 818e74e..de406c7 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -46,7 +46,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/hwrpb.h>
-#include <asm/8253pit.h>
 #include <asm/rtc.h>
 
 #include <linux/mc146818rtc.h>

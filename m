Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2D1JDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:03:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2D1JDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:03:18 -0400
Date: Sat, 28 Apr 2012 02:01:55 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-bda3bdc9afce46302810e12ca1790ce08b9c40ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, takata@linux-m32r.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        takata@linux-m32r.org, tglx@linutronix.de
In-Reply-To: <20120420124556.899547554@linutronix.de>
References: <20120420124556.899547554@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] m32r: Remove pointless function prototypes
Git-Commit-ID: bda3bdc9afce46302810e12ca1790ce08b9c40ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:02:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bda3bdc9afce46302810e12ca1790ce08b9c40ce
Gitweb:     http://git.kernel.org/tip/bda3bdc9afce46302810e12ca1790ce08b9c40ce
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:08 +0200

m32r: Remove pointless function prototypes

Already declared in include/linux/smp.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Link: http://lkml.kernel.org/r/20120420124556.899547554@linutronix.de
---
 arch/m32r/kernel/smpboot.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index cfdbe5d..31541c9 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -109,12 +109,8 @@ static unsigned int calibration_result;
 /* Function Prototypes                                                       */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
-void smp_prepare_boot_cpu(void);
-void smp_prepare_cpus(unsigned int);
 static void init_ipi_lock(void);
 static void do_boot_cpu(int);
-int __cpu_up(unsigned int);
-void smp_cpus_done(unsigned int);
 
 int start_secondary(void *);
 static void smp_callin(void);

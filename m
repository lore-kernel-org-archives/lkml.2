Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab2DTNJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:44750 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124556.899547554@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 01/18] m32r: Remove pointless function prototypes
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline; filename=m32r-remove-pointless-declaration.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Already declared in include/linux/smp.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/smpboot.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/arch/m32r/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6/arch/m32r/kernel/smpboot.c
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



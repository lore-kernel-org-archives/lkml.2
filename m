Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1IGGWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:22:46 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40330 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1IGGWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Wanlong Gao <wanlong.gao@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/55] rcu: Fix pathnames in documentation
Date: Tue,  6 Sep 2011 11:00:06 -0700
Message-Id: <1315332049-2604-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

The old "arch/i386" has long since become "arch/x86", so fix the
RCU documentation accordingly.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/NMI-RCU.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index 84e4f9c..687777f 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -5,8 +5,8 @@ Although RCU is usually used to protect read-mostly data structures,
 it is possible to use RCU to provide dynamic non-maskable interrupt
 handlers, as well as dynamic irq handlers.  This document describes
 how to do this, drawing loosely from Zwane Mwaikambo's NMI-timer
-work in "arch/i386/oprofile/nmi_timer_int.c" and in
-"arch/i386/kernel/traps.c".
+work in "arch/x86/oprofile/nmi_timer_int.c" and in
+"arch/x86/kernel/traps.c".
 
 The relevant pieces of code are listed below, each followed by a
 brief explanation.
-- 
1.7.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab1CXRtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:49:01 -0400
Received: from flusers.ccur.com ([173.221.59.2]:49929 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755108Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:04 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/24] jrcu: make global symbols static
Message-ID: <20110324174804.GA18950@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: make unnecessarily global symbols static.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -133,9 +133,9 @@ static struct rcu_stats {
 #define RCU_HZ_PERIOD_US	(USEC_PER_SEC / RCU_HZ)
 #define RCU_HZ_DELTA_US		(USEC_PER_SEC / (HZ * 3 / 2))
 
-int rcu_hz = RCU_HZ;
-int rcu_hz_period_us = RCU_HZ_PERIOD_US;
-int rcu_hz_delta_us = RCU_HZ_DELTA_US;
+static int rcu_hz = RCU_HZ;
+static int rcu_hz_period_us = RCU_HZ_PERIOD_US;
+static int rcu_hz_delta_us = RCU_HZ_DELTA_US;
 
 int rcu_scheduler_active __read_mostly;
 int rcu_nmi_seen __read_mostly;

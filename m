Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1LMAm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:42:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46333 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1LMAmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 6/6] cpu: Export cpu_up()
Date: Mon, 12 Dec 2011 16:42:24 -0800
Message-Id: <1323736944-32575-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111213004144.GA32120@linux.vnet.ibm.com>
 <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 11121300-3270-0000-0000-000002833194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Building rcutorture as a module requires cpu_up() as well as cpu_down()
exported, so apply EXPORT_SYMBOL_GPL().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cpu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 563f136..9d448dd 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -380,6 +380,7 @@ out:
 	cpu_maps_update_done();
 	return err;
 }
+EXPORT_SYMBOL_GPL(cpu_up);
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
-- 
1.7.8


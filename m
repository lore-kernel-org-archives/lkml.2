Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2FDMIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:08:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45477 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab2FDMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:08:45 -0400
From: fweisbec@gmail.com
To: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] rcu: Extended quiescent state for adaptive nohz
Date: Mon,  4 Jun 2012 14:08:26 +0200
Message-Id: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Paul, Ingo,

This is a rebase of the nohz cpusets RCU APIs on top of Paul's latest
-rcu (rcu/core) branch.

I have only built tested it yet, I need to do a full rebase of my
tree to test it in practice. But I wanted to show you how it looks
like first.

I also wonder if we can set that to a tree somewhere. Ingo suggested
to set up a tree on -tip to apply the uncontroversial part of nohz
cpusets patches and iterate from there. I think it would accelerate
everything if we start doing that.

Tell me what you think.

Thanks.

Frederic Weisbecker (2):
  rcu: New rcu_user_enter() and rcu_user_exit() APIs
  rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs

 include/linux/rcupdate.h |    4 +
 kernel/rcutree.c         |  184 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 163 insertions(+), 25 deletions(-)

-- 
1.7.5.4


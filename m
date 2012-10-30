Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab2J3Rc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34310 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2J3RcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/5] rcu: Wordsmith help text for RCU_USER_QS kernel parameter
Date: Tue, 30 Oct 2012 10:19:23 -0700
Message-Id: <1351617563-28506-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030171906.GA27431@linux.vnet.ibm.com>
 <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5C646
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

This commit adds a "try" missing from the end of the first paragraph
of the RCU_USER_QS help text.

[ paulmck: Also fix up the last paragraph a bit. ]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b63e798..ec62139 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -494,11 +494,11 @@ config RCU_USER_QS
 	  puts RCU in extended quiescent state when the CPU runs in
 	  userspace. It means that when a CPU runs in userspace, it is
 	  excluded from the global RCU state machine and thus doesn't
-	  to keep the timer tick on for RCU.
+	  try to keep the timer tick on for RCU.
 
 	  Unless you want to hack and help the development of the full
-	  tickless feature, you shouldn't enable this option. It adds
-	  unnecessary overhead.
+	  tickless feature, you shouldn't enable this option.  It also
+	  adds unnecessary overhead.
 
 	  If unsure say N
 
-- 
1.7.8


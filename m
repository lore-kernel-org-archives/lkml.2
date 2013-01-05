Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3AEREu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:04:50 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33150 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3AEREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:04:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Richard Braun <rbraun@sceen.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] Documentation: Memory barrier semantics of atomic_xchg()
Date: Sat,  5 Jan 2013 09:04:19 -0800
Message-Id: <1357405459-13675-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357405459-13675-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105170356.GA13534@linux.vnet.ibm.com>
 <1357405459-13675-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-3620-0000-0000-000000D182A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Braun <rbraun@sceen.net>

Add atomic_xchg() to documentation for atomic operations and
memory barriers.

Signed-off-by: Richard Braun <rbraun@sceen.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/atomic_ops.txt      |    2 ++
 Documentation/memory-barriers.txt |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 27f2b21..d9ca5be 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -253,6 +253,8 @@ This performs an atomic exchange operation on the atomic variable v, setting
 the given new value.  It returns the old value that the atomic variable v had
 just before the operation.
 
+atomic_xchg requires explicit memory barriers around the operation.
+
 	int atomic_cmpxchg(atomic_t *v, int old, int new);
 
 This performs an atomic compare exchange operation on the atomic value v,
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 3c4e1b3..fa5d8a9 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1685,6 +1685,7 @@ explicit lock operations, described later).  These include:
 
 	xchg();
 	cmpxchg();
+	atomic_xchg();
 	atomic_cmpxchg();
 	atomic_inc_return();
 	atomic_dec_return();
-- 
1.7.8


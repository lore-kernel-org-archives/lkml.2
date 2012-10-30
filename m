Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2J3QPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:15:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33001 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293Ab2J3QPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:15:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] rcu: Correct the name of a reference in list of RCU papers
Date: Tue, 30 Oct 2012 09:04:34 -0700
Message-Id: <1351613076-22022-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351613076-22022-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030160350.GA21837@linux.vnet.ibm.com>
 <1351613076-22022-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-9360-0000-0000-00000C361A15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhaval Giani <dhaval.giani@gmail.com>

Trying to go through the history of RCU (not for the weak
minded) led me to search for a non-existent paper.

Correct it to the actual reference

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/RTFP.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 7c1dfb1..7f40c72 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -186,7 +186,7 @@ Bibtex Entries
 
 @article{Kung80
 ,author="H. T. Kung and Q. Lehman"
-,title="Concurrent Maintenance of Binary Search Trees"
+,title="Concurrent Manipulation of Binary Search Trees"
 ,Year="1980"
 ,Month="September"
 ,journal="ACM Transactions on Database Systems"
-- 
1.7.8


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0IWAv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:51:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58562 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0IWAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 8/8] rcu: Add advice to PROVE_RCU_REPEATEDLY kernel config parameter
Date: Wed, 22 Sep 2010 17:50:53 -0700
Message-Id: <1285203053-22068-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PROVE_RCU_REPEATEDLY has no "Say Y"/"Say N" advice, so this commit
adds it.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/Kconfig.debug |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 52c2172..9886cf5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -539,6 +539,10 @@ config PROVE_RCU_REPEATEDLY
 	 disabling, allowing multiple RCU-lockdep warnings to be printed
 	 on a single reboot.
 
+	 Say Y to allow multiple RCU-lockdep warnings per boot.
+
+	 Say N if you are unsure.
+
 config SPARSE_RCU_POINTER
 	bool "RCU debugging: sparse-based checks for pointer usage"
 	default n
-- 
1.7.0.6


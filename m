Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1C1STD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:19:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:42900 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab1C1STB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:19:01 -0400
Date: Mon, 28 Mar 2011 18:18:49 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, randy.dunlap@oracle.com
In-Reply-To: <20110318093356.b939558d.randy.dunlap@oracle.com>
References: <20110318093356.b939558d.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Fix new kernel-doc warnings
Message-ID: <tip-30398bf6c684a77274dbdabf7efc1f24e4a99028@git.kernel.org>
Git-Commit-ID: 30398bf6c684a77274dbdabf7efc1f24e4a99028
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Mar 2011 18:18:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30398bf6c684a77274dbdabf7efc1f24e4a99028
Gitweb:     http://git.kernel.org/tip/30398bf6c684a77274dbdabf7efc1f24e4a99028
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Fri, 18 Mar 2011 09:33:56 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Mar 2011 20:13:57 +0200

genirq: Fix new kernel-doc warnings

Fix new irq-related kernel-doc warnings in 2.6.38:

Warning(kernel/irq/manage.c:149): No description found for parameter 'mask'
Warning(kernel/irq/manage.c:149): Excess function parameter 'cpumask' description in 'irq_set_affinity'
Warning(include/linux/irq.h:161): No description found for parameter 'state_use_accessors'
Warning(include/linux/irq.h:161): Excess struct/union/enum/typedef member 'state_use_accessor' description in 'irq_data'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <20110318093356.b939558d.randy.dunlap@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    2 +-
 kernel/irq/manage.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 34b954e..b3741c8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -135,7 +135,7 @@ struct msi_desc;
  * struct irq_data - per irq and irq chip data passed down to chip functions
  * @irq:		interrupt number
  * @node:		node index useful for balancing
- * @state_use_accessor: status information for irq chip functions.
+ * @state_use_accessors: status information for irq chip functions.
  *			Use accessor functions to deal with it
  * @chip:		low level interrupt hardware access
  * @handler_data:	per-IRQ data for the irq_chip methods
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 6e8acb7..805c6a0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -175,7 +175,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 /**
  *	irq_set_affinity - Set the irq affinity of a given irq
  *	@irq:		Interrupt to set affinity
- *	@cpumask:	cpumask
+ *	@mask:		cpumask
  *
  */
 int irq_set_affinity(unsigned int irq, const struct cpumask *mask)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab1CRQeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:34:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45545 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab1CRQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:34:05 -0400
Date: Fri, 18 Mar 2011 09:33:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] IRQ: fix new kernel-doc warnings
Message-Id: <20110318093356.b939558d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D838976.01CB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new irq-related kernel-doc warnings in 2.6.38:

Warning(kernel/irq/manage.c:149): No description found for parameter 'mask'
Warning(kernel/irq/manage.c:149): Excess function parameter 'cpumask' description in 'irq_set_affinity'
Warning(include/linux/irq.h:161): No description found for parameter 'state_use_accessors'
Warning(include/linux/irq.h:161): Excess struct/union/enum/typedef member 'state_use_accessor' description in 'irq_data'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    2 +-
 kernel/irq/manage.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.38-git4.orig/include/linux/irq.h
+++ linux-2.6.38-git4/include/linux/irq.h
@@ -134,7 +134,7 @@ struct msi_desc;
  * struct irq_data - per irq and irq chip data passed down to chip functions
  * @irq:		interrupt number
  * @node:		node index useful for balancing
- * @state_use_accessor: status information for irq chip functions.
+ * @state_use_accessors: status information for irq chip functions.
  *			Use accessor functions to deal with it
  * @chip:		low level interrupt hardware access
  * @handler_data:	per-IRQ data for the irq_chip methods
--- linux-2.6.38-git4.orig/kernel/irq/manage.c
+++ linux-2.6.38-git4/kernel/irq/manage.c
@@ -142,7 +142,7 @@ irq_get_pending(struct cpumask *mask, st
 /**
  *	irq_set_affinity - Set the irq affinity of a given irq
  *	@irq:		Interrupt to set affinity
- *	@cpumask:	cpumask
+ *	@mask:		cpumask
  *
  */
 int irq_set_affinity(unsigned int irq, const struct cpumask *mask)

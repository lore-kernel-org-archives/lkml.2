Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1HRTTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:19:32 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36578 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754089Ab1HRTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:19:30 -0400
Date: Thu, 18 Aug 2011 12:19:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] irqdesc: fix new kernel-doc warning
Message-Id: <20110818121927.33728f50.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning in irqdesc.c:

Warning(kernel/irq/irqdesc.c:353): No description found for parameter 'owner'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 kernel/irq/irqdesc.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.1-rc2-git4.orig/kernel/irq/irqdesc.c
+++ linux-3.1-rc2-git4/kernel/irq/irqdesc.c
@@ -344,6 +344,7 @@ EXPORT_SYMBOL_GPL(irq_free_descs);
  * @from:	Start the search from this irq number
  * @cnt:	Number of consecutive irqs to allocate.
  * @node:	Preferred node on which the irq descriptor should be allocated
+ * @owner:	Owning module (can be NULL)
  *
  * Returns the first irq number or error code
  */

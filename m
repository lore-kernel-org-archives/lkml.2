Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2BVQJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:09:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51054 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2BVQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:09:36 -0500
Date: Wed, 22 Feb 2012 08:08:15 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-vjqxst502pc1efz7ah8cyht4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ananth@in.ibm.com, jkenisto@linux.vnet.ibm.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jkenisto@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/uprobes] uprobes: Update copyright notices
Git-Commit-ID: 35aa621b5ab9d08767f7bc8d209b696df281d715
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:08:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35aa621b5ab9d08767f7bc8d209b696df281d715
Gitweb:     http://git.kernel.org/tip/35aa621b5ab9d08767f7bc8d209b696df281d715
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 22 Feb 2012 11:37:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 11:37:29 +0100

uprobes: Update copyright notices

Add Peter Zijlstra's copyright to the uprobes code, whose
contributions to the uprobes code are not visible in the Git
history, because they were backmerged.

Also update existing copyright notices to the year 2012.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-vjqxst502pc1efz7ah8cyht4@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/uprobes.h |    3 ++-
 kernel/events/uprobes.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 9c6be62..f85797e 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -17,10 +17,11 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
- * Copyright (C) IBM Corporation, 2008-2011
+ * Copyright (C) IBM Corporation, 2008-2012
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
+ * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  */
 
 #include <linux/errno.h>
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 13f1b59..5ce32e3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -15,10 +15,11 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
- * Copyright (C) IBM Corporation, 2008-2011
+ * Copyright (C) IBM Corporation, 2008-2012
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
+ * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  */
 
 #include <linux/kernel.h>

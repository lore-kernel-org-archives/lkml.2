Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1DGMkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:40:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:48131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1DGMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:45 -0400
Message-Id: <20110407120941.400629539@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 00/23] sched: Rewrite sched_domain/sched_group creation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series rewrite the sched_domain and sched_group creation code.

While its still not completely finished it does get us a lot of cleanups
and code reduction and seems fairly stable at this point and should thus
be a fairly good base to continue from.

Also available through:
  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git sched_domain

---
 include/linux/sched.h |   26 +-
 kernel/cpuset.c       |    2 +-
 kernel/sched.c        |  963 +++++++++++++++----------------------------------
 kernel/sched_fair.c   |   32 ++-
 4 files changed, 326 insertions(+), 697 deletions(-)




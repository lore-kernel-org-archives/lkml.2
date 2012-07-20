Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2GTSsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:48:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:17115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2GTSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="169050353"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] futex: Fix issues found with trinity and static analysis
Date: Fri, 20 Jul 2012 11:46:28 -0700
Message-Id: <cover.1342809673.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones and Dan Carpenter reported issues uncovered via trinity and static
analysis respectively.

The following changes since commit 85efc72a0218335324d358ac479a04c16316fd4d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2012-07-19 16:11:28 -0700)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-2.6.git futex

Darren Hart (3):
  futex: Test for pi_mutex on fault in futex_wait_requeue_pi
  futex: Fix bug in WARN_ON for NULL q.pi_state
  futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()

 kernel/futex.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

-- 
1.7.10.4


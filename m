Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2BGRej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:34:39 -0500
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:32965 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754338Ab2BGRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:34:38 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue,  7 Feb 2012 09:34:28 -0800
Message-Id: <1328636068-25497-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ib-srpt-fixes

This will get a few small cleanups and fixes for the srpt fabric
driver.  The driver is new for 3.3 so it makes sense to get this in
before the first release.

----------------------------------------------------------------
Cleanups and error path fixes for the new SRP (SCSI RDMA protocol) target.

----------------------------------------------------------------
Dan Carpenter (1):
      IB/srpt: Fix ERR_PTR() vs. NULL checking confusion

Jesper Juhl (2):
      IB/srpt: Remove unneeded <linux/version.h> include
      IB/srpt: Don't return freed pointer from srpt_alloc_ioctx_ring()

Roland Dreier (2):
      IB/srpt: Use DEFINE_SPINLOCK()/LIST_HEAD()
      IB/srpt: Use ARRAY_SIZE() instead of open-coding

 drivers/infiniband/ulp/srpt/ib_srpt.c |   17 +++++++----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 -
 2 files changed, 7 insertions(+), 11 deletions(-)

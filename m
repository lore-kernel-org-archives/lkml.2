Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2FXMJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 08:09:25 -0400
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:51222 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754160Ab2FXMJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 08:09:23 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Sun, 24 Jun 2012 05:09:13 -0700
Message-Id: <1340539753-19165-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-fixes

----------------------------------------------------------------

InfiniBand/RDMA fixes for 3.5-rc:
 - Fixes to new ocrdma driver
 - Typo in test in CMA

----------------------------------------------------------------
Dan Carpenter (1):
      RDMA/ocrdma: Fix off by one in ocrdma_query_gid()

Mahesh Vardhamanaiah (2):
      RDMA/ocrdma: Correct reported max queue sizes
      RDMA/ocrdma: Correct queue SGE calculation

Parav Pandit (2):
      RDMA/ocrdma: Fixed GID table for vlan and events
      RDMA/ocrdma: Fixed RQ error CQE polling

Roland Dreier (1):
      Merge branches 'cma' and 'ocrdma' into for-linus

Sean Hefty (1):
      RDMA/cma: QP type check on received REQs should be AND not OR

 drivers/infiniband/core/cma.c               |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   18 ++++----
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   63 +++++++++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    5 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   12 ++---
 6 files changed, 55 insertions(+), 46 deletions(-)

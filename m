Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab2FFRoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:44:25 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:40254 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752570Ab2FFRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:44:23 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Wed,  6 Jun 2012 10:44:07 -0700
Message-Id: <1339004647-16362-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337562868-9887-1-git-send-email-roland@kernel.org>
References: <1337562868-9887-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-fixes

----------------------------------------------------------------

InfiniBand/RDMA fixes for 3.5-rc2, all in hardware drivers:
 - Fix crash in cxgb4
 - Fixes to new ocrdma driver
 - Regression fixes for mlx4

----------------------------------------------------------------
Devendra Naga (1):
      RDMA/ocrdma: Remove unnecessary version.h includes

Jack Morgenstein (1):
      mlx4_core: Fix setting VL_cap in mlx4_SET_PORT wrapper flow

Parav Pandit (2):
      RDMA/ocrdma: Correct queue free count math
      RDMA/ocrdma: Fix signaled event for SRQ_LIMIT_REACHED

Roland Dreier (1):
      Merge branches 'cxgb4', 'mlx4' and 'ocrdma' into for-linus

Sagi Grimberg (1):
      IB/mlx4: Fix max_wqe capacity reported from query device

Shlomo Pongratz (1):
      IB/mlx4: Fix EQ deallocation in legacy mode

Thadeu Lima de Souza Cascardo (1):
      RDMA/cxgb4: Fix crash when peer address is 0.0.0.0

 drivers/infiniband/hw/cxgb4/cm.c            |    4 ++++
 drivers/infiniband/hw/mlx4/main.c           |   21 ++++++++-------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h        |    8 ++++++++
 drivers/infiniband/hw/mlx4/qp.c             |   21 +++++++++++++++------
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |    5 +----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    9 +--------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    5 -----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |    1 -
 drivers/net/ethernet/mellanox/mlx4/port.c   |    4 ++--
 11 files changed, 39 insertions(+), 41 deletions(-)

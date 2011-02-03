Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1BCSFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:05:53 -0500
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:46798 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756418Ab1BCSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:05:52 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu,  3 Feb 2011 10:05:48 -0800
Message-Id: <1296756348-6351-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small things:
 - Low-level driver fixes to qib, cxgb4 and amso1100
 - Add PCI IDs for new Mellanox devices to mlx4
 - Add a dropped hunk of Tejun's workqueue conversion
 - Fix route query for iWARP connections

Mitko Haralanov (1):
      IB/qib: Hold link for TX SERDES settings

Ralf Thielow (1):
      RDMA/amso1100: Fix compile warnings

Roland Dreier (1):
      Merge branches 'amso1100', 'cma', 'cxgb4', 'misc', 'mlx4' and 'qib' into for-next

Steve Wise (3):
      RDMA/cxgb4: Limit MAXBURST EQ context field to 256B
      RDMA/cxgb4: Set the correct device physical function for iWARP connections
      RDMA/ucma: Copy iWARP route information on queries

Tejun Heo (1):
      RDMA: Update missed conversion of flush_scheduled_work()

Yevgeny Petrilin (1):
      mlx4_core: Add ConnectX-3 device IDs

 drivers/infiniband/core/sa_query.c      |    2 +-
 drivers/infiniband/core/ucma.c          |   22 ++++++++++++++++++++--
 drivers/infiniband/hw/amso1100/c2_vq.c  |    6 +++---
 drivers/infiniband/hw/cxgb4/cm.c        |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c        |    4 ++--
 drivers/infiniband/hw/qib/qib_iba7322.c |   30 +++++++++++-------------------
 drivers/net/mlx4/main.c                 |   15 +++++++++++++++
 7 files changed, 53 insertions(+), 28 deletions(-)

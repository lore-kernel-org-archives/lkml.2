Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1FUQSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:18:16 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:38715 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751707Ab1FUQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:18:13 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 21 Jun 2011 09:18:06 -0700
Message-Id: <1308673086-7125-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes for the cxgb4 and qib hardware device drivers.

Mitko Haralanov (1):
      IB/qib: Ensure that LOS and DFE are being turned off

Roland Dreier (1):
      Merge branches 'cxgb4' and 'qib' into for-next

Steve Wise (3):
      RDMA/cxgb4: Don't exceed hw IQ depth limit for user CQs
      RDMA/cxgb4: Don't truncate MR lengths
      RDMA/cxgb4: Couple of abort fixes

 drivers/infiniband/hw/cxgb4/cm.c        |   46 +++++++++++++++++++++++++------
 drivers/infiniband/hw/cxgb4/cq.c        |    4 +++
 drivers/infiniband/hw/cxgb4/mem.c       |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c        |    5 +---
 drivers/infiniband/hw/qib/qib_iba7322.c |   25 ++++++++++++-----
 drivers/infiniband/hw/qib/qib_intr.c    |    6 +++-
 6 files changed, 66 insertions(+), 22 deletions(-)

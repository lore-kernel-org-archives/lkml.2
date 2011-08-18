Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1HRPy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:54:58 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:60234 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755278Ab1HRPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:54:57 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 18 Aug 2011 08:54:48 -0700
Message-Id: <1313682888-5108-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes:
 - Fix for crash on boot in IPoIB from Bernd Schubert
 - Two iSER bugs from Or Gerlitz

Bernd Schubert (1):
      IPoIB: Fix possible NULL dereference in ipoib_start_xmit()

Or Gerlitz (2):
      IBiser: Fix wrong mask when sizeof (dma_addr_t) > sizeof (unsigned long)
      IB/iser: Support iSCSI PDU padding

Roland Dreier (1):
      Merge branches 'ipoib' and 'iser' into for-next

 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    8 +++++---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   10 +++++++---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

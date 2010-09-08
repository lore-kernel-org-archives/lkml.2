Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0IHVpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:45:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41969 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab0IHVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:45:41 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALqgh0yrR7Ht/2dsb2JhbAChI3GlOJs3hT0EhESFWg
X-IronPort-AV: E=Sophos;i="4.56,335,1280707200"; 
   d="scan'208";a="585721633"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Sep 2010 14:45:38 -0700
Message-ID: <adak4mvj4e5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small driver fixes.

Chien Tung (1):
      RDMA/nes: Write correct register write to set TX pause param

Faisal Latif (3):
      RDMA/nes: Fix double CLOSE event indication crash
      RDMA/nes: Change state to closing after FIN
      RDMA/nes: Fix hang with modified FIN handling on A0 cards

Roland Dreier (1):
      Merge branches 'cxgb3' and 'nes' into for-linus

Steve Wise (1):
      RDMA/cxgb3: Don't exceed the max HW CQ depth

 drivers/infiniband/hw/cxgb3/cxio_hal.h |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c     |   18 ++++++++++--------
 drivers/infiniband/hw/nes/nes_hw.c     |   14 +++++++++++++-
 drivers/infiniband/hw/nes/nes_hw.h     |    1 +
 drivers/infiniband/hw/nes/nes_nic.c    |    4 ++--
 5 files changed, 27 insertions(+), 12 deletions(-)

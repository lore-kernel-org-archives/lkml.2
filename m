Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0LBS5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:57:46 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:17140 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab0LBS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:57:45 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEN790yrRN+J/2dsb2JhbACjJHGneJsdhUcEhF6GCQ
X-IronPort-AV: E=Sophos;i="4.59,289,1288569600"; 
   d="scan'208";a="226684635"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 02 Dec 2010 10:57:40 -0800
Message-ID: <aday688knob.fsf@cisco.com>
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

Just a few small things here:

 - Fix a minor leak of a few bytes of kernel stack
 - MAINTAINERS update
 - Fix a few small issues introduced with the merge of IBoE support in 2.6.37-rc1

Chien Tung (1):
      MAINTAINERS: Update NetEffect entry

Eli Cohen (4):
      IB/mlx4: Fix memory ordering of VLAN insertion control bits
      mlx4_core: Workaround firmware bug in query dev cap
      IB/mlx4: Fix IBoE reported link rate
      IB/mlx4: Fix IBoE link state

Or Gerlitz (1):
      IB/pack: Remove some unused code added by the IBoE patches

Roland Dreier (1):
      Merge branches 'misc', 'mlx4' and 'nes' into for-next

Vasiliy Kulikov (1):
      IB: Fix information leak in marshalling code

 MAINTAINERS                               |    3 +-
 drivers/infiniband/core/ud_header.c       |   30 -----------------------------
 drivers/infiniband/core/uverbs_marshall.c |    4 +++
 drivers/infiniband/hw/mlx4/main.c         |    4 +-
 drivers/infiniband/hw/mlx4/qp.c           |   10 ++++----
 drivers/net/mlx4/fw.c                     |    4 +++
 6 files changed, 16 insertions(+), 39 deletions(-)

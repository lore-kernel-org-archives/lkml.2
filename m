Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab0I0Qbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:31:46 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:27896 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0I0Qbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:31:45 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADVjoEyrR7Ht/2dsb2JhbACiLnGsBpw7hUQEhFCFag
X-IronPort-AV: E=Sophos;i="4.57,243,1283731200"; 
   d="scan'208";a="261228324"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 27 Sep 2010 09:31:40 -0700
Message-ID: <ada1v8f87wz.fsf@cisco.com>
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

This will get one cxgb3 driver fix:

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

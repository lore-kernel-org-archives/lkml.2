Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab0HIWpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:45:05 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:18707 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0HIWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:45:03 -0400
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEMiYEytJV2a/2dsb2JhbACgUXGoHJtbhToEhCY
X-IronPort-AV: E=Sophos;i="4.55,345,1278288000"; 
   d="scan'208";a="145478014"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Aug 2010 15:44:58 -0700
Message-ID: <adad3trz9qt.fsf@roland-alpha.cisco.com>
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

This will get one cxgb4 patch that I was holding until prerequisites
merged through the net tree.

Steve Wise (1):
      RDMA/cxgb4: Obtain RDMA QID ranges from LLD/FW

 drivers/infiniband/hw/cxgb4/device.c   |    9 +++++++--
 drivers/infiniband/hw/cxgb4/resource.c |    7 ++++---
 drivers/infiniband/hw/cxgb4/t4.h       |    2 --
 3 files changed, 11 insertions(+), 7 deletions(-)

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0DIQNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:13:48 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:13078 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0DIQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:13:44 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOzuvkurR7H+/2dsb2JhbACbOnGiKpkohQkEgyQ
X-IronPort-AV: E=Sophos;i="4.52,178,1270425600"; 
   d="scan'208";a="113011820"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Fri, 09 Apr 2010 09:13:40 -0700
Message-ID: <adaiq80txhn.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small fixes that have trickled in:

Chien Tung (1):
      RDMA/nes: Correct cap.max_inline_data assignment in nes_query_qp()

Dan Carpenter (1):
      IB/mlx4: Check correct variable for allocation failure

Jani Nikula (1):
      IB/cm: Fix device_create() return value check

Roland Dreier (1):
      Merge branches 'cma', 'misc', 'mlx4' and 'nes' into for-linus

shefty (1):
      RDMA/cm: Set num_paths when manually assigning path records

 drivers/infiniband/core/cm.c          |    2 +-
 drivers/infiniband/core/cma.c         |    1 +
 drivers/infiniband/hw/mlx4/mr.c       |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c |    9 ++++-----
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

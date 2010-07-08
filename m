Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0GHUiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:38:15 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:62066 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0GHUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:38:12 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAInUNUyrR7Ht/2dsb2JhbACgMXGnMJpvhSUEg3k
X-IronPort-AV: E=Sophos;i="4.53,560,1272844800"; 
   d="scan'208";a="223751866"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] consider pulling infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 08 Jul 2010 13:37:43 -0700
Message-ID: <adafwztzp48.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please consider pulling from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will extract the SD7220 firmware blob from the new qib driver.
This is a big change at this stage but on the other hand it seems
better to use external firmware from the first release with qib.

However I'm sending this as a separate pull request to let you make the call.

Ben Hutchings (1):
      IB/qib: Use request_firmware() to load SD7220 firmware

 drivers/infiniband/hw/qib/Makefile         |    2 +-
 drivers/infiniband/hw/qib/qib_7220.h       |    7 -
 drivers/infiniband/hw/qib/qib_sd7220.c     |   56 ++-
 drivers/infiniband/hw/qib/qib_sd7220_img.c | 1081 ----------------------------
 firmware/Makefile                          |    1 +
 firmware/WHENCE                            |   40 +
 6 files changed, 87 insertions(+), 1100 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_sd7220_img.c

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

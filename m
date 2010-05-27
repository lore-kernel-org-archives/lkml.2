Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab0E0WST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:18:19 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:16386 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab0E0WSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:18:17 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO+M/kurR7H+/2dsb2JhbACeJHGnRZoZhRMEg0I
X-IronPort-AV: E=Sophos;i="4.53,313,1272844800"; 
   d="scan'208";a="330102826"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 27 May 2010 15:18:13 -0700
Message-ID: <ada6329vviy.fsf@roland-alpha.cisco.com>
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

This is pretty much settled down to fixes -- one semantic patch
cleanup from Julia Lawall and then some fixes to the new qib driver.

The following changes since commit ec96e2fe954c23a54bfdf2673437a39e193a1822:

  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm (2010-05-25 12:06:33 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Julia Lawall (1):
      IB/ucm: Use memdup_user()

Ralph Campbell (3):
      IB/qib: Fix undefined symbol error when CONFIG_PCI_MSI=n
      IB/qib: Use a single txselect module parameter for serdes tuning
      IB/qib: Remove DCA support until feature is finished

Roland Dreier (2):
      IB/qib: Don't rely on (undefined) order of function parameter evaluation
      Merge branches 'misc' and 'qib' into for-next

 drivers/infiniband/core/ucm.c           |   11 +-
 drivers/infiniband/hw/qib/qib_fs.c      |   25 +-
 drivers/infiniband/hw/qib/qib_iba6120.c |   12 -
 drivers/infiniband/hw/qib/qib_iba7322.c |  771 +++++++------------------------
 drivers/infiniband/hw/qib/qib_init.c    |    6 +
 5 files changed, 203 insertions(+), 622 deletions(-)

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

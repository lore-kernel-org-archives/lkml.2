Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2BYCcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 21:32:51 -0500
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:39379 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755472Ab2BYCcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 21:32:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of roland@purestorage.com designates 10.68.211.167 as permitted sender) smtp.mail=roland@purestorage.com; dkim=pass header.i=roland@purestorage.com
MIME-Version: 1.0
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 24 Feb 2012 18:32:41 -0800
Message-Id: <1330137161-2314-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git rdma-for-linus

----------------------------------------------------------------
One InfiniBand/RDMA regression fix for 3.3:

 - mlx4 SR-IOV changes added static exported functions, which doesn't
   build on powerpc at least.  Fix from Doug Ledford for this.

----------------------------------------------------------------
Doug Ledford (1):
      mlx4_core: Exported functions can't be static

 drivers/net/ethernet/mellanox/mlx4/fw.c |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

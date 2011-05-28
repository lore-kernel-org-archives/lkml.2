Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1E1IGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 04:06:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:25381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1E1IG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 04:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="8870622"
Date: Sat, 28 May 2011 10:06:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.40] MFD fixes
Message-ID: <20110528080624.GB3058@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small additional one for MFD, fixing a couple of build failures caused by
merging MFD bits from other trees.

Thanks a lot for pulling this in:

The following changes since commit 29a6ccca3869bbe33879dae0cd7df2a1559eff54:

  Merge git://git.infradead.org/mtd-2.6 (2011-05-27 20:06:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Liam Girdwood (1):
      mfd: Fix build breakage caused by tps65910 gpio directory move

Mattias Wallin (1):
      mfd: Use mfd cell platform_data for db8500-prcmu cells platform bits

 drivers/mfd/Kconfig        |    2 +-
 drivers/mfd/db8500-prcmu.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/

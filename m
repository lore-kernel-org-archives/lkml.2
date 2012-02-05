Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2BEXIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 18:08:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:20557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab2BEXIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 18:08:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="106678588"
Date: Mon, 6 Feb 2012 00:15:17 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [GIT] [3.3] MFD pull request
Message-ID: <20120205231517.GG17584@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Those 2 commits are merge window material that I forgot to include with my
previous pull request. There are twl6040 optimizations, and if you think it's
too late for that kind of changes I'll queue them for the 3.4 merge window.

The first change caches the PLL mclock configuration, and the second change
avoids unneeded twl6040 PLL reconfigurations, saving significant amounts of
time.

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Peter Ujfalusi (2):
      mfd: Store twl6040-codec mclk configuration
      mfd: Avoid twl6040-codec PLL reconfiguration when not needed

 drivers/mfd/twl6040-core.c  |  128 ++++++++++++++++++++++++++-----------------
 include/linux/mfd/twl6040.h |    2 +
 2 files changed, 79 insertions(+), 51 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/

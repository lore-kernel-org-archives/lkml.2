Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab2ECWSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:18:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:53032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab2ECWSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:18:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161655591"
Date: Fri, 4 May 2012 00:18:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Russ Dill <Russ.Dill@ti.com>
Subject: [GIT] [3.4] MFD fixes
Message-ID: <20120503221838.GA17058@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the second pull request for 3.4 MFD related fixes.
This time we only have a one liner fixing an omap-usb build error.

Thanks in advance for pulling it in:

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd-for-linus-3.4-rc6

for you to fetch changes up to 13176a89e1c4a0011bd9f576730b0338ecb619ff:

  mfd: Fix build breakage in omap-usb-host.c (2012-05-01 11:55:04 +0200)

----------------------------------------------------------------
Second MFD pull request for 3.4 fixes

----------------------------------------------------------------
Russ Dill (1):
      mfd: Fix build breakage in omap-usb-host.c

 drivers/mfd/omap-usb-host.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/

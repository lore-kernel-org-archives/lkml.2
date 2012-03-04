Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2CDXFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 18:05:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:36278 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab2CDXFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 18:05:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="114464727"
Date: Mon, 5 Mar 2012 00:11:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Axel Lin <axel.lin@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [GIT] [3.3] MFD fixes
Message-ID: <20120304231156.GT9008@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the pull request for the MFD fixes for 3.3.
We have a few NULL pointer dereferences fixes, an ACPI conflict check fix, and
a couple of wm8994 fixes.

Thank in advance for pulling:

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Axel Lin (1):
      mfd: Initialize tps65912 irq platform data properly

Jean Delvare (1):
      mfd: Fix ACPI conflict check

Jonghwan Choi (2):
      mfd: wm8350 variable dereferenced before check
      mfd: Fix possible s5m null pointer dereference

Laxman Dewangan (1):
      mfd: Initialize tps65910 irq platform data properly

Linus Walleij (1):
      mfd: Fix ab8500 error path bug

Mark Brown (2):
      mfd: Test for jack detection when deciding if wm8994 should suspend
      mfd: Correct readability of WM8994 DC servo 4E register

 drivers/mfd/ab8500-core.c   |    5 +++--
 drivers/mfd/mfd-core.c      |    2 +-
 drivers/mfd/s5m-core.c      |    2 +-
 drivers/mfd/tps65910.c      |    2 +-
 drivers/mfd/tps65912-core.c |    2 +-
 drivers/mfd/wm8350-irq.c    |    1 -
 drivers/mfd/wm8994-core.c   |   14 ++++++++++++++
 drivers/mfd/wm8994-regmap.c |    1 +
 8 files changed, 22 insertions(+), 7 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

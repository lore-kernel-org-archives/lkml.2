Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0I2Ipu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:45:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:32532 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab0I2Ipt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:45:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="611484321"
Date: Wed, 29 Sep 2010 10:46:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Liu <kliu5@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.36] MFD fixes
Message-ID: <20100929084610.GC2544@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a couple fixes for the MFD tree, for 2.6.36. Could you please pull them
in ?

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:

  Linux 2.6.36-rc6 (2010-09-28 18:01:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Kevin Liu (1):
      mfd: Fix max8925 irq control bit incorrect setting

Mark Brown (1):
      mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types

 drivers/mfd/max8925-core.c |   13 +++++++------
 drivers/mfd/wm831x-irq.c   |    9 +++++++--
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

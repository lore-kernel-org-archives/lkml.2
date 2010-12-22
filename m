Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0LVMYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:24:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:2396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0LVMYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:24:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,212,1291622400"; 
   d="scan'208";a="365215786"
Date: Wed, 22 Dec 2010 13:24:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Florian Fainelli <florian@openwrt.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.37] MFD fixes
Message-ID: <20101222122444.GB19525@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the MFD fixes for 2.6.37. Could you please pull them in ?

The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:

  Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Florian Fainelli (2):
      gpio: Fix null pointer dereference while accessing rdc321x platform_data
      watchdog: Fix null pointer dereference while accessing rdc321x platform_data

Mark Brown (2):
      mfd: Supply IRQ base for WM832x devices
      mfd: Support additional parent IDs for wm831x

Mattias Wallin (1):
      mfd: Fix ab8500-core interrupt ffs bit bug

 drivers/gpio/rdc321x-gpio.c    |    2 +-
 drivers/mfd/ab8500-core.c      |    2 +-
 drivers/mfd/wm831x-core.c      |    8 ++++++--
 drivers/watchdog/rdc321x_wdt.c |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

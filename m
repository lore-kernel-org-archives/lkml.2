Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1IRT6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 15:58:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:56455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab1IRT6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 15:58:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,401,1312182000"; 
   d="scan'208";a="55050834"
Date: Sun, 18 Sep 2011 22:00:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ming Lei <tom.leiming@gmail.com>, Anand Gadiyar <gadiyar@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Johan Hovold <jhovold@gmail.com>, Kyle Manna <kyle@kylemanna.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Robert Schwebel <r.schwebel@pengutronix.de>
Subject: [GIT] [3.1] MFD fixes
Message-ID: <20110918200037.GO32263@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a few MFD fixes for 3.1. Among those fixes we have a couple of
potential build failures for omap-usb-host and wm8350.

Thanks in advance for pulling those in.

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:

  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)

are available in the git repository at:
  git://git.infradead.org/users/sameo/mfd-2.6.git for-linus

Anand Gadiyar (1):
      mfd: Make omap-usb-host TLL mode work again

Johan Hovold (1):
      mfd: Fix initialisation of tps65910 interrupts

Kyle Manna (2):
      mfd: Copy the device pointer to the twl4030-madc structure
      mfd: Check for twl4030-madc NULL pointer

Mark Brown (1):
      mfd: Fix value of WM8994_CONFIGURE_GPIO

Ming Lei (1):
      mfd: Fix omap-usb-host build failure

MyungJoo Ham (1):
      mfd: Set MAX8997 irq pointer

Sascha Hauer (1):
      mfd: Rename wm8350 static gpio_set_debounce()

 drivers/mfd/max8997.c            |    5 +++++
 drivers/mfd/omap-usb-host.c      |    2 +-
 drivers/mfd/tps65910-irq.c       |    2 ++
 drivers/mfd/twl4030-madc.c       |    5 ++++-
 drivers/mfd/wm8350-gpio.c        |    4 ++--
 include/linux/mfd/wm8994/pdata.h |    2 +-
 6 files changed, 15 insertions(+), 5 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

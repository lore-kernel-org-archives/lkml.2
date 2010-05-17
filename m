Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0EQKF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:05:28 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50197 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0EQKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:05:20 -0400
From: felipe.balbi@nokia.com
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 0/6] teach gpiolib about gpio debouncing
Date: Mon, 17 May 2010 13:02:29 +0300
Message-Id: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 17 May 2010 10:04:29.0202 (UTC) FILETIME=[56BD0720:01CAF5A8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

Hi all,

I'm resending this series since no-one has had any further
comments for quite some time.

Adding Andrew Morton to the loop also since David Brownell
didn't pick the patch neither comment to any version of it.

Felipe Balbi (5):
  gpiolib: introduce set_debounce method
  arm: omap: gpio: implement set_debounce method
  arm: omap: switch over to gpio_set_debounce
  arm: omap: remove the unused omap_gpio_set_debounce methods
  arm: omap: move all gpio defines to plat/gpio.h

 arch/arm/mach-omap2/board-3430sdp.c        |    4 +-
 arch/arm/mach-omap2/board-ldp.c            |    3 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    4 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    4 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    3 +-
 arch/arm/plat-omap/gpio.c                  |  247 ++++++----------------------
 arch/arm/plat-omap/include/plat/gpio.h     |  143 ++++++++++++++++
 drivers/gpio/gpiolib.c                     |   43 +++++
 include/asm-generic/gpio.h                 |    5 +
 include/linux/gpio.h                       |    5 +
 10 files changed, 252 insertions(+), 209 deletions(-)


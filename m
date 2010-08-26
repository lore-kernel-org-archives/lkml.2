Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0HZHOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:14:32 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:60327 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab0HZHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:14:29 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 0/3] u8500: led and backlight driver
Date: Thu, 26 Aug 2010 12:20:29 +0530
Message-ID: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Murthy (3):
  mfd: ab8500-pwm: ab8500 pwm management
  backlight: u8500: backlight driver based on ab8500 pwm
  leds: ab8500-led: led driver based on ab8500 pwm

 drivers/leds/Kconfig                  |    9 ++
 drivers/leds/Makefile                 |    1 +
 drivers/leds/leds-ab8500.c            |  201 +++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                   |    8 ++
 drivers/mfd/Makefile                  |    1 +
 drivers/mfd/ab8500-core.c             |    7 +-
 drivers/mfd/ab8500-pwm.c              |  191 ++++++++++++++++++++++++++++++
 drivers/video/backlight/Kconfig       |   10 ++
 drivers/video/backlight/Makefile      |    2 +-
 drivers/video/backlight/ab8500_bl.c   |  209 +++++++++++++++++++++++++++++++++
 include/linux/mfd/ab8500.h            |    5 +
 include/linux/mfd/abx500/ab8500-pwm.h |   32 +++++
 12 files changed, 674 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/leds-ab8500.c
 create mode 100644 drivers/mfd/ab8500-pwm.c
 create mode 100644 drivers/video/backlight/ab8500_bl.c
 create mode 100644 include/linux/mfd/abx500/ab8500-pwm.h


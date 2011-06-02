Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1FBSSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:18:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51807 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864Ab1FBSSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:18:10 -0400
Date: Thu, 2 Jun 2011 19:18:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/9] Pending Wolfson patches
Message-ID: <20110602181808.GA18726@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there's quite a few Wolfson patches outstanding I thought it'd be
easiest to collect them all together into a single thread - there's also
a git branch in case that's helpful.  All these have been previously
posted, though some may have been revised and had me forget to post them.

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-sameo

Mark Brown (8):
      mfd: Fix bus lock interaction for WM831x IRQ set_type() operation
      mfd: Implement support for multiple WM831x devices
      mfd: Allow touchscreen to be disabled on wm831x devices
      mfd: Only register wm831x RTC device if the 32.768kHz crystal is enabled
      mfd: Support dynamic allocation of IRQ range for wm831x
      mfd: Read wm831x AUXADC conversion results before acknowledging interrupt
      mfd: Refactor wm831x AUXADC handling into a separate file
      mfd: Restructure wm8994-core device revision handling

Sascha Hauer (1):
      mfd: Allocate wm835x irq descs dynamically

 drivers/mfd/Makefile             |    1 +
 drivers/mfd/wm831x-auxadc.c      |  199 +++++++++++++++++++++++++++++++
 drivers/mfd/wm831x-core.c        |  245 +++++++++-----------------------------
 drivers/mfd/wm831x-irq.c         |   42 +++++--
 drivers/mfd/wm8350-irq.c         |   18 ++-
 drivers/mfd/wm8994-core.c        |   13 ++-
 include/linux/mfd/wm831x/core.h  |    7 +-
 include/linux/mfd/wm831x/pdata.h |    3 +
 8 files changed, 319 insertions(+), 209 deletions(-)
 create mode 100644 drivers/mfd/wm831x-auxadc.c

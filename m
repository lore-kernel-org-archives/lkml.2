Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0KXSA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:00:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40837 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753258Ab0KXSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:00:57 -0500
Date: Wed, 24 Nov 2010 18:00:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/7] Wolfson MFD updates
Message-ID: <20101124180055.GO24970@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a reposting of a number of Wolfson MFD patches previously posted
- I seem to building up a relatively large queue of patches here.

Patch 1/7 is a bugfix and really ought to go into 2.6.37, patch 7/7
would ideally be merged via ASoC as the bulk of the support for this
device is in the CODEC driver, 2-3 are a new device and 4-6 are some
housekeeping for new kernel APIs.

Mark Brown (7):
      mfd: Supply IRQ base for WM832x devices
      mfd: Simplify WM832x subdevice instantiation
      mfd: Add WM8326 support
      mfd: Convert WM831x to new irq_ interrupt methods
      mfd: Convert WM835x to new irq_ interrupt methods
      mfd: Convert WM8994 to new irq_ interrupt methods
      mfd: Add initial WM8958 support

 drivers/mfd/wm831x-core.c       |   19 +++-----
 drivers/mfd/wm831x-i2c.c        |    1 
 drivers/mfd/wm831x-irq.c        |   42 +++++++++---------
 drivers/mfd/wm831x-spi.c        |   18 +++++++
 drivers/mfd/wm8350-irq.c        |   32 +++++++------
 drivers/mfd/wm8994-core.c       |   93 +++++++++++++++++++++++++++++++---------
 drivers/mfd/wm8994-irq.c        |   32 +++++++------
 include/linux/mfd/wm831x/core.h |    1 
 include/linux/mfd/wm8994/core.h |    8 +++
 9 files changed, 166 insertions(+), 80 deletions(-)

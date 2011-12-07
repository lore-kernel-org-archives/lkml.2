Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1LGQid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:38:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39715 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933777Ab1LGQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:34 -0500
Date: Thu, 8 Dec 2011 00:22:57 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 0/4] Random GPIO updates
Message-ID: <20111207162256.GI22355@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly random selection of updates I've been sitting on for
the gpios, partly built up over your sabbatical but a couple predating
that.  No real theme here except for time.

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git gpio/misc

Mark Brown (4):
      gpio: Explicitly index samsung_gpio_cfgs
      gpio: Fix typo in comment in Samsung driver
      gpio: Convert GPIO drivers to module_platform_driver
      gpio: Add decode of WM8994 GPIO configuration

 drivers/gpio/gpio-adp5520.c    |   12 +------
 drivers/gpio/gpio-cs5535.c     |   13 +------
 drivers/gpio/gpio-da9052.c     |   12 +------
 drivers/gpio/gpio-generic.c    |   12 +------
 drivers/gpio/gpio-janz-ttl.c   |   13 +------
 drivers/gpio/gpio-rdc321x.c    |   13 +------
 drivers/gpio/gpio-samsung.c    |   31 ++++++++++------
 drivers/gpio/gpio-sch.c        |   13 +------
 drivers/gpio/gpio-timberdale.c |   13 +------
 drivers/gpio/gpio-ucb1400.c    |   13 +------
 drivers/gpio/gpio-vr41xx.c     |   13 +------
 drivers/gpio/gpio-vx855.c      |   12 +------
 drivers/gpio/gpio-wm8994.c     |   79 +++++++++++++++++++++++++++++++++++++++-
 13 files changed, 108 insertions(+), 141 deletions(-)

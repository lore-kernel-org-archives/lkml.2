Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab0HREo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:44:29 -0400
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:53451 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740Ab0HREo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:44:26 -0400
Date: Sat, 14 Aug 2010 16:09:18 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PULL] Pull request for bjdooks' for-linus/i2c-2636 tree
Message-ID: <20100814150918.GA29606@ben-laptop.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following tree:

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../cmetcalf/linux-tile

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/i2c-2636

Ben Dooks (4):
      Merge branch 'davinci-i2c' of git://git.kernel.org/.../khilman/linux-davinci into for-2636/i2c/davinci
      Merge branch 'for-2636/i2c/pxa' into next-i2c
      Merge branch 'for-2636/i2c/nxp' into next-i2c
      Merge branch 'for-2636/i2c/nuc' into next-i2c

Chaithrika U S (4):
      i2c: davinci: misc. cleanups: remove MOD_REG_BIT and IO_ADDRESS usage
      i2c: davinci: Add helper functions for power management
      i2c: davinci: Add suspend/resume support
      i2c: davinci: Add cpufreq support

Dirk Behme (1):
      i2c: davinci: Fix smbus Oops with AIC33 usage

Kevin Wells (1):
      i2c: Enable NXP LPC support in Kconfig

Marc Kleine-Budde (1):
      i2c-pxa: fix compiler warning, due to missing const

Philby John (1):
      i2c: davinci: bus recovery procedure to clear the bus

Wan ZongShun (1):
      i2c/nuc900: add i2c driver support for nuc900

 arch/arm/mach-w90x900/include/mach/i2c.h |    9 +
 drivers/i2c/busses/Kconfig               |   11 +-
 drivers/i2c/busses/Makefile              |    1 +
 drivers/i2c/busses/i2c-davinci.c         |  314 +++++++++++---
 drivers/i2c/busses/i2c-nuc900.c          |  709 ++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-pxa.c             |    2 +-
 6 files changed, 980 insertions(+), 66 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/include/mach/i2c.h
 create mode 100644 drivers/i2c/busses/i2c-nuc900.c


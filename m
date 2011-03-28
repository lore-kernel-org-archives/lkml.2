Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1C1LHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:07:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49035 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1C1LHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:07:12 -0400
MIME-Version: 1.0
Date: Mon, 28 Mar 2011 13:07:11 +0200
Message-ID: <AANLkTi=F5gTOjSYNYx_jk0S_VWKeriOUHkZBUebU4Z=i@mail.gmail.com>
Subject: [GIT PULL] 2.6.39 ux500-core leftovers
From: Linus Walleij <linus.walleij@linaro.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bibek BASU <bibek.basu@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are some leftovers for ux500-core, which were lost in cross-subsystem
dependency hell. The new GPIO driver is ACK:ed by the GPIO subsystem
maintainer, the rest is platform data.

Please pull it, it is coming this late due to needing to be rebased on the
regulator/voltage tree from yesterday.

The following changes since commit 18bcd0c8cb7d85a9063b88ec810dc1cdc0974518:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6
(2011-03-27 20:37:50 -0700)

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
for-torvalds

Bengt Jonsson (1):
      mach-ux500: provide ab8500 init vector

Bibek Basu (2):
      gpio: driver for 42 AB8500 GPIO pins
      mach-ux500: board support for AB8500 GPIO driver

Linus Walleij (1):
      mach-ux500: configure board for the TPS61052 regulator v2

 arch/arm/mach-ux500/Kconfig                        |    1 +
 arch/arm/mach-ux500/board-mop500-regulators.c      |  201 ++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h      |    1 +
 arch/arm/mach-ux500/board-mop500.c                 |   49 ++-
 arch/arm/mach-ux500/board-mop500.h                 |    4 +
 .../mach-ux500/include/mach/irqs-board-mop500.h    |   15 +-
 drivers/gpio/Kconfig                               |    5 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/ab8500-gpio.c                         |  522 ++++++++++++++++++++
 drivers/mfd/ab8500-core.c                          |   14 +
 drivers/mfd/ab8500-i2c.c                           |    2 +-
 include/linux/mfd/ab8500.h                         |   41 ++
 include/linux/mfd/ab8500/gpio.h                    |   21 +
 13 files changed, 873 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpio/ab8500-gpio.c
 create mode 100644 include/linux/mfd/ab8500/gpio.h

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab0JXSSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 14:18:03 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4824 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab0JXSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:18:01 -0400
Date: Sun, 24 Oct 2010 20:17:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.37
Message-ID: <20101024201752.68cd9404@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem updates for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 MAINTAINERS                           |    6 +
 drivers/gpu/drm/nouveau/nouveau_i2c.h |    1 -
 drivers/gpu/drm/radeon/radeon_mode.h  |    1 -
 drivers/i2c/Kconfig                   |    3 +-
 drivers/i2c/Makefile                  |    4 +-
 drivers/i2c/algos/Kconfig             |   12 +
 drivers/i2c/algos/Makefile            |    4 +-
 drivers/i2c/busses/Makefile           |    4 +-
 drivers/i2c/busses/i2c-amd8111.c      |  163 +++++++++----
 drivers/i2c/busses/i2c-ibm_iic.c      |    1 -
 drivers/i2c/busses/i2c-nuc900.c       |    1 -
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 drivers/i2c/busses/i2c-pxa.c          |    1 -
 drivers/i2c/busses/i2c-s3c2410.c      |    1 -
 drivers/i2c/busses/i2c-viapro.c       |    8 +-
 drivers/i2c/i2c-core.c                |   45 ++--
 drivers/i2c/i2c-dev.c                 |   13 +-
 drivers/i2c/muxes/Kconfig             |   10 +
 drivers/i2c/muxes/Makefile            |    5 +-
 drivers/i2c/muxes/pca9541.c           |  411 +++++++++++++++++++++++++++++++++
 drivers/i2c/muxes/pca954x.c           |    8 +-
 drivers/video/aty/radeon_i2c.c        |    1 -
 drivers/video/i810/i810.h             |    1 -
 drivers/video/intelfb/intelfb_i2c.c   |    1 -
 drivers/video/savage/savagefb.h       |    1 -
 include/linux/i2c.h                   |   12 +-
 26 files changed, 603 insertions(+), 117 deletions(-)
 create mode 100644 drivers/i2c/muxes/pca9541.c

---------------

Guenter Roeck (3):
      i2c/mux: Driver for PCA9541 I2C Master Selector
      MAINTAINERS: Add maintainer for PCA9541 I2C bus master selector driver
      i2c/pca954x: Remove __devinit and __devexit from probe and remove functions

Jean Delvare (7):
      i2c: Fix Kconfig dependencies
      i2c: Simplify i2c_parent_is_i2c_adapter
      i2c: Let i2c_parent_is_i2c_adapter return the parent adapter
      i2c: Remove unneeded inclusions of <linux/i2c-id.h>
      i2c: Discard warning message on device instantiation from user-space
      i2c: Optimize function i2c_detect()
      i2c-viapro: Don't log nacks

Julia Lawall (1):
      i2c-amd8111: Add proper error handling

Nobuhiro Iwamatsu (1):
      i2c-pca-platform: Change device name of request_irq

matt mooney (1):
      i2c: Change to new flag variable

Thanks,
-- 
Jean Delvare

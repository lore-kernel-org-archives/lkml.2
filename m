Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1HLVY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:24:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52243 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab1HLVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:24:28 -0400
X-Sasl-enc: HdibwuKWnOyMo46SCA2Kurl/1wRYrzVbQbVVyuzDuT8v 1313184267
Date: Fri, 12 Aug 2011 14:22:43 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for 3.1
Message-ID: <20110812212243.GA7044@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of minor staging driver fixes for your 3.1 tree.

Full details are below, nothing really major, but lots of build fixes
for stuff people have reported.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All patches have been in the -next releases for a while now.

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |    2 +-
 drivers/staging/dt3155v4l/dt3155v4l.c              |    1 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    1 +
 drivers/staging/gma500/gem_glue.c                  |   23 +----
 drivers/staging/gma500/gem_glue.h                  |    2 -
 drivers/staging/hv/blkvsc_drv.c                    |    4 +-
 drivers/staging/iio/accel/adis16203_core.c         |    8 +-
 drivers/staging/iio/accel/adis16204_core.c         |    8 +-
 drivers/staging/iio/accel/adis16209_core.c         |    8 +-
 drivers/staging/iio/accel/adis16240_core.c         |    8 +-
 drivers/staging/iio/gyro/adis16260_core.c          |    8 +-
 drivers/staging/nvec/TODO                          |    6 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |    9 +-
 drivers/staging/rts_pstor/rtsx.c                   |  109 ++++++++------------
 drivers/staging/rts_pstor/rtsx.h                   |    9 ++-
 drivers/staging/solo6x10/core.c                    |    1 +
 drivers/staging/solo6x10/enc.c                     |    1 +
 drivers/staging/solo6x10/g723.c                    |    1 +
 drivers/staging/solo6x10/p2m.c                     |    1 +
 drivers/staging/solo6x10/solo6x10.h                |    1 +
 drivers/staging/speakup/devsynth.c                 |    5 +-
 drivers/staging/zcache/Makefile                    |    2 +-
 drivers/staging/zcache/{zcache.c => zcache-main.c} |   13 ++-
 23 files changed, 112 insertions(+), 119 deletions(-)
 rename drivers/staging/zcache/{zcache.c => zcache-main.c} (99%)

---------------

Alan Cox (1):
      gma500: Fix clashes with DRM updates

Andrew Morton (5):
      drivers/staging/speakup/devsynth.c: fix "buffer size is not provably correct" error
      drivers/staging/dt3155v4l/dt3155v4l.c needs slab.h
      drivers/staging/solo6x10/core.c needs slab.h
      drivers/staging/solo6x10/p2m.c needs slab.h
      staging: more missing slab.h inclusions

Dan Carpenter (1):
      Staging: iio: add some unlocks to raw_read() functions

Julia Lawall (2):
      drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c: adjust array index
      drivers/staging/hv/blkvsc_drv.c: eliminate NULL pointer dereference

Nitin Gupta (1):
      zcache: Fix build error when sysfs is not defined

Paul Gortmaker (1):
      staging: ft1000_proc needs asm/io.h for inw/outw on sparc

Russell King (1):
      Staging: Add clk API note to nvec/TODO

Stefan Lippers-Hollmann (1):
      staging: rtl8192u: declare MODULE_FIRMWARE

Thadeu Lima de Souza Cascardo (4):
      staging: fix zcache building
      staging: zcache: module is GPL
      staging: zcache: include module.h for MODULE_LICENSE
      zcache: Use div_u64 for 64-bit division

Wanlong Gao (1):
      drivers:staging:solo6x10:add the missed slab.h

wwang (1):
      staging:rts_pstor: fix thread synchronization flow


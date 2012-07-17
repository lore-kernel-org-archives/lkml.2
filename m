Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2GQVcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:32:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39549 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab2GQVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:32:43 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 00/17] Extirpate IRQF_SAMPLE_REMOVE from the kernel
Date: Tue, 17 Jul 2012 17:32:19 -0400
Message-Id: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of changes is fairly straight forward; if there are no
objections, I plan to carry these in the random.git tree for the next
merge window.

						- Ted

Theodore Ts'o (17):
  mfd: remove IRQF_SAMPLE_RANDOM which is now a no-op
  input/serio/hp_sdc.c: remove IRQF_SAMPLE_RANDOM which is now a no-op
  i2c-pmcmsp: remove IRQF_SAMPLE_RANDOM which is now a no-op
  pda_power: remove IRQF_SAMPLE_RANDOM which is now a no-op
  n2_crypto: remove IRQF_SAMPLE_RANDOM which is now a no-op
  xen-blkfront: remove IRQF_SAMPLE_RANDOM which is now a no-op
  drivers: hv: remove IRQF_SAMPLE_RANDOM which is now a no-op
  uartlite: remove IRQF_SAMPLE_RANDOM which is now a no-op
  goku_udc: remove IRQF_SAMPLE_RANDOM which was commented out
  omap_udc: remove IRQF_SAMPLE_RANDOM which is now a no-op
  pxa25x_udc: remove IRQF_SAMPLE_RANDOM which is now a no-op
  isp1301_omap: remove IRQF_SAMPLE_RANDOM which is now a no-op
  board-palmz71: remove IRQF_SAMPLE_RANDOM which is now a no-op
  [ARM] pxa: remove IRQF_SAMPLE_RANDOM which is now a no-op
  sparc/ldc: remove IRQF_SAMPLE_RANDOM which is now a no-op
  um: remove IRQF_SAMPLE_RANDOM which is now a no-op
  random: final removal of IRQF_SAMPLE_RANDOM

 Documentation/feature-removal-schedule.txt | 14 --------------
 arch/arm/mach-omap1/board-palmz71.c        |  3 +--
 arch/arm/mach-pxa/lubbock.c                |  2 +-
 arch/arm/mach-pxa/magician.c               |  5 ++---
 arch/arm/mach-pxa/trizeps4.c               |  4 ++--
 arch/sparc/kernel/ldc.c                    |  6 ++----
 arch/um/drivers/line.c                     | 13 ++++++-------
 arch/um/drivers/mconsole_kern.c            |  3 +--
 arch/um/drivers/port_kern.c                |  6 ++----
 arch/um/drivers/random.c                   |  3 +--
 arch/um/drivers/xterm_kern.c               |  3 +--
 arch/um/kernel/sigio.c                     |  3 +--
 drivers/block/xen-blkfront.c               |  5 ++---
 drivers/crypto/n2_core.c                   |  3 +--
 drivers/hv/vmbus_drv.c                     |  3 +--
 drivers/i2c/busses/i2c-pmcmsp.c            |  3 +--
 drivers/input/serio/hp_sdc.c               |  2 +-
 drivers/mfd/tps65010.c                     |  3 +--
 drivers/power/pda_power.c                  |  6 +-----
 drivers/tty/serial/uartlite.c              |  3 +--
 drivers/usb/gadget/goku_udc.c              |  2 +-
 drivers/usb/gadget/omap_udc.c              |  4 ++--
 drivers/usb/gadget/pxa25x_udc.c            | 12 ++++--------
 drivers/usb/otg/isp1301_omap.c             |  1 -
 include/linux/interrupt.h                  |  2 --
 25 files changed, 36 insertions(+), 78 deletions(-)

-- 
1.7.11.1.108.gb129051


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2BIUVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:21:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46628 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab2BIUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:21:48 -0500
Date: Thu, 9 Feb 2012 12:21:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.3-rc3
Message-ID: <20120209202122.GA22154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-3.3-rc3

for you to fetch changes up to 197234520bd83aba2199add57a9d2678ee7f9781:

  tty: serial: omap-serial: wakeup latency constraint is in microseconds, not milliseconds (2012-02-09 10:48:36 -0800)

----------------------------------------------------------------
Serial/TTY fixes for the 3.3-rc3 tree

Just a few new device ids, omap serial driver regression fixes, and a
build fix for the 8250 driver movement.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Cong Wang (1):
      tty: fix a build failure on sparc

Kukjin Kim (2):
      serial: samsung: Add support for EXYNOS4212 and EXYNOS4412
      serial: samsung: Add support for EXYNOS5250

Paul Gortmaker (1):
      m32r: relocate drivers back out of 8250 dir

Paul Walmsley (3):
      tty: serial: OMAP: use a 1-byte RX FIFO threshold in PIO mode
      tty: serial: OMAP: block idle while the UART is transferring data in PIO mode
      tty: serial: omap-serial: wakeup latency constraint is in microseconds, not milliseconds

Samuel Thibault (1):
      drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

 arch/arm/mach-omap2/serial.c                 |    8 +++---
 drivers/tty/serial/8250/8250.c               |    2 +-
 drivers/tty/serial/{8250 => }/m32r_sio.c     |    0
 drivers/tty/serial/{8250 => }/m32r_sio.h     |    0
 drivers/tty/serial/{8250 => }/m32r_sio_reg.h |    0
 drivers/tty/serial/omap-serial.c             |   30 +++++++++++++++++++++----
 drivers/tty/serial/samsung.c                 |    3 +-
 drivers/tty/vt/vt_ioctl.c                    |    1 -
 8 files changed, 32 insertions(+), 12 deletions(-)
 rename drivers/tty/serial/{8250 => }/m32r_sio.c (100%)
 rename drivers/tty/serial/{8250 => }/m32r_sio.h (100%)
 rename drivers/tty/serial/{8250 => }/m32r_sio_reg.h (100%)

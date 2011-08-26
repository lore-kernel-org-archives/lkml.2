Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1HZTMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:12:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40423 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066Ab1HZTM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:12:26 -0400
X-Sasl-enc: J/tw4gHbPtu99DSJprZAPRvb7s5k13WPCZJtB97tWPtj 1314385945
Date: Fri, 26 Aug 2011 12:11:43 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial driver fixes for 3.1
Message-ID: <20110826191143.GC5557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some small tty/serial fixes for the 3.1 release.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

All of these patches have been in the -mm and -next trees for a while.

Patches will be sent to the linux-serial mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/tty/pty.c                 |   17 +++++++++++++++--
 drivers/tty/serial/8250.c         |    8 +++++---
 drivers/tty/serial/8250_pci.c     |   11 +++++------
 drivers/tty/serial/8250_pnp.c     |    3 +++
 drivers/tty/serial/atmel_serial.c |    8 +++++---
 drivers/tty/serial/max3107-aava.c |    2 +-
 drivers/tty/serial/max3107.c      |    2 +-
 drivers/tty/serial/mrst_max3110.c |    2 +-
 drivers/tty/serial/omap-serial.c  |    3 +--
 drivers/tty/serial/pch_uart.c     |    3 ++-
 drivers/tty/serial/samsung.c      |    8 ++++++--
 drivers/tty/serial/serial_core.c  |    5 +++++
 drivers/tty/serial/ucc_uart.c     |    2 +-
 drivers/tty/tty_io.c              |    3 +--
 include/linux/tty.h               |    2 ++
 include/linux/tty_driver.h        |    3 +++
 16 files changed, 57 insertions(+), 25 deletions(-)

---------------

Al Cooper (1):
      8250: Fix race condition in serial8250_backup_timeout().

Axel Lin (1):
      tty: Add "spi:" prefix for spi modalias

Bjorn Helgaas (1):
      serial: 8250_pnp: add Intermec CV60 touchscreen device

Eric Smith (1):
      8250_pci: add support for Rosewill RC-305 4x serial port card

Jiri Slaby (2):
      TTY: pty, fix pty counting
      TTY: serial, document ignoring of uart->ops->startup error

Kukjin Kim (1):
      serial: samsung: Fix build error

Kumar Gala (1):
      drivers/serial/ucc_uart.c: Fix compiler warning

Nick Pelly (1):
      omap-serial: Allow IXON and IXOFF to be disabled.

Tomoya MORINAGA (2):
      pch_uart: Set PCIe bus number using probe parameter
      serial/8250_pci: delete duplicate data definition

Voss, Nikolaus (1):
      atmel_serial: fix atmel_default_console_device


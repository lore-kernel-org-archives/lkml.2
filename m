Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0FDUpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:45:08 -0400
Received: from kroah.org ([198.145.64.141]:43904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0FDUpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:45:03 -0400
Date: Fri, 4 Jun 2010 13:44:45 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY and serial fixes for .35-git
Message-ID: <20100604204445.GB19761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tty and serial driver bugfixes and new device id patches
for your .35-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm tree.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/n_gsm.c         |    9 +++--
 drivers/char/vt.c            |    2 +-
 drivers/char/vt_ioctl.c      |    4 ++-
 drivers/serial/8250_pci.c    |   71 ++++++++++++++++++++++++++++++++++++++++++
 drivers/serial/altera_uart.c |   44 ++++++++------------------
 drivers/serial/bfin_5xx.c    |    9 ++++-
 drivers/serial/msm_serial.c  |   21 ++----------
 drivers/serial/msm_serial.h  |   56 +++++++++++++++++++++++++++++++++
 drivers/serial/serial_cs.c   |   18 +++++++++-
 9 files changed, 175 insertions(+), 59 deletions(-)

---------------

Abhijeet Dharmapurikar (1):
      msm_serial: fix serial on trout

Alexander Kurz (1):
      serial_cs: add and sort IDs for serial and modem cards

Dan Carpenter (2):
      TTY/n_gsm: potential double lock
      vt_ioctl: return -EFAULT on copy_from_user errors

Frank Pan (1):
      tty: fix a little bug in scrup, vt.c

Graf Yang (1):
      serial: bfin_5xx: IRDA is not affected by anomaly 05000230

Sonic Zhang (1):
      serial: bfin_5xx: fix typo in IER check

Tobias Klauser (3):
      altera_uart: Don't take spinlock in already protected functions
      altera_uart: Simplify altera_uart_console_putc
      serial: altera_uart: Proper section for altera_uart_remove

Yegor Yefremov (1):
      serial: add support for various Titan PCI cards


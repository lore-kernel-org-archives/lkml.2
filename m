Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0IDCKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:10:08 -0400
Received: from kroah.org ([198.145.64.141]:48482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab0IDCKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:10:07 -0400
Date: Fri, 3 Sep 2010 19:09:37 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for 2.6.36-git
Message-ID: <20100904020937.GA28645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tty and serial bugfixes for your 2.6.36-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 MAINTAINERS                      |    3 +--
 drivers/char/tty_io.c            |    2 +-
 drivers/char/vt.c                |   15 ++++-----------
 drivers/serial/bfin_sport_uart.c |    2 +-
 include/linux/serial.h           |    3 +--
 include/linux/serial_core.h      |    3 ++-
 6 files changed, 10 insertions(+), 18 deletions(-)

---------------

Francisco Jerez (1):
      vt: Fix console corruption on driver hand-over.

Jiri Slaby (1):
      MAINTAINERS: orphan isicom

Nathael Pajani (1):
      tty: fix tty_line must not be equal to number of allocated tty pointers in tty driver

Philippe Langlais (1):
      serial: fix port type conflict between NS16550A & U6_16550A

Sonic Zhang (1):
      serial: bfin_sport_uart: restore transmit frame sync fix


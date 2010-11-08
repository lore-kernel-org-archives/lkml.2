Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0KHR65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:58:57 -0500
Received: from kroah.org ([198.145.64.141]:32784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab0KHR64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:58:56 -0500
Date: Mon, 8 Nov 2010 09:58:50 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [GIT PATCH] TTY rename for .37-rc1
Message-ID: <20101108175850.GB13945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that .37-rc1 is out, we wanted to rename some of the drivers/char
tty core files and move them to drivers/tty/  I waited until after
.37-rc1 to do this as it made it easier for everyone merging prior to
this, but if you feel this should wait until .38, that's fine, I'll keep
this around until then.

This has been discussed and agreed apon for a number of months now.  The
larger goal of moving some of the serial drivers around will happen for
.38, as it's a bigger job than this at the moment.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/Makefile                             |    1 +
 drivers/char/Makefile                        |   44 +-------------------------
 drivers/tty/Makefile                         |   11 ++++++
 drivers/{char => tty}/n_gsm.c                |    0
 drivers/{char => tty}/n_hdlc.c               |    0
 drivers/{char => tty}/n_r3964.c              |    0
 drivers/{char => tty}/n_tty.c                |    0
 drivers/{char => tty}/pty.c                  |    0
 drivers/{char => tty}/sysrq.c                |    0
 drivers/{char => tty}/tty_audit.c            |    0
 drivers/{char => tty}/tty_buffer.c           |    0
 drivers/{char => tty}/tty_io.c               |    0
 drivers/{char => tty}/tty_ioctl.c            |    0
 drivers/{char => tty}/tty_ldisc.c            |    0
 drivers/{char => tty}/tty_mutex.c            |    0
 drivers/{char => tty}/tty_port.c             |    0
 drivers/{char => tty/vt}/.gitignore          |    0
 drivers/tty/vt/Makefile                      |   34 ++++++++++++++++++++
 drivers/{char => tty/vt}/consolemap.c        |    0
 drivers/{char => tty/vt}/cp437.uni           |    0
 drivers/{char => tty/vt}/defkeymap.c_shipped |    0
 drivers/{char => tty/vt}/defkeymap.map       |    0
 drivers/{char => tty/vt}/keyboard.c          |    0
 drivers/{char => tty/vt}/selection.c         |    0
 drivers/{char => tty/vt}/vc_screen.c         |    0
 drivers/{char => tty/vt}/vt.c                |    0
 drivers/{char => tty/vt}/vt_ioctl.c          |    0
 27 files changed, 47 insertions(+), 43 deletions(-)
 create mode 100644 drivers/tty/Makefile
 rename drivers/{char => tty}/n_gsm.c (100%)
 rename drivers/{char => tty}/n_hdlc.c (100%)
 rename drivers/{char => tty}/n_r3964.c (100%)
 rename drivers/{char => tty}/n_tty.c (100%)
 rename drivers/{char => tty}/pty.c (100%)
 rename drivers/{char => tty}/sysrq.c (100%)
 rename drivers/{char => tty}/tty_audit.c (100%)
 rename drivers/{char => tty}/tty_buffer.c (100%)
 rename drivers/{char => tty}/tty_io.c (100%)
 rename drivers/{char => tty}/tty_ioctl.c (100%)
 rename drivers/{char => tty}/tty_ldisc.c (100%)
 rename drivers/{char => tty}/tty_mutex.c (100%)
 rename drivers/{char => tty}/tty_port.c (100%)
 rename drivers/{char => tty/vt}/.gitignore (100%)
 create mode 100644 drivers/tty/vt/Makefile
 rename drivers/{char => tty/vt}/consolemap.c (100%)
 rename drivers/{char => tty/vt}/cp437.uni (100%)
 rename drivers/{char => tty/vt}/defkeymap.c_shipped (100%)
 rename drivers/{char => tty/vt}/defkeymap.map (100%)
 rename drivers/{char => tty/vt}/keyboard.c (100%)
 rename drivers/{char => tty/vt}/selection.c (100%)
 rename drivers/{char => tty/vt}/vc_screen.c (100%)
 rename drivers/{char => tty/vt}/vt.c (100%)
 rename drivers/{char => tty/vt}/vt_ioctl.c (100%)

------------------

Greg Kroah-Hartman (3):
      TTY: create drivers/tty and move the tty core files there
      TTY: create drivers/tty/vt and move the vt code there
      TTY: move .gitignore from drivers/char/ to drivers/tty/vt/


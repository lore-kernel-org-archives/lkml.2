Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0LBUw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:52:57 -0500
Received: from kroah.org ([198.145.64.141]:60369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699Ab0LBUwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:52:16 -0500
Date: Thu, 2 Dec 2010 12:48:27 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [GIT PATCH] TTY/serial fixes for .37-rc4
Message-ID: <20101202204827.GB5927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of tty and serial fixes for your .37-rc4 tree.

Jiri did a lot of work tracking down the annoying WARN_ON messages that
have been showing up since .36, and he's fixes some issues that are even
older than that here that have been reported by a lot of users.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

All of these have been in the -next and -mm releases for a while.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/net/wan/x25_asy.c |    2 +-
 drivers/serial/8250.c     |    2 +-
 drivers/serial/mfd.c      |   24 ++++++++----------------
 drivers/tty/tty_io.c      |   13 +++++++++++--
 drivers/tty/tty_ldisc.c   |    2 ++
 include/linux/tty.h       |    1 +
 6 files changed, 24 insertions(+), 20 deletions(-)

---------------

Feng Tang (1):
      serial: mfd: adjust the baud rate setting

Jiri Slaby (4):
      TTY: ldisc, fix open flag handling
      NET: wan/x25, fix ldisc->open retval
      TTY: don't allow reopen when ldisc is changing
      TTY: open/hangup race fixup

Peter Zijlstra (1):
      serial8250: Mark console as CON_ANYTIME


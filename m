Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1AaQ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:29:15 -0500
Received: from kroah.org ([198.145.64.141]:46350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1AaQ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:29:13 -0500
Date: Mon, 31 Jan 2011 08:28:52 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY/serial driver fixes for .38
Message-ID: <20110131162852.GA22875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few tty and serial fixes for your .38 tree.

Note, you will get a conflict in drivers/tty/tty_io.c with this pull, if
you like, I can provide a fixed up merge with this, but the fix should
be pretty easy to detect and fix up if you want to do it yourself.

There are a few bug fixes here that a number of people have reported,
and some build warning fixes as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

All of these patches have been in the -mm and -next trees for the past
week or so.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------


 drivers/tty/n_hdlc.c       |   90 ++++++++++++++++++++++----------------------
 drivers/tty/serial/8250.c  |    3 +-
 drivers/tty/serial/Kconfig |    1 +
 drivers/tty/tty_io.c       |    4 +-
 drivers/tty/vt/vt.c        |   11 ++++-
 5 files changed, 58 insertions(+), 51 deletions(-)

---------------

Dave Airlie (1):
      vt: fix issue when fbcon wants to takeover a second time.

Kay Sievers (1):
      tty: use for_each_console() and WARN() on sysfs failures

Paul Fulghum (1):
      n_hdlc: fix read and write locking

Pavel Machek (1):
      serial: unbreak billionton CF card

Randy Dunlap (1):
      tty/serial: fix apbuart build


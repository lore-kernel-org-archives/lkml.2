Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab0HJStQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:49:16 -0400
Received: from kroah.org ([198.145.64.141]:55441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab0HJStM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:49:12 -0400
Date: Tue, 10 Aug 2010 11:46:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.50
Message-ID: <20100810184600.GA10346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.50 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/accounting/.gitignore   |    1 +
 Documentation/auxdisplay/.gitignore   |    1 +
 Documentation/connector/.gitignore    |    1 +
 Documentation/ia64/.gitignore         |    1 +
 Documentation/networking/.gitignore   |    1 +
 Documentation/pcmcia/.gitignore       |    1 +
 Documentation/spi/.gitignore          |    2 ++
 Documentation/video4linux/.gitignore  |    1 +
 Documentation/vm/.gitignore           |    1 +
 Documentation/watchdog/src/.gitignore |    2 ++
 Makefile                              |    2 +-
 arch/x86/boot/compressed/.gitignore   |    2 ++
 drivers/misc/enclosure.c              |    7 +++++--
 drivers/parisc/led.c                  |    6 ++++--
 fs/gfs2/dir.c                         |    2 +-
 fs/xfs/xfs_dfrag.c                    |    5 ++++-
 16 files changed, 29 insertions(+), 7 deletions(-)

Alexey Dobriyan (1):
      .gitignore updates

Bob Peterson (1):
      GFS2: rename causes kernel Oops

Dan Rosenberg (1):
      xfs: prevent swapext from operating on write-only files

Greg Kroah-Hartman (1):
      Linux 2.6.27.50

Helge Deller (1):
      PARISC: led.c - fix potential stack overflow in led_proc_write()

James Bottomley (1):
      SCSI: enclosure: fix error path - actually return ERR_PTR() on error


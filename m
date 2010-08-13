Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0HMVY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:24:29 -0400
Received: from kroah.org ([198.145.64.141]:41115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab0HMVYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:24:19 -0400
Date: Fri, 13 Aug 2010 14:23:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.51
Message-ID: <20100813212355.GC22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.51 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                 |    2 -
 arch/x86/xen/enlighten.c |    2 -
 arch/x86/xen/time.c      |   43 -----------------------
 arch/x86/xen/xen-ops.h   |    3 +
 drivers/char/nvram.c     |   14 +++++--
 drivers/md/raid10.c      |   18 +++++++++
 drivers/pci/quirks.c     |    1 
 fs/ecryptfs/file.c       |   60 +++++++++++++++++++-------------
 fs/jfs/xattr.c           |   87 ++++++++++++++++++++---------------------------
 fs/signalfd.c            |    2 +
 fs/splice.c              |   12 ------
 mm/backing-dev.c         |    3 +
 12 files changed, 115 insertions(+), 132 deletions(-)

Andrew Morton (1):
      mm/backing-dev.c: remove recently-added WARN_ON()

Dave Kleikamp (1):
      jfs: don't allow os2 xattr namespace overlap with others

Greg Kroah-Hartman (1):
      Linux 2.6.27.51

H. Peter Anvin (1):
      nvram: Fix write beyond end condition; prove to gcc copy is safe

Jeremy Fitzhardinge (1):
      xen: drop xen_sched_clock in favour of using plain wallclock time

Julia Lawall (1):
      fs/ecryptfs/file.c: introduce missing free

Kay Sievers (1):
      bdi: register sysfs bdi device only once per queue

Miklos Szeredi (1):
      splice: fix misuse of SPLICE_F_NONBLOCK

Nathan Lynch (1):
      signalfd: fill in ssi_int for posix timers and message queues

NeilBrown (1):
      md/raid10: fix deadlock with unaligned read during resync

Tejun Heo (1):
      PCI: disable MSI on VIA K8M800

Tyler Hicks (1):
      eCryptfs: Handle ioctl calls with unlocked and compat functions


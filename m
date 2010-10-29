Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab0J2RZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:25:28 -0400
Received: from kroah.org ([198.145.64.141]:59303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934181Ab0J2RZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:25:26 -0400
Date: Fri, 29 Oct 2010 10:21:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.55
Message-ID: <20101029172134.GA17043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.55 kernel.

All users of the 2.6.27 kernel series must upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 arch/powerpc/kernel/head_64.S        |   18 ++++++++++++------
 block/bsg.c                          |    2 +-
 drivers/dma/mv_xor.c                 |    2 +-
 drivers/media/video/compat_ioctl32.c |   32 +++++++++++++++++++++-----------
 drivers/net/atlx/atl1.c              |    5 +++--
 drivers/net/b44.c                    |    4 ++--
 drivers/net/r6040.c                  |   12 +++++-------
 fs/aio.c                             |    3 +++
 fs/exec.c                            |   14 ++++++++++++++
 include/linux/mm.h                   |    8 +++++++-
 mm/memory.c                          |   15 +++++++++++----
 mm/mmap.c                            |    3 ---
 net/wireless/wext.c                  |    2 +-
 sound/core/control.c                 |    3 +++
 sound/pci/rme9652/hdsp.c             |    1 +
 sound/pci/rme9652/hdspm.c            |    1 +
 17 files changed, 87 insertions(+), 40 deletions(-)

Ben Hutchings (1):
      r6040: Fix multicast list iteration when hash filter is used

Dan Rosenberg (2):
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      ALSA: prevent heap corruption in snd_ctl_new()

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Florian Fainelli (1):
      r6040: fix r6040_multicast_list

Greg Kroah-Hartman (1):
      Linux 2.6.27.55

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

Johannes Berg (1):
      wext: fix potential private ioctl memory content leak

Linus Torvalds (1):
      v4l1: fix 32-bit compat microcode loading translation

Luca Tettamanti (1):
      atl1: fix resume

Matt Evans (1):
      powerpc: Initialise paca->kstack before early_setup_secondary

Michael Neuling (1):
      powerpc: Don't use kernel stack with translation off

Paul Fertser (1):
      b44: fix carrier detection on bind

Roland McGrath (3):
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Tony Luck (1):
      guard page for stacks that grow upwards


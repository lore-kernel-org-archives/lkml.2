Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1DVQAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:00:50 -0400
Received: from kroah.org ([198.145.64.141]:42991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab1DVQAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:00:48 -0400
Date: Fri, 22 Apr 2011 09:01:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.39
Message-ID: <20110422160111.GA20136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.39 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                |    1 
 Makefile                                   |    2 
 arch/ia64/kernel/mca.c                     |    3 
 arch/ia64/sn/pci/tioca_provider.c          |    2 
 arch/x86/include/asm/msr-index.h           |    4 +
 arch/x86/include/asm/processor.h           |   19 ++++++
 arch/x86/kernel/cpu/amd.c                  |   88 +++++++++++++++++++++++++++++
 arch/x86/kernel/process.c                  |   39 ------------
 arch/x86/lib/semaphore_32.S                |    2 
 drivers/media/video/sn9c102/sn9c102_core.c |    6 -
 drivers/net/usb/cdc-phonet.c               |    9 --
 drivers/usb/core/devices.c                 |   10 +--
 drivers/usb/host/ehci-q.c                  |   15 ++--
 drivers/usb/host/xhci-mem.c                |   85 ++++++++++++++++++++--------
 drivers/usb/host/xhci.h                    |    6 -
 drivers/usb/serial/ftdi_sio.c              |    5 +
 drivers/usb/serial/ftdi_sio_ids.h          |   12 +++
 drivers/usb/serial/option.c                |   12 +++
 fs/cifs/connect.c                          |    2 
 fs/proc/base.c                             |    9 ++
 fs/ramfs/file-nommu.c                      |    1 
 fs/ubifs/debug.c                           |    6 -
 fs/ubifs/file.c                            |    3 
 include/linux/pid.h                        |    2 
 kernel/pid.c                               |    5 +
 net/ax25/af_ax25.c                         |    2 
 net/rds/rdma.c                             |   11 +++
 27 files changed, 265 insertions(+), 96 deletions(-)

Alan Stern (1):
      USB: EHCI: unlink unused QHs when the controller is stopped

Artem Bityutskiy (1):
      UBIFS: fix oops when R/O file-system is fsync'ed

Bob Liu (1):
      ramfs: fix memleak on no-mmu arch

Boris Ostrovsky (1):
      x86, AMD: Set ARAT feature on AMD processors

Christian Simon (1):
      USB: ftdi_sio: Added IDs for CTI USB Serial Devices

Dmitry Torokhov (3):
      USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
      USB: xhci - fix unsafe macro definitions
      USB: xhci - fix math in xhci_get_endpoint_interval()

Enrico Mioso (1):
      USB: option: Add new ONDA vendor id and product id for ONDA MT825UP

Greg Kroah-Hartman (1):
      Linux 2.6.32.39

Hans Rosenfeld (3):
      x86, cpu: AMD errata checking framework
      x86, cpu: Clean up AMD erratum 400 workaround
      x86, cpu: Fix regression in AMD errata checking code

Jan Beulich (1):
      x86: Fix a bogus unwind annotation in lib/semaphore_32.S

Jeff Layton (1):
      cifs: always do is_path_accessible check in cifs_mount

Jeff Mahoney (2):
      tioca: Fix assignment from incompatible pointer warnings
      mca.c: Fix cast from integer to pointer warning

Jiri Slaby (1):
      NET: cdc-phonet, handle empty phonet header

Joerg Roedel (1):
      x86, amd: Disable GartTlbWlkErr when BIOS forgets it

Johan Hovold (1):
      USB: ftdi_sio: add PID for OCT DK201 docking station

Kees Cook (1):
      net: ax25: fix information leak to userland harder

Linus Torvalds (3):
      next_pidmap: fix overflow condition
      proc: do proper range check on readdir offset
      net: fix rds_iovec page count overflow

Marius B. Kotsbak (1):
      USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.

Paul Friedrich (1):
      USB: ftdi_sio: add ids for Hameg HO720 and HO730

Randy Dunlap (1):
      MAINTAINERS: update STABLE BRANCH info

Vasiliy Kulikov (2):
      video: sn9c102: world-wirtable sysfs files
      UBIFS: restrict world-writable debugfs files


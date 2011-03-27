Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1C0XAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 19:00:40 -0400
Received: from kroah.org ([198.145.64.141]:53039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab1C0XAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 19:00:02 -0400
Date: Sun, 27 Mar 2011 16:00:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.36
Message-ID: <20110327230025.GE23206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.36 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 -
 arch/x86/kernel/head64.c            |    3 --
 arch/x86/kernel/setup.c             |    5 ++++
 arch/x86/mm/init.c                  |   19 ---------------
 arch/x86/mm/init_64.c               |   11 ++++----
 arch/x86/xen/mmu.c                  |   13 +++++-----
 drivers/firmware/dcdbas.c           |    4 ++-
 drivers/input/xen-kbdfront.c        |   45 +++++++++++++++++++-----------------
 drivers/media/video/uvc/uvc_video.c |   14 +++++++----
 drivers/pci/hotplug/acpiphp_glue.c  |    1 
 drivers/pci/pci-sysfs.c             |    7 ++++-
 drivers/usb/class/cdc-acm.c         |    7 ++++-
 drivers/usb/host/ehci-q.c           |   12 ---------
 drivers/usb/misc/uss720.c           |    7 ++---
 drivers/video/console/tileblit.c    |    2 -
 fs/aio.c                            |    4 +--
 fs/dcache.c                         |    3 ++
 fs/ext3/super.c                     |    7 +++++
 fs/nfsd/nfs4proc.c                  |    4 +--
 fs/nfsd/nfs4xdr.c                   |    5 ----
 fs/proc/array.c                     |    4 +--
 fs/proc/task_mmu.c                  |    4 +--
 kernel/signal.c                     |   16 +++++++++---
 mm/shmem.c                          |    1 
 net/sunrpc/xprtsock.c               |    2 +
 25 files changed, 106 insertions(+), 96 deletions(-)

Aaro Koskinen (1):
      procfs: fix /proc/<pid>/maps heap check

Alan Stern (1):
      ehci-hcd: Bug fix: don't set a QH's Halt bit

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Greg Kroah-Hartman (1):
      Linux 2.6.32.36

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Hugh Dickins (1):
      shmem: let shared anonymous be nonlinear again

Johan Hovold (3):
      USB: cdc-acm: fix memory corruption / panic
      USB: cdc-acm: fix potential null-pointer dereference
      USB: cdc-acm: fix potential null-pointer dereference on disconnect

Josef Bacik (1):
      fs: call security_d_instantiate in d_obtain_alias V2

Julien Tinnes (1):
      Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code

Kees Cook (1):
      proc: protect mm start_code/end_code in /proc/pid/stat

Mi Jinlong (2):
      nfsd41: modify the members value of nfsd4_op_flags
      nfsd: wrong index used in inner loop

Michal Schmidt (1):
      PCI: return correct value when writing to the "reset" attribute

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Peter Holik (1):
      USB: uss720 fixup refcount position

Roland Dreier (1):
      aio: wake all waiters when destroying ctx

Stefano Stabellini (2):
      PCI hotplug: acpiphp: set current_state to D0 in register_slot
      xen: set max_pfn_mapped to the last pfn mapped

Stephan Lachowsky (1):
      uvcvideo: Fix uvc_fixup_video_ctrl() format search

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Trond Myklebust (1):
      SUNRPC: Never reuse the socket port after an xs_close()

Yinghai Lu (1):
      x86: Cleanup highmap after brk is concluded


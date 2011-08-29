Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1H2V4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:56:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55132 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724Ab1H2V4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:56:45 -0400
X-Sasl-enc: fvw05/sV5FSf6AVoWuzuotBFcj/VpqH92VpaUx+eHiIs 1314655004
Date: Mon, 29 Aug 2011 14:54:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.46
Message-ID: <20110829215432.GA7663@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.46 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 -
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 
 arch/x86/vdso/vdso32/sysenter.S    |    2 -
 drivers/gpu/drm/ttm/ttm_bo.c       |    4 ++
 drivers/hwmon/ibmaem.c             |   15 ++++++----
 drivers/net/igb/e1000_82575.c      |    1 
 drivers/usb/class/usbtmc.c         |    2 -
 drivers/usb/host/pci-quirks.c      |    2 -
 drivers/usb/serial/qcserial.c      |    1 
 drivers/usb/storage/unusual_devs.h |   10 ++++++
 fs/befs/linuxvfs.c                 |   23 +++++++++------
 fs/fuse/dev.c                      |    4 ++
 fs/partitions/efi.c                |    9 ++++++
 kernel/futex.c                     |   54 ++++++++++++++++++++++++++++---------
 mm/vmalloc.c                       |    7 ++--
 net/atm/br2684.c                   |    2 -
 sound/pci/ac97/ac97_patch.c        |    1 
 sound/usb/caiaq/audio.c            |   37 +++++++++++++++++++++----
 sound/usb/caiaq/device.h           |    1 
 tools/perf/util/config.c           |    7 ----
 20 files changed, 135 insertions(+), 50 deletions(-)

Carolyn Wyborny (1):
      igb: Fix lack of flush after register write and before delay

Chas Williams (1):
      atm: br2864: sent packets truncated in VC routed mode

Clemens Ladisch (1):
      mm: fix wrong vmap address calculations with odd NR_CPUS values

Daniel Mack (2):
      ALSA: snd-usb-caiaq: Correct offset fields of outbound iso_frame_desc
      ALSA: snd_usb_caiaq: track submitted output urbs

Daniel T Chen (1):
      ALSA: ac97: Add HP Compaq dc5100 SFF(PT003AW) to Headphone Jack Sense whitelist

Greg Kroah-Hartman (1):
      Linux 2.6.32.46

H. Peter Anvin (1):
      x86-32, vdso: On system call restart after SYSENTER, use int $0x80

Jack Steiner (1):
      x86, UV: Remove UV delay in starting slave cpus

JiSheng Zhang (1):
      USB: xhci: fix OS want to own HC

Jonathan Nieder (1):
      perf tools: do not look at ./config for configuration

Julia Lawall (1):
      hwmon: (ibmaem) add missing kfree

Marcin Slusarz (1):
      drm/ttm: fix ttm_bo_add_ttm(user) failure path

Maxim Nikulin (1):
      USB: assign instead of equal in usbtmc.c

Miklos Szeredi (1):
      fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message

Nick Bowler (1):
      USB: usb-storage: unusual_devs entry for ARM V2M motherboard.

Shawn Bohrer (1):
      futex: Fix regression with read only mappings

Timo Warns (2):
      fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops
      befs: Validate length of long symbolic links.

Vijay Chavan (1):
      USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G


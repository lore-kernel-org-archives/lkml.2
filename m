Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1CGXY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:24:27 -0500
Received: from kroah.org ([198.145.64.141]:52287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1CGXYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:24:24 -0500
Date: Mon, 7 Mar 2011 15:24:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.33
Message-ID: <20110307232404.GA24927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.33 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 -
 arch/x86/include/asm/smpboot_hooks.h |    2 -
 drivers/gpu/drm/drm_irq.c            |    3 +-
 drivers/hid/hid-core.c               |    1 
 drivers/hid/hid-cypress.c            |    2 +
 drivers/hid/hid-ids.h                |    1 
 drivers/mfd/ucb1x00-ts.c             |   12 ++++++--
 drivers/net/e1000e/netdev.c          |    3 +-
 drivers/net/netxen/netxen_nic_hw.c   |    3 ++
 drivers/net/r8169.c                  |    6 ++++
 drivers/net/wireless/p54/p54usb.c    |    1 
 drivers/usb/misc/iowarrior.c         |    2 -
 drivers/virtio/virtio_pci.c          |    1 
 fs/cifs/cifsproto.h                  |    2 -
 fs/cifs/cifssmb.c                    |    4 ++
 fs/cifs/file.c                       |   17 ++++++-----
 fs/ext2/namei.c                      |    9 +-----
 fs/fuse/file.c                       |   52 ++++++++++++++++++++++++++++++-----
 fs/fuse/fuse_i.h                     |    6 +++-
 fs/ocfs2/refcounttree.c              |    7 +++-
 include/drm/drmP.h                   |    2 -
 include/net/sctp/command.h           |    1 
 kernel/time/tick-broadcast.c         |   10 ++++++
 kernel/time/tick-common.c            |    6 +++-
 kernel/time/tick-internal.h          |    3 ++
 net/dccp/input.c                     |    7 ++--
 net/ipv4/devinet.c                   |   30 +++++++++++++-------
 net/sctp/sm_make_chunk.c             |   15 ----------
 net/sctp/sm_sideeffect.c             |   26 +++++++++++++++++
 net/sctp/sm_statefuns.c              |    8 ++++-
 30 files changed, 177 insertions(+), 67 deletions(-)

Amit Kumar Salecha (1):
      netxen: fix set mac addr

Bruce Allan (1):
      e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead

Christian Lamparter (1):
      p54usb: add Senao NUB-350 usbid

Dave Airlie (1):
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Greg Kroah-Hartman (1):
      Linux 2.6.32.32

Ian Campbell (1):
      arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.

Jiri Kosina (1):
      HID: add support for Acan FG-8100 barcode reader

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Kees Cook (1):
      usb: iowarrior: don't trust report_size for buffer size

Michael S. Tsirkin (1):
      virtio: set pci bus master enable bit

Miklos Szeredi (1):
      fuse: fix hang of single threaded fuseblk filesystem

Pavel Shilovsky (1):
      CIFS: Fix oplock break handling (try #2)

Stanislaw Gruszka (1):
      r8169: disable ASPM

Thomas Gleixner (1):
      clockevents: Prevent oneshot mode when broadcast device is periodic

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.

Vlad Yasevich (1):
      sctp: Fix oops when sending queued ASCONF chunks


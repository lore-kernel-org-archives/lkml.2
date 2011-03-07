Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1CGXQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:16:13 -0500
Received: from kroah.org ([198.145.64.141]:44599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab1CGXQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:16:10 -0500
Date: Mon, 7 Mar 2011 15:15:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.37.3
Message-ID: <20110307231549.GA31536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.37.3 kernel.

All users of the 2.6.37 kernel series must upgrade.

The updated 2.6.37.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/dns_resolver.txt    |    9 ++
 Makefile                                     |    2 
 arch/x86/include/asm/acpi.h                  |    1 
 arch/x86/include/asm/smpboot_hooks.h         |    2 
 arch/x86/kernel/acpi/boot.c                  |   14 ++-
 arch/x86/kernel/early-quirks.c               |   16 +---
 block/blk-core.c                             |   18 +----
 block/blk-flush.c                            |    8 +-
 block/blk-throttle.c                         |   29 +++++---
 block/cfq-iosched.c                          |    6 -
 block/elevator.c                             |    4 -
 block/genhd.c                                |    2 
 drivers/acpi/debugfs.c                       |   20 +++--
 drivers/block/floppy.c                       |    2 
 drivers/block/loop.c                         |    5 -
 drivers/bluetooth/ath3k.c                    |    5 +
 drivers/bluetooth/btusb.c                    |   12 ++-
 drivers/gpu/drm/drm_irq.c                    |    3 
 drivers/gpu/drm/i915/i915_dma.c              |   11 +++
 drivers/gpu/drm/radeon/radeon_display.c      |    2 
 drivers/md/linear.c                          |    1 
 drivers/md/md.c                              |   25 ++++++-
 drivers/md/md.h                              |    2 
 drivers/md/multipath.c                       |    1 
 drivers/md/raid0.c                           |    1 
 drivers/md/raid1.c                           |    6 +
 drivers/md/raid10.c                          |    7 +
 drivers/md/raid5.c                           |    1 
 drivers/mfd/tps6586x.c                       |   10 +-
 drivers/mfd/ucb1x00-ts.c                     |   12 ++-
 drivers/net/e1000e/ich8lan.c                 |   16 +++-
 drivers/net/e1000e/netdev.c                  |    3 
 drivers/net/e1000e/phy.c                     |   14 +++
 drivers/net/r8169.c                          |    6 +
 drivers/net/tg3.c                            |    8 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c     |    9 +-
 drivers/net/wireless/ath/carl9170/usb.c      |    2 
 drivers/net/wireless/p54/p54pci.c            |   14 ++-
 drivers/net/wireless/p54/p54usb.c            |    1 
 drivers/rtc/rtc-ds3232.c                     |   14 ++-
 drivers/scsi/scsi_lib.c                      |    2 
 drivers/scsi/scsi_transport_fc.c             |    2 
 drivers/staging/brcm80211/sys/wl_mac80211.c  |   14 ++-
 drivers/staging/brcm80211/sys/wlc_mac80211.c |   14 +++
 drivers/staging/brcm80211/sys/wlc_pub.h      |    2 
 drivers/staging/comedi/drivers/mite.c        |    2 
 drivers/staging/comedi/drivers/ni_6527.c     |    4 +
 drivers/staging/comedi/drivers/ni_65xx.c     |    4 +
 drivers/staging/comedi/drivers/ni_660x.c     |    4 +
 drivers/staging/comedi/drivers/ni_670x.c     |    4 +
 drivers/staging/comedi/drivers/ni_pcidio.c   |    4 +
 drivers/staging/comedi/drivers/ni_pcimio.c   |    4 +
 drivers/staging/usbip/vhci.h                 |    6 -
 drivers/staging/usbip/vhci_hcd.c             |   54 +++++++++++++--
 drivers/staging/usbip/vhci_rx.c              |   15 ++--
 drivers/usb/core/hub.c                       |   23 +++---
 drivers/usb/core/quirks.c                    |    8 ++
 drivers/usb/host/xhci-ring.c                 |   40 ++++++-----
 drivers/usb/musb/musb_core.c                 |    1 
 drivers/usb/musb/omap2430.c                  |    1 
 drivers/usb/serial/sierra.c                  |    3 
 drivers/usb/serial/usb_wwan.c                |   15 ++--
 drivers/usb/serial/visor.c                   |   12 +++
 fs/block_dev.c                               |   12 +--
 fs/eventpoll.c                               |   95 +++++++++++++++++++++++++++
 fs/ext2/namei.c                              |    9 --
 fs/fuse/file.c                               |   52 ++++++++++++--
 fs/fuse/fuse_i.h                             |    6 +
 fs/gfs2/main.c                               |    9 --
 fs/inode.c                                   |   31 ++++++--
 fs/internal.h                                |    2 
 fs/nilfs2/btnode.c                           |    5 -
 fs/nilfs2/btnode.h                           |    1 
 fs/nilfs2/mdt.c                              |    4 -
 fs/nilfs2/page.h                             |    1 
 fs/nilfs2/segment.c                          |    3 
 fs/nilfs2/super.c                            |    2 
 fs/ocfs2/refcounttree.c                      |    7 +
 fs/ocfs2/super.c                             |   28 +++++--
 fs/partitions/ldm.c                          |    5 +
 include/drm/drmP.h                           |    2 
 include/linux/blkdev.h                       |    5 -
 include/linux/fs.h                           |    4 -
 include/linux/pm.h                           |    2 
 include/linux/pm_wakeup.h                    |   25 +++----
 include/linux/vmstat.h                       |   10 +-
 kernel/time/tick-broadcast.c                 |   10 ++
 kernel/time/tick-common.c                    |    6 +
 kernel/time/tick-internal.h                  |    3 
 lib/swiotlb.c                                |    6 +
 mm/memory.c                                  |    2 
 mm/page_alloc.c                              |    5 -
 mm/vmscan.c                                  |   19 ++++-
 mm/vmstat.c                                  |   36 +---------
 net/dccp/input.c                             |    7 -
 net/dns_resolver/dns_key.c                   |   20 ++++-
 net/ipv4/devinet.c                           |   30 +++++---
 net/ipv4/inet_timewait_sock.c                |    2 
 net/wireless/wext-compat.c                   |    4 -
 sound/pci/hda/patch_conexant.c               |    5 +
 sound/pci/hda/patch_via.c                    |    2 
 sound/soc/imx/eukrea-tlv320.c                |    2 
 sound/soc/pxa/e740_wm9705.c                  |    4 -
 sound/soc/pxa/e750_wm9705.c                  |    4 -
 sound/soc/pxa/e800_wm9712.c                  |    4 -
 sound/soc/pxa/em-x270.c                      |    4 -
 sound/soc/pxa/mioa701_wm9713.c               |    4 -
 sound/soc/pxa/palm27x.c                      |    4 -
 sound/soc/pxa/tosa.c                         |    4 -
 sound/soc/pxa/zylonite.c                     |    4 -
 sound/usb/card.c                             |    4 +
 sound/usb/pcm.c                              |    7 +
 sound/usb/usbaudio.h                         |    1 
 113 files changed, 763 insertions(+), 322 deletions(-)

Alan Stern (2):
      USB: add quirks entry for Keytouch QWERTY Panel
      USB: prevent buggy hubs from crashing the USB stack

Alex Deucher (1):
      Revert "drm/radeon/kms: switch back to min->max pll post divider iteration"

Andreas Herrmann (1):
      x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems

Arend van Spriel (1):
      staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel

Bruce Allan (2):
      e1000e: 82579 PHY incorrectly identified during init
      e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead

Christian Lamparter (2):
      p54pci: update receive dma buffers before and after processing
      p54usb: add Senao NUB-350 usbid

Daniel J Blueman (1):
      fix cfg80211_wext_siwfreq lock ordering...

Dave Airlie (1):
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

David Henningsson (3):
      ALSA: HDA: Add a new Conexant codec 506e (20590)
      ALSA: HDA: Fix mic initialization in VIA auto parser
      ALSA: HDA: Add ideapad quirk for two Dell machines

David Howells (1):
      DNS: Fix a NULL pointer deref when trying to read an error key [CVE-2011-1076]

Davide Libenzi (1):
      epoll: prevent creating circular epoll structures

Dmitry Eremin-Solenikov (1):
      ASoC: correct pxa AC97 DAI names

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Eric Bénard (1):
      eukrea-tlv320: fix platform_name

Eric Dumazet (1):
      tcp: fix inet_twsk_deschedule()

FUJITA Tomonori (1):
      swiotlb: fix wrong panic

Felipe Balbi (1):
      usb: musb: core: set has_tt flag

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Greg Kroah-Hartman (1):
      Linux 2.6.37.3

Ian Abbott (1):
      Staging: comedi: Add MODULE_LICENSE and similar to NI modules

Ian Campbell (1):
      arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.

Jan Niehusmann (1):
      drm/i915: fix memory corruption with GM965 and >4GB RAM

Jan Puk (1):
      carl9170: add Airlive X.USB a/b/g/n USBID

Jiri Slaby (1):
      USB: serial/usb_wwan, fix tty NULL dereference

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Johan Hovold (1):
      usb: musb: omap2430: fix kernel panic on reboot

Jon Thomas (1):
      sierra: add new ID for Airprime/Sierra USB IP modem

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Lei Xu (1):
      drivers/rtc/rtc-ds3232.c: fix time range difference between linux and RTC chip

Linus Torvalds (1):
      Revert "Bluetooth: Enable USB autosuspend by default on btusb"

Luben Tuikov (1):
      USB: Reset USB 3.0 devices on (re)discovery

Maciej Szmigiero (2):
      USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
      USB: Add quirk for Samsung Android phone modem

Mark Fasheh (1):
      ocfs2: Check heartbeat mode for kernel stacks only

Matt Carlson (1):
      tg3: Restrict phy ioctl access

Max Vozeler (4):
      staging: usbip: vhci: update reference count for usb_device
      staging: usbip: vhci: give back URBs from in-flight unlink requests
      staging: usbip: vhci: refuse to enqueue for dead connections
      staging: usbip: vhci: use urb->dev->portnum to find port

Mel Gorman (1):
      mm: vmstat: use a single setter function and callback for adjusting percpu thresholds

Miklos Szeredi (2):
      mm: prevent concurrent unmap_mapping_range() on the same inode
      fuse: fix hang of single threaded fuseblk filesystem

Namhyung Kim (1):
      mm: fix dubious code in __count_immobile_pages()

NeilBrown (4):
      md: correctly handle probe of an 'mdp' device.
      md: avoid spinlock problem in blk_throtl_exit
      md: Fix - again - partition detection when array becomes active
      Fix over-zealous flush_disk when changing device size.

Oliver Neukum (1):
      Bluetooth: fix crash with quirky dongles doing sound

Paul Zimmerman (4):
      xhci: Avoid BUG() in interrupt context
      xhci: Clarify some expressions in the TRB math
      xhci: Fix errors in the running total calculations in the TRB math
      xhci: Fix an error in count_sg_trbs_needed()

Petr Uzel (1):
      block: kill loop_mutex

Rafael J. Wysocki (1):
      PM: Make ACPI wakeup from S5 work again when CONFIG_PM_SLEEP is unset

Roland Vossen (1):
      staging: brcm80211: bugfix for softmac crash on multi cpu configurations

Ryusuke Konishi (1):
      nilfs2: fix regression that i-flag is not set on changeless checkpoints

Stanislaw Gruszka (1):
      r8169: disable ASPM

Sujith Manoharan (1):
      ath9k_htc: Fix an endian issue

Takashi Iwai (1):
      ALSA: usb-audio: fix oops due to cleanup race when disconnecting

Tejun Heo (2):
      block: add @force_kblockd to __blk_run_queue()
      block: blk-flush shouldn't call directly into q->request_fn() __blk_run_queue()

Thomas Gleixner (1):
      clockevents: Prevent oneshot mode when broadcast device is periodic

Timo Warns (1):
      ldm: corrupted partition table can cause kernel oops

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.

Vasiliy Kulikov (1):
      ACPI / debugfs: Fix buffer overflows, double free

Vivek Goyal (1):
      blk-throttle: Do not use kblockd workqueue for throtl work

Yu-Chen Cho (2):
      Bluetooth: add Atheros BT AR9285 fw supported
      Bluetooth: Add Atheros BT AR5BBU12 fw supported

vwadekar@nvidia.com (1):
      mfd: Avoid tps6586x burst writes


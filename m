Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2AZBaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:30:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52021 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683Ab2AZBaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:30:13 -0500
X-Sasl-enc: H8EuOOmiar+PaJ/pmB0aPrQYiLmIg07whBUXUju6ocAR 1327541412
Date: Wed, 25 Jan 2012 17:29:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.18
Message-ID: <20120126012952.GA32432@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.18 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/ia64/kernel/acpi.c                      |   10 +
 arch/score/kernel/entry.S                    |    2=20
 arch/x86/include/asm/amd_nb.h                |    2=20
 arch/x86/kernel/amd_nb.c                     |   31 +++++
 arch/x86/kernel/apic/x2apic_uv_x.c           |    7 +
 arch/x86/mm/mmap.c                           |    4=20
 arch/x86/mm/srat.c                           |    4=20
 arch/x86/pci/Makefile                        |    3=20
 arch/x86/pci/acpi.c                          |   18 ++-
 arch/x86/pci/amd_bus.c                       |   42 ++-----
 arch/x86/platform/uv/tlb_uv.c                |   13 +-
 block/scsi_ioctl.c                           |   52 +++++++++
 drivers/acpi/acpica/dsargs.c                 |   24 ++++
 drivers/acpi/numa.c                          |    6 +
 drivers/acpi/processor_core.c                |   26 ++++
 drivers/block/cciss.c                        |    6 -
 drivers/block/ub.c                           |    3=20
 drivers/block/virtio_blk.c                   |    4=20
 drivers/cdrom/cdrom.c                        |    3=20
 drivers/gpu/drm/radeon/r100.c                |    5=20
 drivers/gpu/drm/radeon/r600_hdmi.c           |    7 +
 drivers/gpu/drm/radeon/radeon_device.c       |    5=20
 drivers/gpu/drm/radeon/rs600.c               |    4=20
 drivers/hid/hid-core.c                       |   14 +-
 drivers/hid/hid-ids.h                        |   14 +-
 drivers/hid/hid-multitouch.c                 |   32 ++++-
 drivers/i2c/busses/i2c-ali1535.c             |   11 +-
 drivers/i2c/busses/i2c-eg20t.c               |    2=20
 drivers/i2c/busses/i2c-nforce2.c             |    2=20
 drivers/i2c/busses/i2c-omap.c                |    2=20
 drivers/i2c/busses/i2c-sis5595.c             |    4=20
 drivers/i2c/busses/i2c-sis630.c              |    6 -
 drivers/i2c/busses/i2c-viapro.c              |    7 -
 drivers/ide/ide-floppy_ioctl.c               |    3=20
 drivers/idle/intel_idle.c                    |    9 -
 drivers/md/dm-flakey.c                       |   11 +-
 drivers/md/dm-linear.c                       |   12 ++
 drivers/md/dm-mpath.c                        |    6 +
 drivers/media/video/uvc/uvc_v4l2.c           |    9 +
 drivers/media/video/uvc/uvcvideo.h           |    1=20
 drivers/media/video/v4l2-ioctl.c             |    4=20
 drivers/mmc/core/mmc.c                       |    2=20
 drivers/mmc/host/sdhci.c                     |    6 -
 drivers/mtd/mtd_blkdevs.c                    |    3=20
 drivers/mtd/mtdoops.c                        |    5=20
 drivers/mtd/tests/mtd_stresstest.c           |    7 +
 drivers/mtd/ubi/cdev.c                       |    3=20
 drivers/mtd/ubi/debug.h                      |    5=20
 drivers/mtd/ubi/eba.c                        |    6 -
 drivers/mtd/ubi/ubi.h                        |    2=20
 drivers/mtd/ubi/wl.c                         |   12 +-
 drivers/net/phy/mdio-gpio.c                  |    2=20
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    9 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    1=20
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    3=20
 drivers/net/wireless/rt2x00/rt2800pci.c      |   28 +----
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c  |    4=20
 drivers/pci/msi.c                            |   10 +
 drivers/pnp/quirks.c                         |   42 +++++++
 drivers/rtc/interface.c                      |    4=20
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   83 +++++----------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |   11 +-
 drivers/scsi/sd.c                            |   13 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c          |    4=20
 drivers/target/target_core_cdb.c             |   12 ++
 drivers/target/target_core_transport.c       |   14 ++
 drivers/xen/xenbus/xenbus_xs.c               |    6 +
 fs/dcache.c                                  |   14 +-
 fs/ext4/super.c                              |    7 -
 fs/nfs/callback_proc.c                       |    2=20
 fs/nfs/objlayout/objio_osd.c                 |    3=20
 fs/nfs/objlayout/objlayout.c                 |   10 +
 fs/nfs/pnfs.c                                |   12 ++
 fs/nfs/pnfs.h                                |    1=20
 fs/nfs/super.c                               |   43 +++-----
 fs/nfsd/export.c                             |    2=20
 fs/notify/mark.c                             |    8 -
 fs/proc/base.c                               |  145 +++++++---------------=
-----
 fs/proc/task_mmu.c                           |    3=20
 fs/proc/uptime.c                             |    9 +
 fs/ubifs/debug.h                             |   17 +--
 include/acpi/acpi_numa.h                     |    1=20
 include/linux/blkdev.h                       |    3=20
 include/linux/dcache.h                       |    1=20
 include/linux/memcontrol.h                   |    6 +
 include/linux/pci_regs.h                     |    2=20
 include/linux/sunrpc/svcsock.h               |    2=20
 include/linux/videodev2.h                    |    1=20
 include/target/target_core_base.h            |    1=20
 include/xen/interface/io/xs_wire.h           |    3=20
 init/do_mounts.c                             |   35 +++++-
 kernel/kprobes.c                             |    2=20
 mm/filemap.c                                 |   18 ---
 mm/memcontrol.c                              |   44 ++++++++
 mm/page_alloc.c                              |   11 ++
 net/ipv4/ah4.c                               |    6 -
 net/ipv6/ah6.c                               |    6 -
 net/mac80211/wpa.c                           |    2=20
 net/sunrpc/svc.c                             |   20 ++-
 net/sunrpc/svc_xprt.c                        |   53 ++++++---
 scripts/kconfig/streamline_config.pl         |   52 +++++++--
 scripts/recordmcount.h                       |    2=20
 security/integrity/ima/ima_api.c             |    4=20
 security/integrity/ima/ima_queue.c           |   17 ++-
 sound/pci/hda/hda_local.h                    |    7 +
 sound/pci/hda/hda_proc.c                     |    2=20
 sound/pci/hda/patch_sigmatel.c               |    2=20
 sound/pci/ice1712/amp.c                      |    7 -
 sound/pci/oxygen/xonar_wm87x6.c              |    1=20
 sound/usb/usx2y/usb_stream.c                 |    6 -
 111 files changed, 869 insertions(+), 453 deletions(-)

Aaron Lu (1):
      mmc: sdhci: Fix tuning timer incorrect setting when suspending host

Alex Deucher (1):
      drm/radeon/kms: disable writeback on pre-R300 asics

Alex Williamson (1):
      PCI: Fix PCI_EXP_TYPE_RC_EC value

Alexander Aring (1):
      I2C: OMAP: correct SYSC register offset for OMAP4

Alexander Elbs (1):
      mmc: sd: Fix SDR12 timing regression

Ananth N Mavinakayanahalli (1):
      kprobes: initialize before using a hlist

Andy Adamson (1):
      NFSv4.1: fix backchannel slotid off-by-one bug

Artem Bityutskiy (4):
      UBI: fix use-after-free on error path
      UBI: fix debugging messages
      UBIFS: fix debugging messages
      UBIFS: make debugging messages light again

Ben Hutchings (1):
      drivers/rtc/interface.c: fix alarm rollover when day or month is out-=
of-range

Benjamin Tissoires (3):
      HID: multitouch: cleanup with eGalax PID definitions
      HID: multitouch: add support for the MSI Windpad 110W
      HID: multitouch: add support for 3M 32"

Bhavesh Parekh (1):
      UBI: fix missing scrub when there is a bit-flip

Bjorn Helgaas (3):
      x86/PCI: amd: factor out MMCONFIG discovery
      x86/PCI: build amd_bus.o only when CONFIG_AMD_NB=3Dy
      PNP: work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB

Boaz Harrosh (2):
      pnfs-obj: pNFS errors are communicated on iodata->pnfs_error
      pnfs-obj: Must return layout on IO error

Brian Norris (1):
      mtd: mtd_blkdevs: don't increase 'open' count on error path

Chase Douglas (1):
      HID: bump maximum global item tag report size to 96 bytes

Chris Bagwell (1):
      HID: hid-multitouch - add another eGalax id

Chuck Lever (1):
      NFS: Retry mounting NFSROOT

Clemens Ladisch (1):
      ALSA: virtuoso: Xonar DS: fix polarity of front output

Cliff Wickman (1):
      x86/UV2: Fix BAU destination timeout initialization

Dan Carpenter (1):
      V4L/DVB: v4l2-ioctl: integer overflow in video_usercopy()

Dan Rosenberg (1):
      score: fix off-by-one index into syscall table

David Daney (1):
      recordmcount: Fix handling of elf64 big-endian objects.

David Henningsson (1):
      ALSA: HDA: Fix internal microphone on Dell Studio 16 XPS 1645

Dirk Eibach (1):
      net: Fix driver name for mdio-gpio.c

Eric W. Biederman (1):
      PCI: msi: Disable msi interrupts when we initialize a pci device

Gary Hade (1):
      x86/PCI: Ignore CPU non-addressable _CRS reserved memory resources

Girish K S (1):
      mmc: core: Fix voltage select in DDR mode

Greg Kroah-Hartman (1):
      Linux 3.0.18

Haogang Chen (1):
      uvcvideo: Fix integer overflow in uvc_ioctl_ctrl_map()

Ian Campbell (1):
      xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.

J. Bruce Fields (3):
      svcrpc: fix double-free on shutdown of nfsd after changing pool mode
      svcrpc: destroy server sockets all at once
      svcrpc: avoid memory-corruption on pool shutdown

Jack Steiner (1):
      x86, UV: Update Boot messages for SGI UV2 platform

Jean Delvare (1):
      i2c: Fix error value returned by several bus drivers

Jeff Layton (1):
      nfs: fix regression in handling of context=3D option in NFSv4

KAMEZAWA Hiroyuki (1):
      memcg: add mem_cgroup_replace_page_cache() to fix LRU issue

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Delete calls to preempt_disable

Kurt Garloff (3):
      ACPI: Store SRAT table revision
      ACPI, x86: Use SRAT table rev to use 8bit or 32bit PXM fields (x86/x8=
6-64)
      ACPI, ia64: Use SRAT table rev to use 8bit or 16/32bit PXM fields (ia=
64)

Larry Finger (1):
      rtl8192se: Fix BUG caused by failure to check skb allocation

Lin Ming (2):
      ACPICA: Put back the call to acpi_os_validate_address
      ACPI: processor: fix acpi_get_cpuid for UP processor

Linus Torvalds (1):
      proc: clean up and fix /proc/<pid>/mem handling

Ludwig Nussel (1):
      x86: Fix mmap random address range

Marek Vasut (1):
      HID: multitouch: Add egalax ID for Acer Iconia W500

Martin Schwidefsky (1):
      fix cputime overflow in uptime_proc_show

Michal Hocko (1):
      mm: fix NULL ptr dereference in __count_immobile_pages

Michel D=C3=A4nzer (1):
      radeon: Fix disabling PCI bus mastering on big endian hosts.

Miklos Szeredi (2):
      fsnotify: don't BUG in fsnotify_destroy_mark()
      fix shrink_dcache_parent() livelock

Nick Bowler (2):
      ah: Correctly pass error codes in ahash output callback.
      ah: Read nexthdr value before overwriting it in ahash input callback.

Paolo Bonzini (3):
      block: add and use scsi_blk_cmd_ioctl
      block: fail SCSI passthrough ioctls on partition devices
      dm: do not forward ioctls from logical volumes to the underlying devi=
ce

Pavel Hofman (1):
      ALSA: ice1724 - Check for ac97 to avoid kernel oops

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/radeon/kms: workaround invalid AVI infoframe checksum issue

Richard Weinberger (1):
      UBI: fix nameless volumes handling

Roberto Sassu (2):
      ima: free duplicate measurement memory
      ima: fix invalid memory reference

Roland Dreier (2):
      target: Set response format in INQUIRY response
      target: Set additional sense length field in sense data

Roman Tereshonkov (2):
      mtdoops: fix the oops_page_used array size
      mtd: mtdoops: skip reading initially bad blocks

Sasha Levin (1):
      nfsd: Fix oops when parsing a 0 length export

Shaohua Li (1):
      intel_idle: fix API misuse

Stanislaw Gruszka (3):
      mac80211: fix rx->key NULL pointer dereference in promiscuous mode
      rt2800pci: fix spurious interrupts generation
      iwlegacy: 3945: fix hw passive scan on radar channels

Steven Rostedt (2):
      kconfig/streamline-config.pl: Simplify backslash line concatination
      kconfig/streamline-config.pl: Fix parsing Makefile with variables

Stratos Psomadakis (1):
      sym53c8xx: Fix NULL pointer dereference in slave_destroy

Takashi Iwai (1):
      ALSA: hda - Return the error from get_wcaps_type() for invalid NIDs

Thomas Renninger (1):
      intel idle: Make idle driver more robust

Toshiharu Okada (1):
      i2c-eg20t: modified the setting of transfer rate.

Wey-Yi Guy (1):
      iwlagn: check for SMPS mode

Will Deacon (1):
      proc: clear_refs: do not clear reserved pages

Wolfram Sang (1):
      mtd: tests: stresstest: bail out if device has not enough eraseblocks

Xi Wang (1):
      ext4: fix undefined behavior in ext4_fill_flex_info()

nagalakshmi.nandigama@lsi.com (2):
      SCSI: mpt2sas: Release spinlock for the raid device list before block=
ing it
      SCSI: mpt2sas : Fix for memory allocation error for large host credits


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPIKyQAAoJEDjbvchgkmk+PxoQAJGwXn96/FDdIqRp2Pb24Vq9
r8Z8GHTfS5gVM8rxCKH/FEwK4WSihGqzRSlUIIlCsgkZTu226L+ytfnjSYAgxtPz
sd8nsmHKrCmiIdEvn9DvG/kDof9DmcjK8fpigDWNCEnRNsZhI27/uXebe34LM3j4
jqXQaEQ08k3cIuYEIDgfHKn4m/nFzwcpGX6tVXAzyDrxLsMrJ0PJ5aGoDGCoRESU
km5eiHu6SQmikZCkyHfztZeCtWbANhXNWFhAZc8/L/A9lhpNxpYj5ZGdKMdBoAsn
9xavoSXtRFPdvPLAiX6uwV/EDMoUh3Gsk9ew+7L1dRSzKGGRrvNvaD3mWLvKtUfs
K+Xj2CLfo6AHK/KfRxY/7gBerssBwQVBODnQeCF23ZyxBel4RIeChbBnNdjxqh2I
FiXpE9xb+4+RSC56fkmJc6F39eP5CqwvEVnL9mI5Y20Uvz6nMnbSZ3mknlUdzIaG
3OxbtT2mVDcSIK7R/Cm/mIT9LyozkeH8ah6v3y44SEBf3hZaKzhDdul6aoiL6HSQ
cgNj0i/N22XPz4c1/XguMuPa3euvuKA6wsgZWs7scv+jYru/n+GICopcOH2+RTax
AtNqGHmHhAwoVPEy4viDSuY2/lPKfsqWW69a2ZJ0ZXuzO8VXXxY1bP462A5+Sahy
3AEoPTy49+xe2B6CUSN4
=Y+mf
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--

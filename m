Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2ARPq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:46:29 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35578 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897Ab2ARPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:46:27 -0500
X-Sasl-enc: urOSZU1WQCCjYNFFffdVdQk1gOaJkb9BTspjPU+2UQ/2 1326901586
Date: Wed, 18 Jan 2012 07:46:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.1.10
Message-ID: <20120118154609.GA21161@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.1.10 kernel.

All users of the 3.1 kernel series must upgrade.

This is the LAST release of the 3.1 kernel series, please move to the
3.2 kernel series at this time.  Again, 3.1.y is end-of-life.

The updated 3.1.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.1.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/virtual/kvm/api.txt           |    7 ++
 Makefile                                    |    2=20
 arch/x86/include/asm/amd_nb.h               |    2=20
 arch/x86/kernel/amd_nb.c                    |   31 +++++++++
 arch/x86/kernel/kvmclock.c                  |    5 -
 arch/x86/kvm/i8254.c                        |   10 ++
 arch/x86/mm/mmap.c                          |    4 -
 arch/x86/pci/Makefile                       |    3=20
 arch/x86/pci/acpi.c                         |   18 ++++-
 arch/x86/pci/amd_bus.c                      |   42 +++---------
 drivers/gpu/drm/radeon/r100.c               |    5 -
 drivers/gpu/drm/radeon/r600_hdmi.c          |    7 ++
 drivers/gpu/drm/radeon/radeon_device.c      |    5 +
 drivers/gpu/drm/radeon/rs600.c              |    4 -
 drivers/hid/hid-core.c                      |    2=20
 drivers/md/raid1.c                          |   11 ++-
 drivers/mtd/mtd_blkdevs.c                   |    3=20
 drivers/mtd/mtdoops.c                       |    5 +
 drivers/mtd/tests/mtd_stresstest.c          |    7 ++
 drivers/mtd/ubi/eba.c                       |    6 +
 drivers/mtd/ubi/ubi.h                       |    2=20
 drivers/mtd/ubi/wl.c                        |   12 ++-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c |    4 +
 drivers/pci/msi.c                           |   10 ++
 drivers/platform/x86/ideapad-laptop.c       |    2=20
 drivers/pnp/quirks.c                        |   42 ++++++++++++
 drivers/rtc/interface.c                     |    4 -
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   83 +++++++-----------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   11 +--
 drivers/xen/xenbus/xenbus_xs.c              |    6 +
 fs/ext4/super.c                             |    7 --
 fs/nfs/callback_proc.c                      |    2=20
 fs/nfs/file.c                               |    4 -
 fs/nfs/nfs4proc.c                           |   96 ++++++++++++++++-------=
-----
 fs/nfs/nfs4xdr.c                            |   31 ++++++---
 fs/nfs/super.c                              |   43 +++++-------
 include/linux/memcontrol.h                  |    6 +
 include/linux/nfs_xdr.h                     |    5 +
 include/linux/pci_regs.h                    |    2=20
 include/linux/sunrpc/xdr.h                  |    2=20
 include/xen/interface/io/xs_wire.h          |    3=20
 init/do_mounts.c                            |   35 +++++++++-
 mm/filemap.c                                |   18 -----
 mm/memcontrol.c                             |   44 ++++++++++++
 mm/slub.c                                   |    5 +
 net/mac80211/wpa.c                          |    2=20
 net/sunrpc/xdr.c                            |    3=20
 security/integrity/ima/ima_api.c            |    4 -
 security/integrity/ima/ima_queue.c          |   17 +++-
 sound/pci/hda/hda_local.h                   |    7 +-
 sound/pci/hda/hda_proc.c                    |    2=20
 sound/pci/hda/patch_cirrus.c                |   27 ++-----
 sound/pci/hda/patch_conexant.c              |    2=20
 sound/pci/hda/patch_sigmatel.c              |   36 ++++++----
 sound/pci/hda/patch_via.c                   |    5 +
 sound/pci/ice1712/amp.c                     |    7 +-
 sound/usb/usx2y/usb_stream.c                |    6 -
 virt/kvm/assigned-dev.c                     |   93 +++++++++++++++++++++++=
+---
 58 files changed, 589 insertions(+), 280 deletions(-)

Alex Deucher (1):
      drm/radeon/kms: disable writeback on pre-R300 asics

Alex Williamson (3):
      KVM: Remove ability to assign a device without iommu support
      KVM: Device assignment permission checks
      PCI: Fix PCI_EXP_TYPE_RC_EC value

Andy Adamson (2):
      NFSv4.1: fix backchannel slotid off-by-one bug
      NFSv4: include bitmap in nfsv4 get acl data

Artem Bityutskiy (1):
      UBI: fix use-after-free on error path

Avi Kivity (1):
      KVM guest: prevent tracing recursion with kvmclock

Ben Hutchings (1):
      drivers/rtc/interface.c: fix alarm rollover when day or month is out-=
of-range

Bhavesh Parekh (1):
      UBI: fix missing scrub when there is a bit-flip

Bjorn Helgaas (3):
      x86/PCI: amd: factor out MMCONFIG discovery
      x86/PCI: build amd_bus.o only when CONFIG_AMD_NB=3Dy
      PNP: work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB

Brian Norris (1):
      mtd: mtd_blkdevs: don't increase 'open' count on error path

Chase Douglas (1):
      HID: bump maximum global item tag report size to 96 bytes

Chuck Lever (1):
      NFS: Retry mounting NFSROOT

David Henningsson (2):
      ALSA: HDA: Fix master control for Cirrus Logic 421X
      ALSA: HDA: Fix automute for Cirrus Logic 421x

Eric Dumazet (1):
      slub: fix a possible memleak in __slab_alloc()

Eric W. Biederman (1):
      PCI: msi: Disable msi interrupts when we initialize a pci device

Gary Hade (1):
      x86/PCI: Ignore CPU non-addressable _CRS reserved memory resources

Greg Kroah-Hartman (1):
      Linux 3.1.10

Ian Campbell (1):
      xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.

Jan Kiszka (1):
      KVM: x86: Prevent starting PIT timers in the absence of irqchip suppo=
rt

Jeff Layton (1):
      nfs: fix regression in handling of context=3D option in NFSv4

KAMEZAWA Hiroyuki (1):
      memcg: add mem_cgroup_replace_page_cache() to fix LRU issue

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Delete calls to preempt_disable

Larry Finger (1):
      rtl8192se: Fix BUG caused by failure to check skb allocation

Ludwig Nussel (1):
      x86: Fix mmap random address range

Michel D=C3=A4nzer (1):
      radeon: Fix disabling PCI bus mastering on big endian hosts.

NeilBrown (2):
      NFS - fix recent breakage to NFS error handling.
      md/raid1: perform bad-block tests for WriteMostly devices too.

Pavel Hofman (1):
      ALSA: ice1724 - Check for ac97 to avoid kernel oops

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/radeon/kms: workaround invalid AVI infoframe checksum issue

Rene Bollford (1):
      ideapad: Check if acpi already handle backlight power to avoid a page=
 fault

Roberto Sassu (2):
      ima: free duplicate measurement memory
      ima: fix invalid memory reference

Roman Tereshonkov (2):
      mtdoops: fix the oops_page_used array size
      mtd: mtdoops: skip reading initially bad blocks

Stanislaw Gruszka (1):
      mac80211: fix rx->key NULL pointer dereference in promiscuous mode

Takashi Iwai (4):
      ALSA: hda - Use auto-parser for HP laptops with cx20459 codec
      ALSA: hda - Return the error from get_wcaps_type() for invalid NIDs
      ALSA: hda - Fix the detection of "Loopback Mixing" control for VIA co=
decs
      ALSA: hda - Fix the lost power-setup of seconary pins after PM resume

Wolfram Sang (1):
      mtd: tests: stresstest: bail out if device has not enough eraseblocks

Xi Wang (1):
      ext4: fix undefined behavior in ext4_fill_flex_info()

nagalakshmi.nandigama@lsi.com (2):
      SCSI: mpt2sas: Release spinlock for the raid device list before block=
ing it
      SCSI: mpt2sas : Fix for memory allocation error for large host credits


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPFulBAAoJEDjbvchgkmk+u7EP/0rVw1cBtWIVrzRGbWPiYdXo
U0H/7gIitGivckeruwEbvjL7dpxSgUOQ7TTT+xkcoijVMJAN1z3I/42cGFyEO/Ph
hISI5l8ccAZYYXzGi9pcd052zuQ3tPnSyb3kblktKmm26Lfg5Fj43J5UQl/MvsfA
WbYCPcUwG4Wz9//KNcqajXAyWEiNIR1hpLjB7YLfguIkqy15LJVPSy+oeYblSKEM
QYTN8gFZdrO/a3PGiVMUwt1DyLFQW5eNQePVW5mU7HpatQXRl1eZ/t/tYV33uqRD
ZGwNBzIovuZqplmqNfQwOLoVeG9YRF3A5JWIDCOSxTGpLhveyECI6bO1QAl+gpbA
nhFnjcA3hRMKzgu2vf19WzBwg1Ewyj4k+Lp/6mDAuoKaiOwLNI3DomkUs5u0j4Lz
KGw3Wc9k1+zc4dQloceBAP3xVvdrW7azZm32Nun52XB9N2jx5l5ic4HP/Boprlxh
B8SE9+BSp0I/L8hr0dCaV+xEe6T+fJ0XWbeS2Cfeu+VxAXG9o5aYM3YRxyt9JYNK
mXllF0mbBGFJXkTa8MGR6xnejJ8EyMZAqzdetjSu+jyZGfvgIOOYxqVLGfARfk7L
26snhrNZV+OwddFe4E6uDYajorvwWz1iILi4VBOFXh6HXNwS+sBI49pZkzoBGFhI
CKmsU5hS0eFpjLBiHGN5
=GI9x
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--

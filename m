Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab2ILPEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:04:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48258 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280Ab2ILPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:04:21 -0400
Message-ID: <1347462254.13258.1.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.29
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 12 Sep 2012 16:04:14 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zaYWNx7/LBbTUVa+Czln"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zaYWNx7/LBbTUVa+Czln
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.29 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 MAINTAINERS                                  |    2 +-
 Makefile                                     |    2 +-
 arch/alpha/include/asm/atomic.h              |    4 +-
 arch/alpha/include/asm/socket.h              |    2 +
 arch/arm/include/asm/pgtable.h               |    6 +-
 arch/arm/mm/tlb-v7.S                         |    6 +-
 arch/arm/vfp/vfpmodule.c                     |    2 +
 arch/x86/mm/hugetlbpage.c                    |   21 +-
 drivers/acpi/acpica/tbxface.c                |    1 +
 drivers/base/power/runtime.c                 |    5 +-
 drivers/block/cciss_scsi.c                   |   11 +-
 drivers/block/virtio_blk.c                   |   35 +-
 drivers/char/random.c                        |   21 +-
 drivers/firmware/dmi_scan.c                  |    3 +
 drivers/gpu/drm/i915/intel_display.c         |   11 -
 drivers/gpu/drm/i915/intel_dp.c              |   14 +-
 drivers/gpu/drm/nouveau/nvd0_display.c       |    2 +-
 drivers/gpu/drm/radeon/atombios.h            |  929 ++++++++++++++++++++++=
++--
 drivers/gpu/drm/radeon/radeon.h              |   15 -
 drivers/gpu/drm/radeon/radeon_atombios.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   55 +-
 drivers/gpu/drm/radeon/radeon_bios.c         |  140 +++-
 drivers/gpu/drm/radeon/radeon_object.c       |    3 +-
 drivers/hid/hid-chicony.c                    |    1 +
 drivers/hid/hid-core.c                       |    2 +
 drivers/hid/hid-cypress.c                    |    2 +
 drivers/hid/hid-ids.h                        |    2 +
 drivers/infiniband/ulp/srp/ib_srp.c          |   87 ++-
 drivers/md/md.c                              |    9 +-
 drivers/media/dvb/siano/smsusb.c             |    2 +-
 drivers/media/video/gspca/spca506.c          |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c                 |   84 ++-
 drivers/net/netconsole.c                     |    1 -
 drivers/net/wireless/ath/ath9k/recv.c        |    2 +-
 drivers/net/wireless/p54/p54usb.c            |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c   |    2 +-
 drivers/pci/pci-driver.c                     |    7 +
 drivers/platform/x86/asus-nb-wmi.c           |    4 +
 drivers/rapidio/devices/tsi721.c             |   12 +-
 drivers/rtc/rtc-rs5c348.c                    |    7 +-
 drivers/staging/speakup/main.c               |    2 +-
 drivers/staging/vt6656/main_usb.c            |    2 +-
 drivers/staging/winbond/wbusb.c              |    2 +-
 drivers/target/target_core_transport.c       |    4 +-
 drivers/tty/serial/pmac_zilog.c              |   12 +-
 drivers/usb/class/cdc-acm.c                  |    3 +-
 drivers/usb/gadget/u_ether.c                 |    6 +
 drivers/usb/host/xhci-pci.c                  |    1 +
 drivers/usb/host/xhci.c                      |    5 +-
 drivers/usb/misc/emi62.c                     |    2 +-
 drivers/usb/serial/ftdi_sio.c                |    1 +
 drivers/usb/serial/ftdi_sio_ids.h            |    7 +
 drivers/usb/serial/mos7840.c                 |    9 +-
 drivers/usb/serial/option.c                  |  275 +++-----
 drivers/video/console/fbcon.c                |    9 +-
 fs/buffer.c                                  |   67 +-
 fs/compat.c                                  |   10 +-
 fs/ext4/super.c                              |    5 +
 fs/fuse/file.c                               |    2 +-
 fs/nfs/blocklayout/blocklayout.c             |    4 +-
 fs/nfs/blocklayout/extents.c                 |    2 +-
 fs/nfs/dir.c                                 |    4 +-
 fs/nfs/nfs3proc.c                            |    2 +-
 fs/nfs/nfs4filelayoutdev.c                   |    2 +-
 fs/nfs/nfs4proc.c                            |   57 +-
 fs/nfs/pnfs.c                                |   39 +-
 fs/nfs/pnfs.h                                |    2 +-
 fs/nfs/super.c                               |    2 +
 fs/nfs/write.c                               |   10 +-
 fs/open.c                                    |    7 +-
 fs/squashfs/super.c                          |    2 +-
 include/asm-generic/mutex-xchg.h             |   11 +-
 include/linux/usb.h                          |   21 +
 kernel/audit_tree.c                          |   11 +-
 kernel/sched.c                               |   34 +-
 mm/vmscan.c                                  |    6 +-
 net/bluetooth/hci_event.c                    |    8 +-
 net/bluetooth/l2cap_core.c                   |   15 +-
 net/dccp/ccid.h                              |    4 +-
 net/sunrpc/svc_xprt.c                        |   10 +-
 net/sunrpc/svcsock.c                         |    2 +-
 sound/pci/hda/hda_proc.c                     |    2 +-
 sound/pci/hda/patch_ca0132.c                 |    8 +
 sound/soc/codecs/wm9712.c                    |   19 +-
 84 files changed, 1673 insertions(+), 555 deletions(-)

AceLan Kao (1):
      asus-nb-wmi: add some video toggle keys

Al Viro (1):
      vfs: missed source of ->f_pos races

Alex Deucher (5):
      drm/radeon/kms: upstream atombios.h updates
      ACPI: export symbol acpi_get_table_with_size
      drm/radeon: convert radeon vfct code to use acpi_get_table_with_size
      drm/radeon: split ATRM support out from the ATPX handler (v3)
      Revert "drm/radeon: fix bo creation retry path"

Alexandre Bounine (2):
      rapidio/tsi721: fix inbound doorbell interrupt handling
      rapidio/tsi721: fix unused variable compiler warning

Amerigo Wang (1):
      netconsole: remove a redundant netconsole_target_put()

Andy Adamson (1):
      NFSv4.1 fix page number calculation bug for filelayout decode buffers

Asias He (4):
      virtio_blk: Drop unused request tracking list
      virtio-blk: Fix hot-unplug race in remove method
      virtio-blk: Call del_gendisk() before disable guest kick
      virtio-blk: Reset device after blk_cleanup_queue()

Atsushi Nemoto (1):
      drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Bart Van Assche (1):
      IB/srp: Fix a race condition

Ben Hutchings (1):
      Linux 3.2.29

Bj=C3=B8rn Mork (1):
      USB: option: Add Vodafone/Huawei K5005 support

Christoph Bumiller (1):
      drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate

Christopher Brannon (1):
      Staging: speakup: fix an improperly-declared variable.

Cyrus Lien (1):
      HID: add ASUS AIO keyboard model AK1D

Daniel Vetter (2):
      drm/i915: ignore eDP bpc settings from vbt
      drm/i915: reorder edp disabling to fix ivb MacBook Air

Dave Airlie (2):
      drm/radeon: fix use after free in ATRM bios reading code.
      fbcon: fix race condition between console lock and cursor timer (v1.1=
)

David Henningsson (1):
      ALSA: hda - don't create dysfunctional mixer controls for ca0132

David Lamparter (1):
      drm/radeon: implement ACPI VFCT vbios fetch (v3)

Glauber Costa (1):
      fs/buffer.c: remove BUG() in possible but rare condition

Greg Kroah-Hartman (7):
      USB: smsusb: remove __devinit* from the struct usb_device_id table
      USB: spca506: remove __devinit* from the struct usb_device_id table
      USB: p54usb: remove __devinit* from the struct usb_device_id table
      USB: rtl8187: remove __devinit* from the struct usb_device_id table
      USB: vt6656: remove __devinit* from the struct usb_device_id table
      USB: winbond: remove __devinit* from the struct usb_device_id table
      USB: emi62: remove __devinit* from the struct usb_device_id table

Gustavo Padovan (1):
      USB: add USB_VENDOR_AND_INTERFACE_INFO() macro

Hugh Dickins (1):
      block: replace __getblk_slow misfix by grow_dev_page fix

Idan Kedar (1):
      pnfs: defer release of pages in layoutget

Igor Murzov (2):
      drm/radeon: fix invalid memory access in radeon_atrm_get_bios()
      drm/radeon: finish getting bios earlier

J. Bruce Fields (3):
      svcrpc: fix BUG() in svc_tcp_clear_pages
      svcrpc: sends on closed socket should stop immediately
      svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping

Jason Wessel (1):
      pmac_zilog,kdb: Fix console poll hook to return instead of loop

Jeff Layton (1):
      nfs: tear down caches in nfs_init_writepagecache when allocation fail=
s

Jim Rees (1):
      fix page number calculation bug for block layout decode buffer

Lionel Vaux (1):
      HID: add support for Cypress barcode scanner 04B4:ED81

Lorenzo Bianconi (1):
      ath9k: fix decrypt_error initialization in ath_rx_tasklet()

Mark Brown (1):
      ASoC: wm9712: Fix microphone source selection

Mark Ferrell (1):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()

Mathias Krause (1):
      dccp: check ccid before dereferencing

Mathieu Desnoyers (1):
      drivers/char/random.c: fix boot id uniqueness race

Mel Gorman (1):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Michael Cree (1):
      alpha: Don't export SOCK_NONBLOCK to user space.

Michael Grzeschik (1):
      usb: gadget: u_ether: fix kworker 100% CPU issue with still used inte=
rfaces in eth_stop

Michael S. Tsirkin (1):
      virtio_blk: fix config handler race

Michal Hocko (1):
      mm: hugetlbfs: correctly populate shared pmd

Miklos Szeredi (3):
      audit: don't free_chunk() after fsnotify_add_mark()
      audit: fix refcounting in audit-tree
      vfs: canonicalize create mode in build_open_flags()

NeilBrown (1):
      md: Don't truncate size at 4TB for RAID0 and Linear

Ozan =C3=87a=C4=9Flayan (1):
      USB: ftdi_sio: Add VID/PID for Kondo Serial USB

Phillip Lougher (1):
      Squashfs: fix mount time sanity check for corrupted superblock

Rafael J. Wysocki (3):
      PCI: EHCI: Fix crash during hibernation on ASUS computers
      PM / Runtime: Fix rpm_resume() return value for power.no_callbacks se=
t
      PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()

Robin Holt (1):
      drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out=
 of IRQ resources

Sarah Sharp (2):
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.

Satoru Moriya (1):
      mm: avoid swapping out with swappiness=3D=3D0

Stanislaw Gruszka (1):
      sched: fix divide by zero at {thread_group,task}_times

Stephen M. Cameron (1):
      cciss: fix incorrect scsi status reporting

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

Szymon Janc (2):
      Bluetooth: Fix legacy pairing with some devices
      Bluetooth: Fix using uninitialized option in RFCMode

Theodore Ts'o (3):
      ext4: avoid kmemcheck complaint from reading uninitialized memory
      ext4: fix long mount times on very big file systems
      MAINTAINERS: Theodore Ts'o is taking over the random driver

Tony Luck (2):
      random: Add comment to random_initialize()
      dmi: Feed DMI table to /dev/random driver

Trond Myklebust (3):
      NFS: Use kcalloc() when allocating arrays
      NFSv3: Ensure that do_proc_get_root() reports errors correctly
      NFS: Fix Oopses in nfs_lookup_revalidate and nfs4_lookup_revalidate

Tvrtko Ursulin (1):
      drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to =
cover later silicon stepping

Wang Xingchao (1):
      ALSA: hda - fix Copyright debug message

Will Deacon (4):
      ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_VFPv3 is e=
nabled
      ARM: 7488/1: mm: use 5 bits for swapfile type encoding
      ARM: 7489/1: errata: fix workaround for erratum #720789 on UP systems
      mutex: Place lock in contended state after fastpath_lock failure

Yi Zou (1):
      target: fix NULL pointer dereference bug alloc_page() fails to get me=
mory

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

bjschuma@gmail.com (1):
      NFS: Alias the nfs module to nfs4

fangxiaozhi (1):
      USB: support the new interfaces of Huawei Data Card devices in option=
 driver


--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-zaYWNx7/LBbTUVa+Czln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFCkbue/yOyVhhEJAQoPSA//a3EHrrYRrfgBJkiI1YAjCdxGhnNcbjvl
oOz4SYuOxnA38LjMcQ4duMXUpc8BIMWtROMrjTYblSydZSbspSlE0fZAOicufj3A
7QaMn3BLl87it5vhzlWvcFIUcRT77OjRjwTOJUzWnorC+zUTy1eGL5s+JR5lgMnI
tm8QJ7mE6J74nfti7/w0xUWHfTHyR2DU5BasiEiXPJx5Qc3YBOCLVK3T/WdBw9qb
nqsVg90QUq/iNgnqRgHg49N0zhyEAETP0pPBn1LWbVZUQ1t1lO4ya4rNCH23VNfM
qffQTIZybKwzbJTDrjGHTWWlz6on4Yn8sAYJwGRvzZn2FqZ2YpHY2y2QhzaN/x/8
niWNhw3NoCDObhZ4n+kzV5AqZOegmrW4PbwO4TLHEUJQK4XtT+g+58K9HVb3hs+q
OD5aJaZ71GqmqfKyp7XV1cWNMpE/XPlYT/2DkOSLffsnsrehX2jmE8iLL1FsrH9l
ey1PpFLv/hAuV2CfEzhK3TkGhdEVD0UskoWhtLO2b6umLq6s7PuuFiLjaEugR4Ik
ZDapRMb3r5PSKp6+mR2o8k42fbJBWVO7+kjtbME5ZKMWHptopzaRnhMipperpv9d
knTa5wbApBhyvtrsYxCovAM4EPRHyUNAMn3ZRdRFmKanYMn7GfiKvt3+rPBE6IY3
AfyX5KRgxaA=
=kHOQ
-----END PGP SIGNATURE-----

--=-zaYWNx7/LBbTUVa+Czln--

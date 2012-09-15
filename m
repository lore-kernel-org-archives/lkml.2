Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2IODkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:40:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55721 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2IODkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:40:09 -0400
Date: Fri, 14 Sep 2012 20:40:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.11
Message-ID: <20120915034004.GA16155@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.11 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-i801          |    1=20
 Makefile                                   |    2=20
 arch/alpha/include/asm/fpu.h               |    2=20
 arch/alpha/include/asm/socket.h            |    2=20
 arch/arm/Kconfig                           |    1=20
 arch/arm/include/asm/pgtable.h             |   40 +++++++++--------
 arch/arm/mach-imx/hotplug.c                |   23 +---------
 arch/arm/mach-s3c24xx/include/mach/dma.h   |    3 -
 arch/arm/mm/flush.c                        |    2=20
 arch/arm/mm/tlb-v7.S                       |    6 +-
 arch/arm/plat-omap/dmtimer.c               |    2=20
 arch/arm/plat-s3c24xx/dma.c                |    2=20
 arch/arm/vfp/vfpmodule.c                   |    2=20
 arch/parisc/include/asm/atomic.h           |    4 -
 arch/powerpc/kernel/asm-offsets.c          |    1=20
 arch/powerpc/kernel/dbell.c                |    2=20
 arch/powerpc/kernel/entry_64.S             |   23 +++++++---
 arch/powerpc/kernel/process.c              |   12 -----
 arch/powerpc/kernel/smp.c                  |   11 +++-
 arch/powerpc/kernel/sysfs.c                |   10 ++++
 arch/powerpc/kernel/traps.c                |    3 -
 arch/powerpc/sysdev/xics/icp-hv.c          |    6 ++
 arch/x86/kernel/microcode_amd.c            |    7 +--
 arch/x86/mm/hugetlbpage.c                  |   21 +++++++--
 arch/x86/syscalls/syscall_64.tbl           |    6 +-
 arch/x86/xen/setup.c                       |    9 +++
 drivers/acpi/acpica/tbxface.c              |    1=20
 drivers/block/cciss_scsi.c                 |   11 ----
 drivers/dma/imx-dma.c                      |   36 ++++-----------
 drivers/gpu/drm/radeon/radeon_object.c     |    3 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        |    6 ++
 drivers/hid/usbhid/hid-quirks.c            |    1=20
 drivers/hwmon/asus_atk0110.c               |    6 ++
 drivers/i2c/busses/Kconfig                 |    6 ++
 drivers/i2c/busses/Makefile                |    5 +-
 drivers/i2c/busses/i2c-designware-core.c   |   11 ++++
 drivers/i2c/busses/i2c-i801.c              |    3 +
 drivers/input/serio/i8042-x86ia64io.h      |   14 ++++++
 drivers/media/dvb/siano/smsusb.c           |    2=20
 drivers/media/video/gspca/jl2005bcd.c      |    2=20
 drivers/media/video/gspca/spca506.c        |    2=20
 drivers/media/video/uvc/uvc_queue.c        |    1=20
 drivers/net/wireless/ath/ath9k/recv.c      |    2=20
 drivers/net/wireless/p54/p54usb.c          |    2=20
 drivers/net/wireless/rtl818x/rtl8187/dev.c |    2=20
 drivers/pci/pci-driver.c                   |    7 +++
 drivers/rapidio/devices/tsi721.c           |   12 ++++-
 drivers/regulator/twl-regulator.c          |    4 -
 drivers/scsi/megaraid/megaraid_sas_base.c  |    3 -
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   13 +++--
 drivers/scsi/scsi_error.c                  |   10 ++++
 drivers/scsi/scsi_lib.c                    |    5 +-
 drivers/scsi/scsi_scan.c                   |   10 ++++
 drivers/staging/vt6656/main_usb.c          |    2=20
 drivers/staging/winbond/wbusb.c            |    2=20
 drivers/target/target_core_transport.c     |    4 -
 drivers/usb/class/cdc-acm.c                |    3 -
 drivers/usb/misc/emi62.c                   |    2=20
 drivers/xen/swiotlb-xen.c                  |    2=20
 drivers/xen/xen-pciback/pci_stub.c         |    8 +--
 fs/buffer.c                                |   66 +++++++++++++-----------=
-----
 fs/compat.c                                |   10 +++-
 fs/ext3/inode.c                            |   17 ++++++-
 fs/fuse/dev.c                              |    1=20
 fs/nfs/idmap.c                             |   62 +++++++++++++++++++-----=
---
 fs/nfs/nfs3proc.c                          |    2=20
 fs/nfs/nfs4proc.c                          |   65 ++++++++++++++++++++++++=
+---
 fs/nfs/pnfs.c                              |   39 -----------------
 fs/nfs/pnfs.h                              |    2=20
 fs/nfs/super.c                             |    2=20
 fs/open.c                                  |    7 +--
 fs/ubifs/debug.h                           |    2=20
 fs/udf/file.c                              |   35 ++++++++++++---
 kernel/audit_tree.c                        |   11 ++--
 kernel/sched/core.c                        |   35 +++++++++------
 kernel/sched/sched.h                       |    2=20
 mm/mempolicy.c                             |    2=20
 net/bluetooth/hci_event.c                  |   28 +++++++++---
 net/bluetooth/l2cap_core.c                 |    1=20
 net/dccp/ccid.h                            |    4 -
 net/socket.c                               |    4 -
 net/sunrpc/svc_xprt.c                      |   10 +---
 net/sunrpc/svcsock.c                       |    2=20
 sound/pci/hda/hda_proc.c                   |    2=20
 sound/pci/hda/patch_ca0132.c               |    8 +++
 sound/soc/codecs/wm9712.c                  |   19 +++++++-
 sound/soc/omap/mcbsp.c                     |    2=20
 88 files changed, 540 insertions(+), 307 deletions(-)

Aaro Koskinen (1):
      regulator: twl-regulator: fix up VINTANA1/VINTANA2

Al Viro (1):
      vfs: missed source of ->f_pos races

Alan Cox (1):
      drm: stop vmgfx driver explosion

Alan Stern (1):
      HID: add NOGET quirk for Eaton Ellipse MAX UPS

Alex Deucher (2):
      Revert "drm/radeon: fix bo creation retry path"
      ACPI: export symbol acpi_get_table_with_size

Alexandre Bounine (2):
      rapidio/tsi721: fix inbound doorbell interrupt handling
      rapidio/tsi721: fix unused variable compiler warning

Andreas Herrmann (1):
      x86, microcode, AMD: Fix broken ucode patch size check

Anton Blanchard (4):
      powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
      powerpc: Keep thread.dscr and thread.dscr_inherit in sync
      powerpc: Fix DSCR inheritance in copy_thread()
      powerpc: Restore correct DSCR in context switch

Arnd Bergmann (1):
      ARM: imx: select CPU_FREQ_TABLE when needed

Artem Bityutskiy (1):
      UBIFS: fix complaints about too small debug buffer size

Axel Lin (1):
      i2c-designware: Fix build error if CONFIG_I2C_DESIGNWARE_PLATFORM=3Dy=
 && CONFIG_I2C_DESIGNWARE_PCI=3Dy

Bryan Schumaker (2):
      NFS: Clear key construction data if the idmap upcall fails
      NFS: return -ENOKEY when the upcall fails to map the name

Dave Airlie (1):
      drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot

Dave Jones (1):
      Remove user-triggerable BUG from mpol_to_str

David Henningsson (1):
      ALSA: hda - don't create dysfunctional mixer controls for ca0132

Dmitry Torokhov (1):
      Input: i8042 - add Gigabyte T1005 series netbooks to noloop table

Fabio Estevam (1):
      Revert dma: imx-dma: Fix kernel crash due to missing clock conversion

Greg Kroah-Hartman (9):
      USB: vt6656: remove __devinit* from the struct usb_device_id table
      USB: emi62: remove __devinit* from the struct usb_device_id table
      USB: winbond: remove __devinit* from the struct usb_device_id table
      USB: spca506: remove __devinit* from the struct usb_device_id table
      USB: jl2005bcd: remove __devinit* from the struct usb_device_id table
      USB: p54usb: remove __devinit* from the struct usb_device_id table
      USB: rtl8187: remove __devinit* from the struct usb_device_id table
      USB: smsusb: remove __devinit* from the struct usb_device_id table
      Linux 3.4.11

Heiko Stuebner (2):
      ARM: S3C24XX: Add missing DMACH_DT_PROP
      ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters

Hugh Dickins (1):
      block: replace __getblk_slow misfix by grow_dev_page fix

Idan Kedar (1):
      pnfs: defer release of pages in layoutget

J. Bruce Fields (3):
      svcrpc: fix BUG() in svc_tcp_clear_pages
      svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
      svcrpc: sends on closed socket should stop immediately

James Bottomley (1):
      SCSI: Fix 'Device not ready' issue on mpt2sas

James Ralston (1):
      i2c-i801: Add Device IDs for Intel Lynx Point-LP PCH

Jan Kara (2):
      udf: Fix data corruption for files in ICB
      ext3: Fix fdatasync() for files with only i_size changes

Jayakrishnan Memana (1):
      uvcvideo: Reset the bytesused field when recycling an erroneous buffer

Jon Hunter (1):
      ARM: OMAP2+: Fix dmtimer set source clock failure

Kashyap Desai (1):
      SCSI: megaraid_sas: Move poll_aen_lock initializer

Konrad Rzeszutek Wilk (2):
      xen/setup: Fix one-off error when adding for-balloon PFNs to the P2M.
      xen/pciback: Fix proper FLR steps.

Lorenzo Bianconi (1):
      ath9k: fix decrypt_error initialization in ath_rx_tasklet()

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Add quirk for Asus M5A78L

Mark Brown (1):
      ASoC: wm9712: Fix microphone source selection

Mathias Krause (1):
      dccp: check ccid before dereferencing

Mel Gorman (1):
      PARISC: Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Michael Cree (1):
      alpha: Don't export SOCK_NONBLOCK to user space.

Michal Hocko (1):
      mm: hugetlbfs: correctly populate shared pmd

Mike Frysinger (2):
      alpha: fix fpu.h usage in userspace
      x32: Use compat shims for {g,s}etsockopt

Mike Galbraith (1):
      sched,cgroup: Fix up task_groups list

Mike Snitzer (1):
      SCSI: scsi_lib: fix scsi_io_completion's SG_IO error propagation

Miklos Szeredi (4):
      vfs: canonicalize create mode in build_open_flags()
      audit: don't free_chunk() after fsnotify_add_mark()
      audit: fix refcounting in audit-tree
      fuse: fix retrieve length

Mikulas Patocka (1):
      Fix order of arguments to compat_put_time[spec|val]

Paul Mackerras (1):
      powerpc: Make sure IPI handlers see data written by IPI senders

Peter Ujfalusi (1):
      ASoC: omap-mcbsp: Fix 6pin mux configuration

Rafael J. Wysocki (1):
      PCI: EHCI: Fix crash during hibernation on ASUS computers

Ram Malovany (3):
      Bluetooth: Fix using NULL inquiry entry
      Bluetooth: Fix using a NULL inquiry cache entry
      Bluetooth: Set name_state to unknown when entry name is empty

Ronny Hegewald (1):
      xen: Use correct masking in xen_swiotlb_alloc_coherent.

Shawn Guo (1):
      ARM: imx6: spin the cpu until hardware takes it down

Stanislaw Gruszka (1):
      sched: fix divide by zero at {thread_group,task}_times

Stephen M. Cameron (1):
      cciss: fix incorrect scsi status reporting

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

Szymon Janc (1):
      Bluetooth: Fix legacy pairing with some devices

Trond Myklebust (2):
      NFSv3: Ensure that do_proc_get_root() reports errors correctly
      NFSv4.1: Remove a bogus BUG_ON() in nfs4_layoutreturn_done

Wang Xingchao (1):
      ALSA: hda - fix Copyright debug message

Will Deacon (4):
      ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_VFPv3 is e=
nabled
      ARM: 7487/1: mm: avoid setting nG bit for user mappings that aren't p=
resent
      ARM: 7488/1: mm: use 5 bits for swapfile type encoding
      ARM: 7489/1: errata: fix workaround for erratum #720789 on UP systems

Yi Zou (1):
      target: fix NULL pointer dereference bug alloc_page() fails to get me=
mory

bjschuma@gmail.com (1):
      NFS: Alias the nfs module to nfs4

sreekanth.reddy@lsi.com (1):
      SCSI: mpt2sas: Fix for Driver oops, when loading driver with max_queu=
e_depth command line option to a very small value


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQU/iUAAoJEDjbvchgkmk+Nr4P/A2xoIAtzBKBydrkBHXcEIsA
xrH4RETWLcPmvkk91Fwqm5womihHiGM8pPlCeNJ0cNk8n0QIkLA8tb30BggDOdv1
eyhkGsL3aLCtv5tx9w8EPa60hzfOYAm8/5e+bmEjmb9fK7Jnnle8HEPQwjz9JVpH
D2wcH/cg2oWE0KfUyqaNXZZcBtaSIuBke1S2c05ubiERgvNX4tCfU7Zy4auTRDnM
S7c+tfMXVJvje9c5KWkfWSzhc9HIDaqTyNRWy4ZyvixOxf/21MNZn7B5DWwic+vZ
xLiccHAyTnZtvUAqTlArBbwL/i27VTeEYw0VfatpN4LPeYglwngWc2H21VX4lyvG
677qszCnhSLvElE7+uMrqxhXeNNVbWU8VgEgKJlHS8WRRvP8orLYb7SmDV72Za7c
MHeo4JqK6MUxrvZW85S3ukAvvwbF8wyITvRYDPBMZScWml1O4+Q/Ylx8S2G8jLIA
Ar0882sffhQIVleCHQnd51u8mUYcO8WBWFqj2ym0ZSiwXiA2DHc1CoiaEwcEOy+r
c1ja7FbGe90iSVWO72atzXXbudKN2N4kqjXkA+Es+bWvhCty9/PL1UcxUAZzVtfE
foAAva5ogQvlXGmbzX9wEryMz5wYLUBDu3ok4PB2khwN7FIsxQBwkTiijM0iq+YX
Wjt4HJp3oXnLR4Zj2yON
=2e3K
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--

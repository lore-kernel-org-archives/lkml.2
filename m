Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2IODir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:38:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54194 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2IODio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:38:44 -0400
Date: Fri, 14 Sep 2012 20:38:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.43
Message-ID: <20120915033839.GA16101@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.43 kernel.

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

 Makefile                                   |    2=20
 arch/alpha/include/asm/socket.h            |    2=20
 arch/arm/Kconfig                           |    1=20
 arch/arm/include/asm/pgtable.h             |   40 +++++++++--------
 arch/arm/mm/flush.c                        |    2=20
 arch/arm/mm/tlb-v7.S                       |    6 +-
 arch/arm/plat-s3c24xx/dma.c                |    2=20
 arch/parisc/include/asm/atomic.h           |    4 -
 arch/powerpc/kernel/asm-offsets.c          |    1=20
 arch/powerpc/kernel/entry_64.S             |   23 +++++++---
 arch/powerpc/kernel/process.c              |   12 -----
 arch/x86/mm/hugetlbpage.c                  |   21 +++++++--
 drivers/acpi/acpica/tbxface.c              |    1=20
 drivers/block/cciss_scsi.c                 |   11 ----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |    1=20
 drivers/hwmon/asus_atk0110.c               |    6 ++
 drivers/input/serio/i8042-x86ia64io.h      |   14 ++++++
 drivers/media/dvb/siano/smsusb.c           |    2=20
 drivers/media/video/gspca/spca506.c        |    2=20
 drivers/net/wireless/ath/ath9k/recv.c      |    2=20
 drivers/net/wireless/p54/p54usb.c          |    2=20
 drivers/net/wireless/rtl818x/rtl8187/dev.c |    2=20
 drivers/pci/pci-driver.c                   |    7 +++
 drivers/scsi/megaraid/megaraid_sas_base.c  |    3 -
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   13 +++--
 drivers/scsi/scsi_error.c                  |   10 ++++
 drivers/scsi/scsi_scan.c                   |   10 ++++
 drivers/staging/vt6656/main_usb.c          |    2=20
 drivers/staging/winbond/wbusb.c            |    2=20
 drivers/usb/class/cdc-acm.c                |    3 -
 drivers/usb/misc/emi62.c                   |    2=20
 fs/buffer.c                                |   66 +++++++++++++-----------=
-----
 fs/compat.c                                |   10 +++-
 fs/ext3/inode.c                            |   17 ++++++-
 fs/fuse/dev.c                              |    1=20
 fs/nfs/nfs3proc.c                          |    2=20
 fs/nfs/nfs4proc.c                          |    8 ---
 fs/nfs/super.c                             |    2=20
 fs/open.c                                  |    7 +--
 fs/udf/file.c                              |   35 ++++++++++++---
 kernel/audit_tree.c                        |   11 ++--
 mm/mempolicy.c                             |    2=20
 net/dccp/ccid.h                            |    4 -
 net/sunrpc/svc_xprt.c                      |   10 +---
 net/sunrpc/svcsock.c                       |    2=20
 sound/pci/hda/hda_proc.c                   |    2=20
 sound/soc/codecs/wm9712.c                  |   19 +++++++-
 47 files changed, 259 insertions(+), 150 deletions(-)

Al Viro (1):
      vfs: missed source of ->f_pos races

Alex Deucher (1):
      ACPI: export symbol acpi_get_table_with_size

Anton Blanchard (2):
      powerpc: Fix DSCR inheritance in copy_thread()
      powerpc: Restore correct DSCR in context switch

Arnd Bergmann (1):
      ARM: imx: select CPU_FREQ_TABLE when needed

Dave Airlie (1):
      drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot

Dave Jones (1):
      Remove user-triggerable BUG from mpol_to_str

Dmitry Torokhov (1):
      Input: i8042 - add Gigabyte T1005 series netbooks to noloop table

Greg Kroah-Hartman (8):
      USB: vt6656: remove __devinit* from the struct usb_device_id table
      USB: emi62: remove __devinit* from the struct usb_device_id table
      USB: winbond: remove __devinit* from the struct usb_device_id table
      USB: spca506: remove __devinit* from the struct usb_device_id table
      USB: p54usb: remove __devinit* from the struct usb_device_id table
      USB: rtl8187: remove __devinit* from the struct usb_device_id table
      USB: smsusb: remove __devinit* from the struct usb_device_id table
      Linux 3.0.43

Heiko Stuebner (1):
      ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters

Hugh Dickins (1):
      block: replace __getblk_slow misfix by grow_dev_page fix

J. Bruce Fields (3):
      svcrpc: fix BUG() in svc_tcp_clear_pages
      svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
      svcrpc: sends on closed socket should stop immediately

James Bottomley (1):
      SCSI: Fix 'Device not ready' issue on mpt2sas

Jan Kara (2):
      udf: Fix data corruption for files in ICB
      ext3: Fix fdatasync() for files with only i_size changes

Kashyap Desai (1):
      SCSI: megaraid_sas: Move poll_aen_lock initializer

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

Miklos Szeredi (4):
      vfs: canonicalize create mode in build_open_flags()
      audit: don't free_chunk() after fsnotify_add_mark()
      audit: fix refcounting in audit-tree
      fuse: fix retrieve length

Rafael J. Wysocki (1):
      PCI: EHCI: Fix crash during hibernation on ASUS computers

Stephen M. Cameron (1):
      cciss: fix incorrect scsi status reporting

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

Trond Myklebust (2):
      NFSv3: Ensure that do_proc_get_root() reports errors correctly
      NFSv4.1: Remove a bogus BUG_ON() in nfs4_layoutreturn_done

Wang Xingchao (1):
      ALSA: hda - fix Copyright debug message

Will Deacon (3):
      ARM: 7487/1: mm: avoid setting nG bit for user mappings that aren't p=
resent
      ARM: 7488/1: mm: use 5 bits for swapfile type encoding
      ARM: 7489/1: errata: fix workaround for erratum #720789 on UP systems

bjschuma@gmail.com (1):
      NFS: Alias the nfs module to nfs4

sreekanth.reddy@lsi.com (1):
      SCSI: mpt2sas: Fix for Driver oops, when loading driver with max_queu=
e_depth command line option to a very small value


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQU/g/AAoJEDjbvchgkmk+XZAQAKgj2rwYL4xhOwXIEWGAyK3S
TsDY0yZtZWMfyxgave08MTdt35pmPQ8hIVPSvaVVrgyuX88aF2vHJ4FOYMPr5AXh
73i8Aev1+9oFtris/w6PyDYFBWqFtWFDQLYFDF2OYnANPzYPVXTBZj5nw+9wxLhx
9vkt1g1gEyCaCKBJsN9OYNgujVGLspL/VO+4aOClqDaNor3kKTMyq777o6lMQvL9
InCAZnGV+L+moYFjmw4UCk94DXzjpunMUVPvYBjB6B7vU6vWrCwdWUzil0lQNKS4
5Oh4+UeHO53IboSg3SdXr7wcaqen4yDYbLx8WWg255Q9iDsLNmDwZH4U9bLmu7w5
psFYerlc9sLcuCb7l4mnbXB7B4FonQ5A1mZv+FkzmBXQBzt2Xlmaj//gWL8tKaz3
BC314K8TuW7zdjO8MYQkLRrT6oxwirP1TRfJj/bCNMNx9G3GYfgZCg8udnn8OrS6
wT5NnyFRBB5vAB88wWPFabxTGa3p0yVSNH9E1vwUBNmYK/vpu062POJgPYINWGnJ
O0lTKTzuzLBpW64/FaxQxtDuq7mmKxmt/Y3raATJJ4w6lPRZBPeMStY70HRXWxEG
Y5YDkkhGFebJTaF6uE2P1YmCZGc7cNIeXFlWzK15tNMcQ+PUK6b+Iu5UDamP49dj
QYteyrzAVtxF6Vf/s+fB
=X3Mo
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--

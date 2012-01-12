Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2ALUZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:25:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53635 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126Ab2ALUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:25:30 -0500
X-Sasl-enc: x2MMbAxVz2ibDVLsibAKlMKCW+LpCNW6fS7PVZ4w10u2 1326399929
Date: Thu, 12 Jan 2012 12:21:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.17
Message-ID: <20120112202136.GA15607@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.17 kernel.

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

 Documentation/HOWTO                          |    4 -
 Documentation/development-process/5.Posting  |    8 +-
 Documentation/usb/usbmon.txt                 |   14 +++--
 MAINTAINERS                                  |    2=20
 Makefile                                     |    2=20
 arch/powerpc/include/asm/time.h              |    2=20
 arch/powerpc/kernel/irq.c                    |   15 ++---
 arch/powerpc/kernel/time.c                   |    9 +++
 arch/powerpc/platforms/pseries/hvCall_inst.c |    4 -
 arch/powerpc/platforms/pseries/lpar.c        |    2=20
 drivers/base/firmware_class.c                |   14 ++---
 drivers/infiniband/hw/qib/qib_iba6120.c      |    4 +
 drivers/infiniband/hw/qib/qib_iba7220.c      |    4 +
 drivers/infiniband/hw/qib/qib_iba7322.c      |    6 +-
 drivers/net/bonding/bond_main.c              |    9 ++-
 drivers/net/usb/asix.c                       |    6 +-
 drivers/net/wireless/rt2x00/rt2800usb.c      |    2=20
 drivers/net/wireless/wl12xx/boot.c           |   14 +++++
 drivers/net/wireless/wl12xx/cmd.c            |   22 ++++++++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    1=20
 drivers/tty/serial/atmel_serial.c            |    5 +
 drivers/usb/class/cdc-acm.c                  |   16 +++++
 drivers/usb/core/hcd.c                       |    5 -
 drivers/usb/core/quirks.c                    |    5 +
 drivers/usb/host/ehci-q.c                    |    2=20
 drivers/usb/host/ohci-hcd.c                  |   15 ++---
 drivers/usb/host/ohci-pci.c                  |   26 ---------
 drivers/usb/host/ohci.h                      |    1=20
 drivers/usb/host/pci-quirks.c                |   50 ++++++++----------
 drivers/usb/host/uhci-q.c                    |    2=20
 drivers/usb/host/whci/qset.c                 |    4 -
 drivers/usb/host/xhci-ring.c                 |    4 -
 drivers/usb/host/xhci.c                      |    4 -
 drivers/usb/host/xhci.h                      |    1=20
 drivers/usb/misc/isight_firmware.c           |    6 +-
 drivers/usb/musb/musb_core.c                 |    2=20
 drivers/usb/serial/cp210x.c                  |    1=20
 drivers/usb/serial/omninet.c                 |    2=20
 drivers/usb/serial/option.c                  |   10 +++
 drivers/usb/storage/usb.c                    |    1=20
 drivers/video/offb.c                         |   52 ++++++++----------
 fs/ext3/inode.c                              |   24 +++++++-
 fs/reiserfs/super.c                          |   27 +++++----
 fs/udf/file.c                                |    6 +-
 fs/udf/inode.c                               |   21 ++++++-
 fs/xfs/linux-2.6/xfs_acl.c                   |    2=20
 include/linux/usb.h                          |    1=20
 include/linux/usb/ch9.h                      |   20 ++++++-
 kernel/cgroup.c                              |    6 +-
 kernel/cpu.c                                 |   74 ++++++++++++++++++++++=
+++++
 net/ipv4/igmp.c                              |    2=20
 tools/perf/util/trace-event-parse.c          |    2=20
 52 files changed, 364 insertions(+), 179 deletions(-)

Alan Stern (2):
      USB: update documentation for usbmon
      OHCI: final fix for NVIDIA problems (I hope)

Anton Blanchard (1):
      powerpc/time: Handle wrapping of decrementer

Aurelien Jacobs (2):
      asix: new device id
      asix: fix infinite loop in rx_fixup()

Ben Hutchings (1):
      igmp: Avoid zero delay when receiving odd mixture of IGMP queries

Benjamin Herrenschmidt (2):
      offb: Fix setting of the pseudo-palette for >8bpp
      offb: Fix bug in calculating requested vram size

Claudio Scordino (1):
      atmel_serial: fix spinlock lockup in RS485 code

Clemens Ladisch (1):
      usb: fix number of mapped SG DMA entries

Felipe Balbi (1):
      usb: ch9: fix up MaxStreams helper

Felipe Contreras (1):
      usb: musb: fix pm_runtime mismatch

Greg Kroah-Hartman (2):
      USB: isight: fix kernel bug when loading firmware
      Linux 3.0.17

Hans de Goede (1):
      xhci: Properly handle COMP_2ND_BW_ERR

Huajun Li (1):
      usb: usb-storage doesn't support dynamic id currently, the patch disa=
bles the feature to fix an oops

Jan Kara (3):
      reiserfs: Fix quota mount option parsing
      ext3: Don't warn from writepage when readonly inode is spotted after =
error
      udf: Fix deadlock when converting file from in-ICB one to normal one

Janne Snabb (1):
      usb: option: add ZD Incorporated HSPA modem

Jeff Mahoney (1):
      reiserfs: Force inode evictions before umount to avoid crash

Joe Perches (2):
      MAINTAINERS: stable: Update address
      Documentation: Update stable address

Johan Hovold (1):
      USB: omninet: fix write_room

Julia Lawall (1):
      drivers/usb/class/cdc-acm.c: clear dangling pointer

Larry Finger (1):
      rt2800usb: Move ID out of unknown

Li Zefan (1):
      cgroup: fix to allow mounting a hierarchy by name

Li Zhong (1):
      powerpc: Fix unpaired probe_hcall_entry and probe_hcall_exit

Malte Schr=F6der (1):
      USB: Add USB-ID for Multiplex RC serial adapter to cp210x.c

Neil Horman (1):
      firmware: Fix an oops on reading fw_priv->fw in sysfs loading file

Oliver Neukum (1):
      USB: add quirk for another camera

Pontus Fuchs (2):
      wl12xx: Validate FEM index from ini file and FW
      wl12xx: Check buffer bound when processing nvs data

Ram Vepa (1):
      IB/qib: Fix a possible data corruption when receiving packets

Srivatsa S. Bhat (1):
      PM / Sleep: Fix race between CPU hotplug and freezer

Steven Rostedt (1):
      perf: Fix parsing of __print_flags() in TP_printk()

Thilo-Alexander Ginkel (1):
      usb: cdc-acm: Fix acm_tty_hangup() vs. acm_tty_close() race

VU Tuan Duc (1):
      USB: option: add id for 3G dongle Model VT1000 of Viettel

Xi Wang (1):
      xfs: fix acl count validation in xfs_acl_from_disk()

kashyap.desai@lsi.com (1):
      SCSI: mpt2sas: Added missing mpt2sas_base_detach call from scsih_remo=
ve context

stephen hemminger (1):
      bonding: fix error handling if slave is busy (v2)


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPD0DQAAoJEDjbvchgkmk+bZgQAMj3D1CO3UMXdgCRL2cbuSWc
BIIWV5huyhUL0R+NQsHUk+oPurGQpGBqVZeD1+vhihoKa0bj/rE0eX37I7upGEQv
aijTColXurbuhe3Zwtr6kqLMTTSULG+J64CYSjWUK7FFw8ihkB3mJng64r2DFMEJ
o7Bv/OepOQuhJGOJ4WuJ5aZZ4VHym9vxVy+aKjAsrKZ5cHmdBLjWNK2EmYyuIVTo
lzWtGlyAbyf+MVvccQQ+BccTYkWQPiA3Id+Mijwg+S3h/6J9KIaBiqzmWoW52Ut2
bJS8sOnveTwjsiHNTmFqvw/Trnfgswpb6XRKX0s1HpotUGM3KWoVrcjQCBJjMFV9
ptUFW+d//GFFWEf3iNhJCaukT3acvHmGlPFXiSmOkG4qTsXyKlTcD6Ck3XdDqYML
7M1dqtjk/vqfbRPCns81tR09Gc7e8XFNHvhICddCJp6BVuuWg29/Vy3267askjE6
V9CTU+7vZxg0tcDQ8DeyM/MBx9CJavmA380SyTq39TFI9KdFyhYHOBA/sFNlNWjt
H94NhhmoQr+2/1fgU2GnPhDrbktUYPadiRsvkhwuu9rbURGZKPZGxoXgoVYlwYHL
o37qFKDfqrZJ6QmRK8836/VGzaLpgVdSbvvCpt9ySx7TPCPy+en7YPVAmFauMMHl
JIeRL7gLr33Zbqvs1eMO
=ZO+S
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

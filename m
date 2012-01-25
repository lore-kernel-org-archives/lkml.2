Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab2AYWgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:36:25 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57693 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab2AYWgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:36:23 -0500
X-Sasl-enc: gE3IP/A3vOrnYil1KyaeFAlgV58IIc4WFEZOP5o+yUJY 1327530981
Date: Wed, 25 Jan 2012 14:34:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.55
Message-ID: <20120125223434.GA31647@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.55 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                            |    2 -
 arch/score/kernel/entry.S           |    2 -
 arch/x86/mm/mmap.c                  |    4 +--
 block/scsi_ioctl.c                  |    7 +++++
 drivers/block/cciss.c               |    6 ++--
 drivers/block/ub.c                  |    3 --
 drivers/block/virtio_blk.c          |    4 +--
 drivers/cdrom/cdrom.c               |    3 --
 drivers/hid/hid-core.c              |    2 -
 drivers/i2c/busses/i2c-ali1535.c    |   11 +++++----
 drivers/i2c/busses/i2c-nforce2.c    |    2 -
 drivers/i2c/busses/i2c-sis5595.c    |    4 +--
 drivers/i2c/busses/i2c-sis630.c     |    6 ++++
 drivers/i2c/busses/i2c-viapro.c     |    7 ++++-
 drivers/ide/ide-floppy_ioctl.c      |    3 --
 drivers/media/video/v4l2-ioctl.c    |    6 ++++
 drivers/mtd/ubi/cdev.c              |    3 ++
 drivers/mtd/ubi/wl.c                |    7 +++--
 drivers/pci/msi.c                   |   10 ++++++++
 drivers/pnp/quirks.c                |   42 +++++++++++++++++++++++++++++++=
+++
 drivers/scsi/sd.c                   |    2 -
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 +++
 drivers/usb/class/cdc-wdm.c         |    4 +--
 drivers/xen/xenbus/xenbus_xs.c      |    6 ++++
 fs/ext4/super.c                     |    7 ++---
 fs/nfsd/export.c                    |    2 -
 fs/proc/uptime.c                    |    9 +++++--
 include/linux/blkdev.h              |    2 +
 include/linux/kernel.h              |   44 +++++++++++++++++++++++++++++++=
+++++
 include/linux/pci_regs.h            |    2 -
 include/linux/sunrpc/svcsock.h      |    2 -
 include/linux/videodev2.h           |    1=20
 include/xen/interface/io/xs_wire.h  |    3 ++
 kernel/kprobes.c                    |    2 -
 net/sunrpc/svc.c                    |   10 +++-----
 net/sunrpc/svc_xprt.c               |   11 ++++++++-
 security/integrity/ima/ima_api.c    |    4 +--
 security/integrity/ima/ima_queue.c  |    1=20
 sound/pci/hda/hda_local.h           |    7 ++++-
 sound/pci/hda/hda_proc.c            |    2 +
 sound/pci/hda/patch_sigmatel.c      |    2 -
 sound/pci/ice1712/amp.c             |    7 ++++-
 sound/usb/usx2y/usb_stream.c        |    6 +---
 43 files changed, 215 insertions(+), 59 deletions(-)

Alex Williamson (1):
      PCI: Fix PCI_EXP_TYPE_RC_EC value

Ananth N Mavinakayanahalli (1):
      kprobes: initialize before using a hlist

Artem Bityutskiy (1):
      UBI: fix use-after-free on error path

Bjorn Helgaas (1):
      PNP: work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB

Chase Douglas (1):
      HID: bump maximum global item tag report size to 96 bytes

Dan Carpenter (1):
      V4L/DVB: v4l2-ioctl: integer overflow in video_usercopy()

Dan Rosenberg (1):
      score: fix off-by-one index into syscall table

David Henningsson (1):
      ALSA: HDA: Fix internal microphone on Dell Studio 16 XPS 1645

David Sterba (1):
      USB: cdc-wdm: fix misuse of logical operation in place of bitop

Eric W. Biederman (1):
      PCI: msi: Disable msi interrupts when we initialize a pci device

Greg Kroah-Hartman (1):
      Linux 2.6.32.55

Ian Campbell (1):
      xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.

J. Bruce Fields (2):
      svcrpc: fix double-free on shutdown of nfsd after changing pool mode
      svcrpc: destroy server sockets all at once

Jean Delvare (1):
      i2c: Fix error value returned by several bus drivers

Joe Perches (1):
      kernel.h: add printk_ratelimited and pr_<level>_rl

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Delete calls to preempt_disable

Ludwig Nussel (1):
      x86: Fix mmap random address range

Martin Schwidefsky (1):
      fix cputime overflow in uptime_proc_show

Paolo Bonzini (1):
      block: add and use scsi_blk_cmd_ioctl

Pavel Hofman (1):
      ALSA: ice1724 - Check for ac97 to avoid kernel oops

Richard Weinberger (1):
      UBI: fix nameless volumes handling

Robert Lukassen (1):
      USB: Fix 'bad dma' problem on WDM device disconnect

Roberto Sassu (1):
      ima: free duplicate measurement memory

Sasha Levin (1):
      nfsd: Fix oops when parsing a 0 length export

Stratos Psomadakis (1):
      sym53c8xx: Fix NULL pointer dereference in slave_destroy

Takashi Iwai (1):
      ALSA: hda - Return the error from get_wcaps_type() for invalid NIDs

Xi Wang (1):
      ext4: fix undefined behavior in ext4_fill_flex_info()


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPIIN6AAoJEDjbvchgkmk+NuQQAKibWkLWexJ69e5/CCpOfI2t
NY3IzwdBeL9pmhtmkKWKO+sHOm1x7LBek+PNHD4yW7DDKl8Yv5yk11uZFprud3pR
miOJpw92Ep+BKqocpaowylKuTsqP7nwImNqOLfuh4jlY2mpt6vze+oBIKBgKyOSj
AWIyP/Ncbr9o8uWRbFxe00KukmvO2NcIBw784WQfVk+/zCxvEo0QqW0MUa44cPRp
FS+TgbuzBCcTB01/RvhzoHTd0zgE6lECCslYZCKxQfEWvDv7MjMrE116LLI/VYPf
H0yu7atmVblx0Gp+C2CzkxZxHhN2udVYzNyW4wAc7xdVkkNnxX4kWBIfMyOTvg9/
kZaHXq7glvcYbmv83JIN1YIecsyLJbCKyhXNiwvk1XxDkdZHrP/ap5Eypg4LZSX9
t4q9vkA4MgM4wYi+ESQ9MEcRyLKUAqTxmMs93v5Fxx8FP+U+IOvCWRm7R1816XFr
yxKFRY6D804cNGz6EzVL9iWo+Bnu/OO9AQVRWPwBJ+T2K9pFisPlHN8R7aJ5cq/C
y89rtb70EXcCUCAA6vzFZk5bZ8FiOPCgg/GmyfPuoR3OijTBHKmP3tiq8pkARsd2
qr7nN9ZsIOhZ7LzhDxbHxoFTVoVQtsyVY9UyMPUYGTsKodL2SsOHLhuhvW/uts+n
2GYY+W9EpA0mJPXXUyet
=CBUg
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--

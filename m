Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2ALUPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:15:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57499 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab2ALUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:15:09 -0500
X-Sasl-enc: m6wE93DUfYD9rsgMMou/Z4Bh/wrkrz7BsHEW0CrnflO5 1326399308
Date: Thu, 12 Jan 2012 12:13:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.54
Message-ID: <20120112201320.GA15083@kroah.com>
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

I'm announcing the release of the 2.6.32.54 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Documentation/HOWTO                         |    4 -
 Documentation/development-process/5.Posting |    8 +--
 Documentation/usb/usbmon.txt                |   14 +++--
 MAINTAINERS                                 |    2=20
 Makefile                                    |    2=20
 drivers/base/firmware_class.c               |   14 ++---
 drivers/net/usb/asix.c                      |    6 +-
 drivers/scsi/device_handler/scsi_dh.c       |    7 ++
 drivers/usb/class/cdc-acm.c                 |    4 +
 drivers/usb/core/quirks.c                   |    5 +
 drivers/usb/misc/isight_firmware.c          |    6 +-
 drivers/usb/serial/cp210x.c                 |    1=20
 drivers/usb/serial/omninet.c                |    2=20
 drivers/usb/storage/usb.c                   |    1=20
 drivers/video/offb.c                        |   52 +++++++++----------
 fs/reiserfs/super.c                         |   27 ++++++----
 fs/xfs/linux-2.6/xfs_acl.c                  |    4 +
 kernel/cpu.c                                |   74 +++++++++++++++++++++++=
+++++
 18 files changed, 167 insertions(+), 66 deletions(-)

Alan Stern (1):
      USB: update documentation for usbmon

Aurelien Jacobs (2):
      asix: new device id
      asix: fix infinite loop in rx_fixup()

Benjamin Herrenschmidt (2):
      offb: Fix setting of the pseudo-palette for >8bpp
      offb: Fix bug in calculating requested vram size

Christoph Hellwig (1):
      xfs: validate acl count

Greg Kroah-Hartman (2):
      USB: isight: fix kernel bug when loading firmware
      Linux 2.6.32.54

Huajun Li (1):
      usb: usb-storage doesn't support dynamic id currently, the patch disa=
bles the feature to fix an oops

Jan Kara (1):
      reiserfs: Fix quota mount option parsing

Jeff Mahoney (1):
      reiserfs: Force inode evictions before umount to avoid crash

Joe Perches (2):
      MAINTAINERS: stable: Update address
      Documentation: Update stable address

Johan Hovold (1):
      USB: omninet: fix write_room

Julia Lawall (1):
      drivers/usb/class/cdc-acm.c: clear dangling pointer

Malte Schr=F6der (1):
      USB: Add USB-ID for Multiplex RC serial adapter to cp210x.c

Moger, Babu (1):
      SCSI: scsi_dh: check queuedata pointer before proceeding further

Neil Horman (1):
      firmware: Fix an oops on reading fw_priv->fw in sysfs loading file

Oliver Neukum (1):
      USB: add quirk for another camera

Srivatsa S. Bhat (1):
      PM / Sleep: Fix race between CPU hotplug and freezer

Xi Wang (1):
      xfs: fix acl count validation in xfs_acl_from_disk()


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPDz7gAAoJEDjbvchgkmk+PAQQAL6GEDPIwAxUooULVRrtAufj
XjR9Acr59ZU5aqBBlltf2wuD3WGq6ZYfK72tq2345A7a8AqOF0lyzfe5wR3ekIN2
GsDlW3CADd6UYNsaW2u3Ah/F58EQOPf9c5IipgFia2+tQLMRbnQse2CStSwK6Byg
UzE7cFTwR6BFH6XUJisTbmZaMj4hOzAhdNYS7SrA+Q4ySwgjw18MNhQ/oQY2eh4S
YyPcUBz6udsm3Bm97PO7m4qsanNex3QJvzk93Pa772GoeCiYFOY0sI7KMeSnCvw1
guGryuSDtQLH6Nf0Fz9Efj7XXJgMt4blt6u5uI4Agckzr5z9VHH8AFlNq18McwU/
FHgFFLKP81wu0o/jUsbP0w+MqjOC/EPYXDje3zxz0FYE5/C9FZL6Zabf65/ILkJ9
wFydPdSLNTqy0zzyRpA+aiygXikgorgG0s8oZRyRDoc+3XMrrs8YBALyNyTjjdgy
2LY6Wiecr1RLhPmTJ+AqNgcAXOzlTH2pPSHK9EVWY3vNb6Kpu6uKhIiVaToEKYZk
yJLaTjQfg6rnLuH3XQNYW+qbNHeRuV8pNVZ4F+t28fP3oBwsySJCm/wRvz6Yinnt
LsYhho7QcZVH8cPvywW0LeaTnpN4Eo+cvkq6KmadvGitxUSzfUX2E0JcfRWZKD8j
xGr0vdqgb5WOuO4r1LY3
=vkT5
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

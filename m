Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2BCRtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:49:25 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37353 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414Ab2BCRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:49:17 -0500
X-Sasl-enc: ys8GTvzoH8XLgH7TEfqZCW/yCt3JN7kpJ6gyKFx49mZJ 1328291355
Date: Fri, 3 Feb 2012 09:48:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.56
Message-ID: <20120203174843.GA18600@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.56 kernel.

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

 Makefile                          |    2 -
 block/scsi_ioctl.c                |   45 +++++++++++++++++++++++++++
 crypto/sha512_generic.c           |   62 ++++++++++++++++++++-------------=
-----
 drivers/gpu/drm/drm_auth.c        |    6 +++
 drivers/gpu/drm/drm_fops.c        |    5 +++
 drivers/hwmon/f71805f.c           |   10 +++---
 drivers/hwmon/sht15.c             |    3 +
 drivers/md/dm-linear.c            |   12 ++++++-
 drivers/md/dm-mpath.c             |    6 +++
 drivers/mmc/host/mmci.c           |    6 ---
 drivers/scsi/sd.c                 |   11 +++++-
 drivers/usb/class/cdc-wdm.c       |    2 +
 drivers/usb/misc/usbsevseg.c      |    2 -
 drivers/usb/serial/cp210x.c       |    5 +--
 drivers/usb/serial/ftdi_sio.c     |   14 ++++++--
 drivers/usb/serial/ftdi_sio_ids.h |   19 +++++++++++
 drivers/usb/serial/io_ti.c        |   10 +-----
 fs/ecryptfs/crypto.c              |    9 +++--
 fs/ecryptfs/miscdev.c             |   56 +++++++++++++++++++++++-----------
 fs/ecryptfs/read_write.c          |   19 ++++++++---
 include/drm/drmP.h                |    1=20
 include/linux/blkdev.h            |    1=20
 22 files changed, 221 insertions(+), 85 deletions(-)

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPLB37AAoJEDjbvchgkmk+32oP/0jGnUtl+i43A1JKF1+YWaHZ
pvJZQE4+CGvDXpjtsgb7duHINvRpxrGdl3LES/CazqBCnOmuBpCzAERNuwdMS74R
eYx5uRQZLycqp3tlKpK3alYY1ij/z2y3U6YO0QibcQK3wV+r5pM9Kr31Q1R6pXEL
+m/hC4pp9KLB7Cftl7ynUHyO4R6ObF4AmESMRREXWU6eo1D3ecKMAjSGeX1LxYX4
6mu+Hhcg/eKonR+82Cs2f+MA/fNHTAyFnYBp7JyHtWpNBUOFDLd97B9Yussg+rUa
vn6ksRbfHIoXIUHBAaTXsuwhFbowd8szCYk9PkCm0dUYnEeQI7/NZgKdAqRa1g4f
rg5WxyVwyhzANUFoNlT4f5DXlyx4U7+9ZRJFH3wA/aeVJMdOAEnEQqbbP2k1Sbxi
Xi18nJb151E5ZFjEr8rMXYY2o4ox12y2oOpDP0JtjFvuC+DkAXlrQ7J4r17ET+Uk
qTfq5A1ArEkSuQgtJYy2z1wMm/WgezZuKQSoowbYw+DvyCYF9mnSOaivFXOtbQI7
aqaZGQWaURnOx4L1XlfiyyaHQ0nYae7ub4zJ7Bb+eGoix+n99BzRUpt/sA4qYWUW
yNKyLgB+uBlw9BnGMnpKD4yKU8gvE3emMNv5uU+swOj8Emqcowbl7HCqcb4/OPVO
TB/ionRYL2v2GBUjs7nb
=y5xb
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

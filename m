Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1JCTzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:55:10 -0400
Received: from imr4.ericy.com ([198.24.6.9]:46809 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab1JCTzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:55:05 -0400
Date: Mon, 3 Oct 2011 12:53:30 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.1
Message-ID: <20111003195330.GB30684@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1 from:

    git://github.com/groeck/linux.git hwmon-for-linus

Thanks,
Guenter

------
[this time with cc:]

The following changes since commit a102a9ece5489e1718cd7543aa079082450ac3a2:

  Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)

are available in the git repository at:
  git://github.com/groeck/linux.git hwmon-for-linus

Guenter Roeck (1):
      hwmon: (coretemp) Avoid leaving around dangling pointer

Jean Delvare (1):
      hwmon: (coretemp) Fixup platform device ID change

 drivers/hwmon/coretemp.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOihK6AAoJEMsfJm/On5mBPqwP/35jSg47fgOhHHztHC0FJWhP
vEDlkRzqIlWCNB1wUw7DoXQmJlCdyAaV7+z6Tt2XqRlpu+/29AQ+RKG/jinYBNUQ
0ax5swrjZpgyDj4JpyYCZAZNSIAmH3n7UQrobn76zgUiBeuM5VFrM6hI+V+obVIH
8RGmh8aX+YyaYaXNgfZHl1S6vDpEZyoGjDHI3Lrj19Qw+Q9eLxBJX68/qFssuNHX
HEVFQLAkVlYBP8XHFLm7193bjzOamRgJOEIZnWH+RLd1a5fcSNakXZmgyzJ4BcgN
Y/+LlONJ6gG/PagYzC3Id5hlZndVCslAzuJ+AuleFFOtdVOQR2ZLSpsNtmOrNd2Q
Y089Lj5dqUWnEWpbsNmE01xdeZ0tMwM7a1G8GNgBWC2477fx6Yt6OCLQy7k7B4Ze
3dxaEDUWgmBGxVLsqWmG8ZWJtId/U/VZAaOoXrTe7OTa96bhx6jL3lkNd6e8FZBx
j9Jtu2RSFcrQbSyy6CsTYsriPBHheU/bQYH1MPDbK3mVDPhBIauEpXB4dPZERUUP
y+UymOaghzD7APSxya0FVUINQ23shvw+UW7+9pLKEn1vjVBfj1o3y3rYTYuq3VgL
zrfsp0NClMq3jsluCoszWOJXntxdiak0NKnB9c53yU7VS+WMZYwG9yiC2A2aTD+q
sg0nlhaj/6glHKLVQbQZ
=yiCw
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2H0RwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:52:01 -0400
Received: from nn7.de ([85.214.94.156]:45368 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab2H0RwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:52:00 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 13:51:59 EDT
Message-ID: <1346089515.26382.52.camel@no>
Subject: b43 regression: extremely slow wireless with BCM4322 802.11a/b/g/n
From: Soeren Sonnenburg <sonne@debian.org>
To: linux-kernel@vger.kernel.org
Date: Mon, 27 Aug 2012 19:45:15 +0200
Organization: 
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-bw6H2+7Ry3aMZVxNg0lE"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bw6H2+7Ry3aMZVxNg0lE
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

since kernel version >=3D 3.4 wireless became extremely slow (download
rates of about 90k/sec when downloading a new kernel from kernel.org
instead of >1MB/s)https://bbs.archlinux.org/viewtopic.php?pid=3D1146085

There is a thread on archlinux
https://bbs.archlinux.org/viewtopic.php?pid=3D1146085 where people observe
the very same. Kernel 3.3.X was the last known good one.

*Sometimes* download rates are OK but most of the time they are not.

$lspci | grep Broad

04:00.0 Network controller: Broadcom Corporation BCM4322 802.11a/b/g/n Wire=
less LAN Controller (rev 01)


Any ideas?

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-bw6H2+7Ry3aMZVxNg0lE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJQO7IrAAoJEH82z1Wqh6p3hrMP/1WqSKDGOVZ0vdoblHX3jfHF
5SVzC1cSnBj9VjHrpR56Znc0d0e0Mv6sGu+8+c83QqzvgnuAruqhi4UiQQzK4JSH
w/Nx+S9YgHwwosKRykaI7J/YZX/dIx6aF4tv40l7mu28OY5/pja6DHlbXOMfAI4l
9TNSi49aCU7MLmEVmpe52BXB/1vAOx7Oza6QJ3PTots5XfwhqWAAyCrOvFwoF922
Axv53UfWhkePh3diBNgNgd2/U4ZGqEVdAiv5o+OUuQtEClZ/W/L7ZJ6fQ4Spgu5z
PNgGWH1P4tBWMTdT9BbTup3HN9709KF8PHU45XaHjh3uj+ndlBAv5fw51g9xpeWN
0tIG2KGjF5+fuWeazpgb8BBrhQkKWv7tHrWkJkqv5jfHmYdIZPFaZaYNiManGSr2
rs63fLKHkKJ4wzVM5ceCUhll1avXgv1SB781/kuNxQY4Bb4d2K4uA2XMtn8B9Oju
h5mBmibgzWMC9sCNJfTyUpn/i/bLOirHQTjhxbcO/4Ip+9tRQroWjfK2CPsuP+a5
qAj6eRHwsJqZ+gdtsNw865BcQXGyG/6OhWcWlh1cDrkZJ9FLVAZ/QuMXcBplDQH3
y+RkloFngTUHx/fvOOXut/XUA7o4zuSEEl4HAUqoTtntWUV1bdSV2tKIY43UdAw2
6rYiE7w1fjQpPq5XRMzm
=knuy
-----END PGP SIGNATURE-----

--=-bw6H2+7Ry3aMZVxNg0lE--

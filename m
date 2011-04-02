Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1DBPUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 11:20:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab1DBPUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 11:20:14 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-media@vger.kernel.org, Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com
In-Reply-To: <20110402093856.GA17015@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
	 <20110327152810.GA32106@elie>  <20110402093856.GA17015@elie>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-9i/AS1nb8S9mURR4iR84"
Date: Sat, 02 Apr 2011 16:19:59 +0100
Message-ID: <1301757599.10056.186.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [RFC/PATCH 0/3] locking fixes for cx88
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9i/AS1nb8S9mURR4iR84
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-04-02 at 04:38 -0500, Jonathan Nieder wrote:
> Hi,
>=20
> Huber Andreas wrote[1]:
>=20
> > Processes that try to open a cx88-blackbird driven MPEG device will han=
g up.
>=20
> Here's a possible fix based on a patch by Ben Hutchings and
> corrections from Andi Huber.  Warning: probably full of mistakes (my
> fault) since I'm not familiar with any of this stuff.  Untested.
> Review and testing would be welcome.

Since you have split up and otherwise modified the patch I sent, please
remove the 'From' and 'Signed-off-by' lines with my name and address.
Just state that the patches are based on my work.

Ben.

> Ben Hutchings (2):
>   [media] cx88: fix locking of sub-driver operations
>   [media] cx88: use a mutex to protect cx8802_devlist
>=20
> Jonathan Nieder (1):
>   [media] cx88: protect per-device driver list with device lock
>=20
>  drivers/media/video/cx88/cx88-blackbird.c |    3 +-
>  drivers/media/video/cx88/cx88-dvb.c       |    2 +
>  drivers/media/video/cx88/cx88-mpeg.c      |   35 +++++++++++++++++++----=
-----
>  drivers/media/video/cx88/cx88.h           |   10 +++++++-
>  4 files changed, 37 insertions(+), 13 deletions(-)
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-9i/AS1nb8S9mURR4iR84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATZc+lee/yOyVhhEJAQrddBAAvf/5rIKUVP9XG9ZdwBrKdLczTaZm8yJm
3BHMcpXlz1P7fFZUvf6Q8Y+eLxz/OxtEL/wjyZVwatOAuGvoM+idTi0BVJKz2pSN
kVcGLZDT428By5yZYSU4dhg1WxShoJdC1iG8WRO8Do8n9vcW2XoiT14a4i78DWIP
TiZKC/qcDgfMuXEGy9LGM1HNPDy7FrGTrC8yxpMm37KTySSp5HEdrlRnumUDQyuE
izB8A+wB789oJdg8b6Drd3GPgPi8BCQee6kU3D29f0Qf4W8StTs2gODzdIQH7aRc
Ckda6I2yTsHyP+BS8seasT6SLgm4opehqClz33nz4Iv2pbTw8ydbMhg1pEwuYEUS
YwCzdJz/DJdj5Flk6/dhNCDGy0ghVPJNudwzKAnXxEDaveDbFOLwnOPc3H+b/4ak
fH96iGItICkbNyHp+IDOZ6G270W6n/f2o/mnR7szQrJJZsv3pPI0nZqDGPniuWPv
QbYCUnOTP/x6vxxGDCNW5zVZA/nFP3+GeUfJgCf5sBjESj4EJD7cqCSWLjmR28jc
Rntp7L4vrV3kngYd5WtfoUSJg+YiS6rWmqnN+v2wanGbyGpffLT2x7J7eTpn3USX
1h5oaT/nlILCX4EznnlE80I1vtat3VPZZbnrxj2wn1l3fygGYayxAKc03FQEOtBo
xRb7JuOGwbY=
=uugJ
-----END PGP SIGNATURE-----

--=-9i/AS1nb8S9mURR4iR84--

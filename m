Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1LDONd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 09:13:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1LDONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 09:13:30 -0500
Subject: Re: [PATCH] mtd: convert drivers/mtd/* to use
 module_platform_driver()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Olof Johansson <olof@lixom.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Vimal Singh <vimal.newwork@gmail.com>,
        Andres Salomon <dilinger@queued.net>, Sukumar Ghorai <s-ghorai@ti.com>,
        linux-mtd@lists.infradead.org
Date: Sun, 04 Dec 2011 16:14:27 +0200
In-Reply-To: <CAOLZvyHmW7joMRbj7OPzmgWVdLr2U0p1P17FdroVmS6skecpAg@mail.gmail.com>
References: <1322397903.2799.5.camel@phoenix>
	 <1322727444.2332.12.camel@koala>
	 <CAOLZvyHmW7joMRbj7OPzmgWVdLr2U0p1P17FdroVmS6skecpAg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KnGhNHB4AIcYJbqAvyXr"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1323008077.9400.58.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KnGhNHB4AIcYJbqAvyXr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-12-01 at 09:21 +0100, Manuel Lauss wrote:
> On Thu, Dec 1, 2011 at 9:17 AM, Artem Bityutskiy <dedekind1@gmail.com> wr=
ote:
> > On Sun, 2011-11-27 at 20:45 +0800, Axel Lin wrote:
> >> This patch converts the drivers in drivers/mtd/* to use the
> >> module_platform_driver() macro which makes the code smaller and a bit
> >> simpler.
> >
> > Pushed to l2-mtd-2.6.git, thanks. However, I got rejects in the
> > drivers/mtd/nand/au1550nd.c file, so this part was ignored. Please, tak=
e
> > a look at this and send an incremental change. Thanks!
>=20
> Axel's patch is against a bigger change to au1550nd.c (which introduced t=
he
> platform driver in the first place) available in linux-next.

Then au1550nd.c bits should go in via the MIPS tree as well.

--=20
Best Regards,
Artem Bityutskiy

--=-KnGhNHB4AIcYJbqAvyXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO24BDAAoJECmIfjd9wqK0lT8P/3Q+/McGZOQYgXP6IO2uKQ9K
rTaXE+XaV7rExRoYsLc01je1ys/5blMOA00o7Cofy5VzIIzjEneCdY1m70nU94fr
zpaoCaoaNr5JvvE841HHRb0raIqCfdxofr4XJujNUmIqw+2RGh4tLcECqiYQQ3aH
EjMY/6l9qvVMxR6zV6vhTDsChkbv/va5Sp7IP+OXUrnrGQG96k/qBoBmD1RG5N0n
5Vyo5LFT0qka2gs97mMUAPJkNdZhkXxgDvC/tjUwFryOrL7s5xY42AtVu6upifZM
gmdzI2u1N+TImaUtbxG4fd6MQrrvl3KXLFedvRBLctO59cjZpIyZkeF9gEzIZQKg
R2abkcVrJKU3jKAKooc2ofz7g2fDCO/NxEccJVjGcmNABCG/Kbarb2tx1RB9w8jW
eaYJQs3G4C0fMYHG3rI6vyxKB1bIQ3P4D6tLDpjFPrRYXChnpQZZzhdyXtWXvLJh
xJC1mLGSbilf14b4FK3bi5WGx//REALgAej5nsjaRqtG8Ml1Nkhl3Z8yz79NZNXc
UbddWCw2p5oTV2A91SPdjyWVFUf4i4DJbmPfy9kiGhfDsF2pjTKvqf3l2+jcErYG
LHHb+wZ05b60peQV3YpObRXA8kxUkJd1qwrEfQGo1eUiOT1BvaCC0J8YeG+4qOGM
1sbL89inflm2XvNMD1fM
=u2f9
-----END PGP SIGNATURE-----

--=-KnGhNHB4AIcYJbqAvyXr--


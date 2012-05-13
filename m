Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2EMO0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:26:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35868 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2EMO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:26:21 -0400
Message-ID: <1336919166.2003.7.camel@koala>
Subject: Re: [RFC] UBI: Kill data type hint
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Date: Sun, 13 May 2012 17:26:06 +0300
In-Reply-To: <1336738443-112022-1-git-send-email-richard@nod.at>
References: <1336738443-112022-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-v4FzvXW7Ce+oMmlD/Bu/"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v4FzvXW7Ce+oMmlD/Bu/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-11 at 14:14 +0200, Richard Weinberger wrote:
> Artem,
>=20
> Do you want this change as singe patch or shall I split it up?
> For now I made it as single patch to avoid build errors while
> bisecting.

Hi Richard,

I'd like to merge it to 3.5, so making it easier to review would be
great. Could you please do split it at least on 2 patches, may be even
thee:

1. Remove the function arguments dtype also in comments to these
functions. This should be the largest patch, but should be no-brainer.

2. Remove the logic from wl.c. Amend comments there as well.

3. Grep everything in UBI and UBIFS for patterns like
"term/short/unknown" and amend the commentaries. There should be handful
of them, AFAIR.

Thanks!


--=20
Best Regards,
Artem Bityutskiy

--=-v4FzvXW7Ce+oMmlD/Bu/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPr8R+AAoJECmIfjd9wqK0yPcQAIgrgHYoIBn/vFuaRxP7UjdS
SEujnfy1TgWLFb87/WLKc+BDsb64sVg5vwkeWn98esMxs4VF0aPh3b22BaqjANuz
Dr+YK6P8gStDGymOCCL3nZBAObXavGu15ZzxbKoig9tBdExay1dyffpQ/Sgacq/T
imqLWDjTgb+o+HteYXvDO8CLnZbPLyCJAIxDDLWrjipjgFsfJbORCw83O0FfODEe
NNpdDsOiVVRspg09GRsHQ9cWvbmYcmzNq+geNQVKCz6HfVEHU0Qk4dMDEgbs2sqv
gl7+ottJKo7ecCtdlKFW6mZLL27ANY5lN6H8FUya+gFwZ0OTyE3h01lrLsAGCHmt
C8TnA8GYU0jpn1y0mxuWWJVivAzrLSZQDZIFZppnZQcELL/KljGgqUDT7eiWfql+
en8qebaVcHNsskWKnmDVSSpBoiroQHSDvwt25Pw8ycyT0jfascgv0IUAtrZxlEH/
BiEvrU1OR6Ba5P78KVJqIOIj78QQyXVnhiYgb2mLIY4x/PO5pZie6VQZgcbj+KDH
GN3swiY8iVgcfFL+mbVCqKlA6LZDBnjZWSFoB37EMBS4EBPSC9u9lR2mtQgzQT+S
SGM0CGNrt1AtfioSIpQD9Oci35f9c7fb0vP3bImiQSBoajSKMc2ud0DAfpBmUsbB
hsX35jH/nrvdcXlDdPVT
=1z+Q
-----END PGP SIGNATURE-----

--=-v4FzvXW7Ce+oMmlD/Bu/--


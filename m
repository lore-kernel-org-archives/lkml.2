Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0EPBIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 21:08:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37558 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab0EPBIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 21:08:44 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269401628.18314.264.camel@localhost>
References: <1269401628.18314.264.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4mT+vHRxRlqa6dcOu40c"
Date: Sun, 16 May 2010 02:08:34 +0100
Message-ID: <1273972114.2564.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4mT+vHRxRlqa6dcOu40c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-03-24 at 03:33 +0000, Ben Hutchings wrote:
> SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
> amd64-agp is apparently preferable since it has workarounds for some
> BIOS misconfigurations that sis-agp doesn't handle.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

You seemed to be convinced that this was OK
<http://thread.gmane.org/gmane.linux.kernel/965466/focus=3D966555>; can
you please apply or nak it?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-4mT+vHRxRlqa6dcOu40c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS+9Fjee/yOyVhhEJAQJFuhAAhG36xYOB59b1ouFfnehCOdIdyUcAP5xY
he3Dss0ZGBzsdY/+gvddYefN+/SkSut/xxnHGR722RwGXnl/ZRU4N2e4qnaGV/qs
77aGv66ev441hXpcX5CHnBRxIW7/2DCGLfy0hjF/EiYgClM6zjrLOPlKwADOf8H1
0Fy1i7RdqzeAdNvXxO4/8gyBgc2QDtY8tVSVN/7uXyceSzfmKM007ARSXPXiltgq
qMKHR54qtExVUcbxw6uZnzPJW04us6FHRZqF1o0ShwhuGi6jdNMYOil9efR2OE+F
5y5sYo5NsNQoDezgk+RIucaX+po3hZT+qM5L2VmknnBG9KH/8jNUOoJWpHXLVN8b
wWG54kBGDpdalvs6XQ5kRXcMprt3HomwJcg9/EFhTBzmpS5l2rYdBcJscbkNqdc7
FyeRZG/3PG4KY1jMB+lz0D+0wVPsoNokWSbBTD08rXHfjrmFN25nOTAT7/cbGcdY
s7rbBMa9J8Qn5ofqg7706NPT5qEn+9rsu4JOfHXha6y3uXBq0dJjkYc26pxW7HQy
r2KZx9n0RaDCnP4wwhs7Eu6F1+lN4JYJP6Tg/Cp5qLWaSWN4Gof/DGLSuzQIz3Ta
LIQy40NwR8IuZGh3Xd1EsXudyh6yaoC47X6nIFDUvFasP8M1xqTbIQnwLnUhrlW4
TP0ERPF9oHw=
=Hv1q
-----END PGP SIGNATURE-----

--=-4mT+vHRxRlqa6dcOu40c--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab0FPAqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:46:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33667 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758219Ab0FPAql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:46:41 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andy Whitcroft <apw@canonical.com>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100615083623.2dbaab24.rdunlap@xenotime.net>
References: <1276513297-23306-1-git-send-email-apw@canonical.com>
	 <1276514142.14011.329.camel@localhost>
	 <1276563314.14011.361.camel@localhost>
	 <20100615083623.2dbaab24.rdunlap@xenotime.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YOOsbQwINSpHeaZUIzkl"
Date: Wed, 16 Jun 2010 01:46:33 +0100
Message-ID: <1276649193.14011.574.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] docbook: need xmldoclinks for all doc types
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YOOsbQwINSpHeaZUIzkl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-06-15 at 08:36 -0700, Randy Dunlap wrote:
> On Tue, 15 Jun 2010 01:55:14 +0100 Ben Hutchings wrote:
>=20
> > Andy Whitcroft wrote:
> > > We need the xmldoclinks built for any document types built from the
> > > XML sources.
> >=20
> > Indeed we do.  So make the XML files depend on xmldoclinks.
>=20
> The patch description tells me what but not why.

The quoted text from Andy says why.

> IOW, what error is this fixing and how do I produce that error
> when this patch is not applied?

$ rm -rf build
$ mkdir build
$ cp .config build
$ make O=3Dbuild htmldocs
...
xmlto: /home/ben/src/linux-2.6/build/Documentation/DocBook/media.xml
does not validate (status 3)
xmlto: Fix document syntax or use --skip-validation option
/home/ben/src/linux-2.6/build/Documentation/DocBook/media.xml:4:
warning: failed to load external entity
"/home/ben/src/linux-2.6/build/Documentation/DocBook/media-entities.tmpl"
...

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-YOOsbQwINSpHeaZUIzkl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATBge1ee/yOyVhhEJAQIYrg//dXBw2lyfK9oLerK0sfZwfnZjyLj3/lUL
J1OUSwRYJGRQLIu9odB+zzPSzDeHj4K5pYwoFOtuqq10vc+B0I8im1kMlzAzx4kk
B4n+rrE8DecV+GDegFmInsReAaWE12aRb7YOXtEXH+5pe2seSLgQRHLVLThid0oW
A349SlyzUpU6DnDYQDR9G81LgSn5uq2OGipSBcRTmc2LlFmbn9x488V2UnT2If17
jrJ/bEArnpzZoe1oBmIkSSZ+AGkq1Yzf2ODtlvmW4oeKGS+EEWl9EymoPExmsYZV
Wtjed9r/siUqHTfP/qY+aZYGiDTp+9mpzq5h8B+IOE9lxWOt3PHkXMUHFIxmjzq2
2wlU2XGjOFsxFy0ThuIvveJLBWELjiDv7hLArggArueHZnsAlWCW4azKD68JMiTN
p4VGrunDP5IRwytTzSXZWTlcoqBVh5EdP8XdUuT1w5pUUSaIbblB5fLbUMXam+y4
FNV7LCR1p/61rnfW9u4Ix3Eb4QZmoCBaLAJORILy1rDjot2289aQkRzF/XXfpFe3
LYaJ+b2K7emEUtK+ZT0gNjKpBKJXnOUOHufrOciqaVSW1w1cV1dPnXqqUMc9FhOe
KVn4cJa+D9IpWXpqujOrIsxAUfwghNUt2cd7xAWnmgsh05nX4lEeq8wI87Ih64L5
pR3GSrhICKE=
=N/ri
-----END PGP SIGNATURE-----

--=-YOOsbQwINSpHeaZUIzkl--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2AOTXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 14:23:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55302 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2AOTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 14:23:21 -0500
Subject: Re: [PULL REQUEST] More UBI/UBIFS changes for 3.3
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "Bityutskiy, Artem" <artem.bityutskiy@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 15 Jan 2012 21:22:33 +0200
In-Reply-To: <CAJL_dMsugowERsv8qHuaWZB3yEstqrB3d+So-ive-EGRoi4OMg@mail.gmail.com>
References: <1326456812.18165.0.camel@sauron.fi.intel.com>
	 <20120114184854.GA23282@redhat.com>
	 <CAJL_dMsugowERsv8qHuaWZB3yEstqrB3d+So-ive-EGRoi4OMg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jU3/XlRxHUUplRei4wb8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1326655399.2201.2.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jU3/XlRxHUUplRei4wb8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-01-15 at 11:19 +0200, Anca Emanuel wrote:
> On Sat, Jan 14, 2012 at 8:48 PM, Dave Jones <davej@redhat.com> wrote:
>=20
> > This introduced a compile failure if CONFIG_UBIFS_FS_DEBUG is unset.
> >
> > fs/ubifs/journal.c: In function =E2=80=98ubifs_jnl_write_data=E2=80=99:
> > fs/ubifs/journal.c:700:2: error: implicit declaration of function =E2=
=80=98dbg_jnlk=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>=20
> And now it is in Linus tree.

Sorry for this, I've sent today another pull request with a fix. I was
not careful enough to test UBIFS when debugging is disabled.

--=20
Best Regards,
Artem Bityutskiy

--=-jU3/XlRxHUUplRei4wb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPEyd5AAoJEJtuLFy+q7fenBcIALtpOIuOUfwM49fsUSFm0XtN
ukoOtJWYHU26DlNlhZ/OU9di+K9SYXu9qhuPC1XLnQ60JIEUIC3mprv2EfrQQakw
b/Yyhi5mscdjonMeHLTomCsZkgOWEyLI/1FNm9I9ANWl8OSdQQWqFJeyQ1ztYb8p
bdM1+OXnYXoEYM/tOJhXCa1xWi67JIgoAFaxRSH0YPu4+pLDuEJ3/boJeY5P9eMq
KbpFiue85Qw+43kUmr8TxA66FFbOT3ZIro6cmoTZBV2dmcgBAFf1YaH9zb1Ilu8z
XpQcKBWkPr/p9p9aUK2HUFYza+ubjeAQb0gYUcJ5YgDkJWSWLS3Mn20g9fOCqS4=
=LWMH
-----END PGP SIGNATURE-----

--=-jU3/XlRxHUUplRei4wb8--


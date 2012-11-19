Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2KSSno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:43:44 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:32985 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab2KSSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:43:20 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] bq27x00_battery: Do not report nominal available capaciy if battery is not calibrated
Date: Mon, 19 Nov 2012 19:43:16 +0100
Message-ID: <12085398.q92JCopB21@pali>
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121119000552.GE29066@lizard.sbx05977.paloaca.wayport.net>
References: <1352558568-30607-1-git-send-email-pali.rohar@gmail.com> <20121119000552.GE29066@lizard.sbx05977.paloaca.wayport.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2703209.h1FJU5MVlh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2703209.h1FJU5MVlh
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 18 November 2012 16:05:52 Anton Vorontsov wrote:
> On Sat, Nov 10, 2012 at 03:42:48PM +0100, Pali Roh=C3=A1r wrote:
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  drivers/power/bq27x00_battery.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
>=20
> OK, I'm assuming we don't want this because otherwise we're
> getting bogus values in the sysfs, and so we confuse userland.
> I added this explanation to the commit message, but still
> would be great to hear some confirmation.
>=20
> Anyways, this is applied now.
>=20
> Thanks!
>=20

Right.

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--nextPart2703209.h1FJU5MVlh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCqfcQACgkQi/DJPQPkQ1I8kwCgjEHJQbeh6yvPXM4TkQNwJ8Pn
8UEAnAqjQDTI4Uql0VWsEo/1IqU8/Y6E
=nKvW
-----END PGP SIGNATURE-----

--nextPart2703209.h1FJU5MVlh--


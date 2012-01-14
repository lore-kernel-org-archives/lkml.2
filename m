Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2ANPgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 10:36:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46671 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2ANPgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 10:36:54 -0500
Message-ID: <1326555513.14299.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: Use UBI_LAYOUT_VOLUME_{TYPE, ALIGN}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Jan 2012 17:38:33 +0200
In-Reply-To: <4F11A06A.3040703@nod.at>
References: <1326214623-15938-1-git-send-email-richard@nod.at>
	 <1326553866.14299.0.camel@sauron.fi.intel.com> <4F11A06A.3040703@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tQ3Bw2JuPA3Veu3HuBnw"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tQ3Bw2JuPA3Veu3HuBnw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-01-14 at 16:34 +0100, Richard Weinberger wrote:
> Am 14.01.2012 16:11, schrieb Artem Bityutskiy:
> > On Tue, 2012-01-10 at 17:57 +0100, Richard Weinberger wrote:
> >> UBI_LAYOUT_VOLUME_TYPE and UBI_LAYOUT_VOLUME_ALIGN are currently
> >> defined but not used.
> >> Use them at least once. 8-)
> >>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> >=20
> > Hi Richard,
> >=20
> > This will break backward compatibility - older and current kernels whic=
h
> > do not have this patch will error out when the find a volume without a
> > name. The right way to do this would be to change the UBI format
> > version, but you would need a really strong reason for this.
> >=20
>=20
> Sorry, this comment makes absolutely no sense.
>=20
> Did you mean my other patch?
> But still, the other patch also does *not* allow volumes without names.

Yes, sorry, ignore this one - I've pushed your patch.

(Embarrassed)

--=20
Best Regards,
Artem Bityutskiy

--=-tQ3Bw2JuPA3Veu3HuBnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEaF5AAoJECmIfjd9wqK0RDIQALcT+QDV7l30nvxambxixukZ
iuaJIxnyvDOWOtmaOIms8/rlu8C9t//2F5PRzz0Mwc1wOj9RHdwy9ZeJEB6iGMDH
XpWBNULwzb5DY6RvIo6Iv5IdleDEaz3ZR7JfPO2hbUuGW3+QEJusic12nDfJvC0A
0FclZyES4QZzUuRg/DqDAIZDm1GEHC0zRuSVpsqZQNMrap17bAT5EDYMPVrsLIAO
QIP5jj5e//DNzFxi6ckaL02xqMYfq/FMuoVvDKQkLNe3YQSU6WwMoEGCVYP5kj4W
RGAomlT+zKFMnK5QFr3V4G3p9PAZX0pGqfiNUphoL52RHQMKluRDbFMaQwZiWKA+
ZUDDeVwHD085YEN7WbIZw+OhOcN1LAopVc0xbbZf2HCuvIVLYE6MmK3GNITNcmdf
0NAHPCkodRECODfKOKzFC9QU1pDRz462dbAki5uKQJQ+lHz4XDgemEp1uOK7KwHV
JxYgTvzvOk0QQeIF0UaBIZNHQfV6Zpv3zrNJk/gQLoLRePBiRZeHV4/GjhJ9Sdyj
HOrfxl8ATgpLJkolJAIqNjzFEwDFfFYaWUeimYXlgExehGWe4emfB/GyQ0zCry0K
knA5VZygX7iryT843826tdjrmyXchokxJ2OokQj8uZ/GjweFhCEYgTWeETvx7ca0
hxUSpMHyUL37XmkGU4YY
=iQry
-----END PGP SIGNATURE-----

--=-tQ3Bw2JuPA3Veu3HuBnw--


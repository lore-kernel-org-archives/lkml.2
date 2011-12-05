Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1LEOhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:37:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab1LEOhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:37:21 -0500
Message-ID: <1323095835.5207.7.camel@atropine>
Subject: Re: i915: eDP regression
From: Adam Jackson <ajax@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Dec 2011 09:37:15 -0500
In-Reply-To: <20111203173508.GA15806@shutemov.name>
References: <20111203173508.GA15806@shutemov.name>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-O69coj3xo+syyOeUf+DQ"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O69coj3xo+syyOeUf+DQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-12-03 at 19:35 +0200, Kirill A. Shutemov wrote:
> Hi,
>=20
> Commit dc22ee6 introduces regression on my laptop HP EliteBook 8440p.  I =
see
> nothing on the panel after mode setting. Reverting the commit fixes the i=
ssue.

Try this patch (might need rediffing):

http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg05889.html

- ajax

--=-O69coj3xo+syyOeUf+DQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7c1xwACgkQW4otUKDs0NMK1wCfVMLjT2izXySm8R+++NXPaexz
phcAn2Xc4Mr5FmFcZTjfHW5MrwqN1uvE
=ZInX
-----END PGP SIGNATURE-----

--=-O69coj3xo+syyOeUf+DQ--


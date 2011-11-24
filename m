Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1KXXr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:47:59 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55573 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1KXXr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:47:58 -0500
Date: Fri, 25 Nov 2011 10:47:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] iio: Fix build error in industrialio-core.c
Message-Id: <20111125104750.61231158a1a57a522a001e5d@canb.auug.org.au>
In-Reply-To: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
References: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__25_Nov_2011_10_47_50_+1100_Ub3r4Jn3IlMcu/.Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Nov_2011_10_47_50_+1100_Ub3r4Jn3IlMcu/.Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 12:13:59 +0200 Sasha Levin <levinsasha928@gmail.com> wr=
ote:
>
> The error was introduced in commit b4641336 ("iio: fix a leak due to
> improper use of anon_inode_getfd()").
>=20
> Looks like the code wasn't even compile tested. Instead of just fixing the
> error I changed the function a bit to make it nicer.
>=20
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-iio@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

I will add this to my fixes tree today (so linux-next will build).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Nov_2011_10_47_50_+1100_Ub3r4Jn3IlMcu/.Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOztemAAoJEECxmPOUX5FEL88QAIRA9CyVTDvIIAUR3SjiaD5L
W4gx3ML0oSZaAAMmXUMFCbW5GC9ny8z8qN12cHq+mxCg9O5RSjc9tQO5v3FE7cSY
W8vDjo1CEdLyLRFqQ4E2sgm7T1vsUGWeZU/uMwQzSZO/7fIkGJp32cR4oIiuDSe/
+XuatnYVI7j8890vF+4wNQIw2x4IEosYwl0paFbqibTfswtuKP9IcZK3Ek2L3+UK
guYDgO2P7REhD0QsbesU+RX19qmcwdxUKXe/F8DECltFc/fV9XnTjtykZkZmNHyp
UWYwMYqLC+jEu8KIRzzzJTVOkqJoQYhLbaC8bDGdjU8eTgT0xLLJZkTEuu2Y+zSh
zYp0ZcQebsk05OpxOOaGAM1ITSL+6o3poxYUTbJ+BGSBFbq0V6GR6AhAB5El1KWQ
XQGt+cm/uv0YTzXvchSW5gKlD0vFRm63GhYXIJQ2JVUphG2vvy7aTQH7WTuJvKbR
uBMby4FcCisovW9aKQsUK3gN/lPKnVJcWd+uwWoGtsvO1QZH0XSmjNs7ErcVO8kT
MMi3V2pHdJmk5GWmGnz+XwDdPplShD2cM7d68ngx9BS1MhsqJIAwk6+JA/XNOam9
jpMRPHqBLBAt3u4kVz1gSMJbpiSlymNNfMmFbmCVa/GBRdy+9QN8gcShLDQYq/oH
MQR1YJde+nod67xh18m+
=kqtf
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Nov_2011_10_47_50_+1100_Ub3r4Jn3IlMcu/.Z--

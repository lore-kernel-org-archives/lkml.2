Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2AEATs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:19:48 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48830 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2AEATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:19:46 -0500
Date: Thu, 5 Jan 2012 11:19:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20120105111940.e5675c8d16715767ed193461@canb.auug.org.au>
In-Reply-To: <20120104161122.4e9d844a@jbarnes-desktop>
References: <20120105110712.2666364926458942240d6534@canb.auug.org.au>
	<20120104161122.4e9d844a@jbarnes-desktop>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_11_19_40_+1100_0nBWPN2a2kuVy=sc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_11_19_40_+1100_0nBWPN2a2kuVy=sc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Wed, 4 Jan 2012 16:11:22 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> w=
rote:
>
> Arg failure of my hand merge.

Not really, the original was broken (as is the version in fc16 (which has
been disabled there)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jan_2012_11_19_40_+1100_0nBWPN2a2kuVy=sc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBOycAAoJEECxmPOUX5FE1qcP/A5lh+MIhW3hbSKgXYyC+dV4
Y2uPA4gGm3ZBQIfaDQoUNz/XmgeuiIR0RZEypaF6mWq1PWAwY7zsDBuxMIDDzXRS
7xho1JCetbI+BwHUBXSN191+6Zms+VaguqVAGpq9xb9vUa2e0HH7TRGIXkCj0v9A
LvqUPM3rPgaBZDukd6b+QNRqKnsoZOSqrczg0Cs2F8+3O4xC8Z+myHF486sYUFyx
+OPeeC1cmf32qn5rWKckubbxcR/s1jAOYobx0+UuTS7szGnssQ4k6LN2hJVGYXSb
Gk2+rwtJ7iDDzJjGJ2jjEg67wOBIvIK4nr1Zmp7JcGuUOaYeFf4LSOZFeEXacqcZ
UWp2w13jt6F5lgGCyOOKOX7Eyk+jSryXqkCOanda2zGxOTDW8bRpHih0Zyx65yp/
ZvsXs8Xn+cU0U3mxH6XllnYaR4WzKmtJimkU6IRXh5yG2tLspEwWYUIZkhc2SKdG
w2Xi+xke+c83CGNGYj4oGh8R6a5xiuLJxhGJWIhN1t8odTpgQfmKnmJE20Sb344w
hFVkAvWctyne4ddQHxkTBsGwccbkno/c0yh/pWJk3hGxpUIfoW9PyKFFZEZSDo/v
rDuKwOO4f9onHIhnB4BkBZCc6Chbj+ANCxOpuKP5WV4kY0D/teuaF9aj/w3nzj/d
JaOm24jvZRthuyVqjjfX
=LnoU
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_11_19_40_+1100_0nBWPN2a2kuVy=sc--

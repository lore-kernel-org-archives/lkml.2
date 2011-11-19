Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1KSDd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 22:33:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48348 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1KSDd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 22:33:56 -0500
Date: Sat, 19 Nov 2011 14:33:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, herbert@gondor.hengli.com.au,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2.2 1/7] crypto: GnuPG based MPI lib - source files
 (part 1)
Message-Id: <20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
In-Reply-To: <fad5214d102c09d2a2bf971483efb6e0dbee3937.1319025009.git.dmitry.kasatkin@intel.com>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	<fad5214d102c09d2a2bf971483efb6e0dbee3937.1319025009.git.dmitry.kasatkin@intel.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__19_Nov_2011_14_33_37_+1100_xQyGChyhZ6YuQOGS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Nov_2011_14_33_37_+1100_xQyGChyhZ6YuQOGS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 19 Oct 2011 14:51:30 +0300 Dmitry Kasatkin <dmitry.kasatkin@intel.c=
om> wrote:
>
> Adds the multi-precision-integer maths library which was originally taken
> from GnuPG and ported to the kernel by (among others) David Howells.
> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
> The difference is that checkpatch reported errors and warnings have been =
fixed.
>=20
> This library is used to implemenet RSA digital signature verification
> used in IMA/EVM integrity protection subsystem.
>=20
> Due to patch size limitation, the patch is divided into 4 parts.

I just noticed that this has been added to the "next" branch of the
security tree (and thus into the next release of linux-next).  I think
that these patches should be rearranged as in their current form, they
break bisection (since the files in this patch reference include files in
a latter patch).   We generally prefer large patches to be broken up into
logical sub patches rather than just along file boundaries.

In this case, even though it was broken up for review, it could have been
committed as one large commit (assuming that there is no sensible way to
break it up).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__19_Nov_2011_14_33_37_+1100_xQyGChyhZ6YuQOGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOxyORAAoJEECxmPOUX5FEohEP/2OVeG4HD320nOyH/2ANs6eD
Au7OFHxC5MdNz/LdZ4Lh/yMd5I4/kpdXoZXAUT7ZQUgMW3XCfxxFzWiAqMzXnZ0S
qp6alZOVXtv1SibyRmCnvk9IJ60x8rBTQ+fwQN9pvIZJiTya3eN6gqlvCyGE9hGd
ULh2KXV7CbG4vDwyl5n4/xg9Q9FXmGhdXgREkUZINfcYVLV7mExNLtapAHQG0VhT
WMN4x2faan9STef7aHRLqtXt5ZMu225l93CNQpkGPN/FHZ7EOkfZutu2Y/2mvJqi
yGWkMyx1I+56iO16wFOcpByIHyOfbWgrPYboT4Xu/TR7q+UM99pFeoYeYjFnEPpB
3IUexF+LrwT1OoZXNHcsASGebw2rMrvbfh9igj48ILrZr9kq7g8pksU9Jail4/In
Ac68B4dFLsOfT+rV8Jyz+o5PR0l/3ipCMzwTqWhtHKtZM8Zm6DHOcZEE5HWPZl8D
wYeqp2GQi2l7p8p6gDQTYiq7YSC23Ukhmb3ef4FXGlLXx7YUqv4/hBHWYeu/VIYs
XCGthB3rZ6vCWeWwOdS4coV5OcCt5O88YSdim4q6G84f/X5ptuzH/9ca3Djrlluz
iEvQ2Tn2jULQc1pFEMJCS8FMwu73Lqr6ijOpgFjWncQAoyFBzF6naJRyU52DmZQE
ZVKhi2x/FeCSHo5z4BUk
=ohJu
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Nov_2011_14_33_37_+1100_xQyGChyhZ6YuQOGS--

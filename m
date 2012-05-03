Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2ECFz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:55:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60080 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2ECFz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:55:57 -0400
Message-ID: <1336024538.2056.1.camel@koala>
Subject: Re: [PATCH] vmalloc: add warning in __vmalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com,
        rientjes@google.com, Neil Brown <neilb@suse.de>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Date: Thu, 03 May 2012 08:55:38 +0300
In-Reply-To: <20120502124610.175e099c.akpm@linux-foundation.org>
References: <1335932890-25294-1-git-send-email-minchan@kernel.org>
	 <20120502124610.175e099c.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eNgnivd47g30r683VV7y"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eNgnivd47g30r683VV7y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-02 at 12:46 -0700, Andrew Morton wrote:
> Well.  What are we actually doing here?  Causing the kernel to spew a
> warning due to known-buggy callsites, so that users will report the
> warnings, eventually goading maintainers into fixing their stuff.
>=20
> This isn't very efficient :(

I'll look at UBIFS and UBI - they use vmalloc and probably some of them
may be in write-back paths.

--=20
Best Regards,
Artem Bityutskiy

--=-eNgnivd47g30r683VV7y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPoh3aAAoJECmIfjd9wqK0DugQAIW8EaTY4ZaVIylSG+FHCsTH
HxRyp9vBXs1a0bl7K0qBLoJbUR0k6WuNGjJVX7hHGtYs3p9Q3CwzRoQrmJ4r377V
KKW8d/oDuzCOEycIa9LJqPh5SEcdxRCL1gtaKJ3tFPclntUj9k7MC2if61GdXQuY
fhfJIgCeZXu0e7oft8szQMJCi2tmt3QKeZ++KHToy86BHSR5uoG6Mbp+vYYppPhV
pkQXK/UhHYsNBEj5Vz7mZx5fNcOpz9EeM6Z7Xo79xi3u+LEn0ugYOABrLfB5zMZG
3ckZEJvOE1egE2/QOv3wD/55VvPTDzD7zpsnMbNQIgUFYwix6G72WTn+ZDxV+4Kc
CqiNpJ+4F9s4JVT+GvLS0tgLvJzcvA05x7TGzi7d/WyVsgWJsVVr4Ku4kHcCdWcS
bpRFCk3PotHIqbugriW0GRd8hBw0sGtbNzol2ye2tqE2mvvkDXlUSnLKEL/42APE
UheXtHFq6w6W4Vt+lNZbuW+JWH0/ga6cI/Zwn2BCwnM2LDpcx3LhAKeaM4vgzwHy
ryk8/RlOqgHBOfd3snfaEzk/3v4VM2r3PYDxyV244dOXRO5p2qDBt/KVJ0/6UXb0
VEGX5JXelBnXr9tBU6SHPRDx1AyaNRx9vw2D8oEmYJ/fERyrbQQSUfjEc2WxEKlk
2ok7x2nrfnqnBjjf6OEC
=UZEI
-----END PGP SIGNATURE-----

--=-eNgnivd47g30r683VV7y--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2FQTyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:54:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab2FQTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:54:17 -0400
Date: Sun, 17 Jun 2012 20:54:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 2/2] regulator: wm8350: Reuse map_voltage() to get
 selector of a given uV
Message-ID: <20120617195415.GI4267@opensource.wolfsonmicro.com>
References: <1339502910.2881.1.camel@phoenix>
 <1339503026.2881.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cf0hFtnykp6aONGL"
Content-Disposition: inline
In-Reply-To: <1339503026.2881.3.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cf0hFtnykp6aONGL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 12, 2012 at 08:10:26PM +0800, Axel Lin wrote:
> Reuse map_voltage() to get the selector of a given uV.
>=20
> Then we can remove wm8350_ldo_mvolts_to_val() and wm8350_dcdc_mvolts_to_v=
al().
> Also remove unused wm8350_dcdc_val_to_mvolts() function.

Applied, thanks.

--cf0hFtnykp6aONGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jXeAAoJEBus8iNuMP3ddi8P/Ak23dOneudJjQ2MTaWtz4Np
Y5fVvA7Xv6AyRObyyFbC1q3j9Nf667h2Jha6cgio6YzwDA6slX1XFLVQvDMhT6Gs
Qk3QIKSdOe/pf8VE0enye6DdjngQxtxNNG2DsiL6+AJIgRWl5+Cn4caLkuJpggLC
h3Dy+A+FRlYtlr9iVfu9oIZM0sThX4bh2XvA70kBXS6gRRg7eTcHmgyppoclP+wh
+IOIXfJ47KZizZrmx4YQA/C95Kippknh4/g5mwc3Lz22NgLcYitYuLwQrZddwRy2
SF7ppFUgcS3NUqWZJeaViwAU5lvKBjKyd8DYo7WCoAkQl53VdErwh3emkLJoYu2y
6oY3y+VxE+WHkZ0r3WO6Qqc+DPpZ0PtT6fW6v7CPwUBmrlmG4+yrzuz+cKpW3NFf
xxuN5s5AOQLfnkLBSp6VW4RBRLJlrlo4AiQXxM6HR+MWcg9Vh/wJLhT4Og9zqtQ0
tIRrRukO4TJReRhqxpEoZBL2JwNeGvbRn6+vpl/MG9XbF4wl029VVrGom+RZUxr6
6dqSqBRmxVHjmzeLSSI8S710RFcWaqw5KLE5dEj9o0oex+RdM981IhFsKEg+pdA1
xXDmd3PoiG75UWtH5QZgGYSHPtrHZyP2oKWcKSHY6HFT7tjhFiG54Ma03PUaQDIH
fl3+DARKqyB1o5A5szZk
=ZFC0
-----END PGP SIGNATURE-----

--cf0hFtnykp6aONGL--

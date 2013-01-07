Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3AGLIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:08:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54450 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab3AGLIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:08:22 -0500
Date: Mon, 7 Jan 2013 11:08:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Message-ID: <20130107110818.GB4544@opensource.wolfsonmicro.com>
References: <1357371223.22227.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <1357371223.22227.1.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 05, 2013 at 03:33:43PM +0800, Axel Lin wrote:
> ldo->en_pin is set iff the regulator is enabled by external pin.
>=20
> This patch sets ldo->en_pin to NULL if lp8788_gpio_request_ldo_en() fails=
, then
> we can use it to determinate if the regulator is controlled by external p=
in or
> register.

Applied, thanks.  However we should be converting the driver to use the
core support for this - the GPIO can just be given to the core in the
regulator config which should handle everything transparently.

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6qybAAoJELSic+t+oim9xZIP/iZdGU52Xq1Dv4d7JGq+1h7F
7n/vSy8TOZpveGol5dCRrQg8eE9AhPPAO69jHVAxQWf49qt8n5vp6MsefW3wfn5F
vTA0yNmDaCAJdfYQbjJ8BzmrLvSfmR0Xl6WwlXA7su5ky6BjbKYpGfqZUGa1+1lj
eEYVbJ4SZ+kTok6xSjIgQNt8yLHb4ZpseaWKx8HNHx0YCh5BdMgDlhxgTS9bbutN
C1kJGfpV4nyXorvALpgzHrrknD9rxHlIvXXZEVUxSQY+gQnS+PgdveVWfHWDoOQh
DmHqyibDKUk0OVtRwGIdkziUY4I8c4XCVlgBW8IBfna22/zaBG6jzqRT+JkdYmnS
MHf+FTcTsq6PcIESJS9cNovEVXqZO0/cWud2GLog/9eNzZkoROL2WBdx9rPqAJRP
MW0DztS3kAzx4fuxCyg0fGU7xvs2FiYxIitoOse2+4l2OBguI56dEwPF6lPyu8Qb
lZo4NXDTEECG9lAI+R3rzjrFOwWWRLpvNkNHAK9qfp1lAz9Flx3hXq8e+K6mkWXh
gwaiAoU2q9XQyBur0bIpnq4GGQItirNHieaf3kKNKd7prLx02kgT9ZUhVQvJDdOl
sfPuaqHeRUMe5+FhEPkydyLXV6Fc9QHgpHn7u02zLoCSEMaUDcyoadBRIYcG4NUY
VBldLUzqBVU2bFSMRYq/
=H00i
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--

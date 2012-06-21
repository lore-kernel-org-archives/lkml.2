Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2FUJUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:20:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53648 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417Ab2FUJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:20:29 -0400
Date: Thu, 21 Jun 2012 10:20:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/3] regulator: replace devm_gpio_request_one() for
 loaded module
Message-ID: <20120621092026.GJ4037@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FC052@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FC052@DQHE02.ent.ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2012 at 08:03:48AM +0000, Kim, Milo wrote:
> At this moment, devm_gpio_request_one() has not been exported yet.
> But lp872x driver can be used as a module, so related functions should be=
 changed.
>=20
> devm_gpio_request_one() -> gpio_request_one() and gpio_free()

No, this is a step back in terms of the quality of the driver especially
given that nobody is likely to actually use the driver when built as a
module.  We should just wait until the function is exported and then
reenable modular builds.

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4ub8AAoJEBus8iNuMP3diqYP/1XcA7uTebz/0zvJQ+8hfkgX
RY8txRnUddn7RB63A6UiXc1q5VvhoV5WAYp05QkBx+3Lf10UYrNq4AQ09FIn6y5b
9queGjdfkniM/X3V/NPRni6ZQcgBlDkpACYeDY3YGOnspW3VU2ak0qvqslNucb5X
mC50ZGz1LlPyaq9sj8xhjXzyps7SBD09AMW3317p0AnuFQ6dihVB5E6JkPEgLDC6
FyXBtVtThIdmeeGC4g0/3igFBjrZwN+wByG73o7kVc8f1whcUWMYvZDfsDWxqjcO
zbXtUGxSftXb/wS6a5zoK2TCQdh0Li/PnmXu2m+XXDZ6eZe0k7iRpwuyUMyCMcdN
k14g5jyYtSo8RX06ky8K/8zO7kcbd4qYPexivwy/iIAPVfjqEMcNvAHD1oV3yLz1
Cgo0Z6nZu1E1P5s+gCyvANSTJJ+dlEIbBFrMKldeEOxz86d44FxfJui2eOlot6r/
SUEHn60rTX+eq9djJYb1HqLmmcMzbXx9uUfTEzhYnq7+XjB8nhmj2Kk3nOdNTD3u
KVbeIXv9TsCHA7DmQaj9utB0abR55YIOWO81utDnvc2OQjHovTqL+hg2lLMePtiR
poecr+0teCe6EM0+qp7lbb/0lMMwMVh4R9fNz1jig8JtZtvShxRkK3554S3uk+LZ
UVagl/ZpssUdlrUEf2fy
=tyHg
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--

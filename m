Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3AJM5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:57:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754423Ab3AJM5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:57:30 -0500
Date: Thu, 10 Jan 2013 12:57:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: lp8788-buck: Silence build warning
Message-ID: <20130110125728.GS20956@opensource.wolfsonmicro.com>
References: <1357785186.28668.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A3RWl4qWgABmkY4K"
Content-Disposition: inline
In-Reply-To: <1357785186.28668.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A3RWl4qWgABmkY4K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 10:33:06AM +0800, Axel Lin wrote:
> This driver use id as array index, thus add bounder checking for id.

Applied, thanks.

--A3RWl4qWgABmkY4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7rqeAAoJELSic+t+oim9ytQQAIn+YmJReJ3Z46vtl6apxM7p
FCoWH2f6h8j3I8DuiVGy3uhCBcgTILm1ErDDRQb+Tx4SJ1EiNXWOl5L5xNrmhHEw
1qZw3YU/9cBNftyFtanZF7nW9TZE3+VpBxaa+AkBRLVM7nOG4SpyQxZp70u86hmv
I0qx/QADBC9KzAohhfDEHf3pdWp24/iXYG3Nx8TUIyVu33UnEyP177b+paY3z8RG
Y1d/y/ycDNsLYEUKROInqssNMORn8WX1pdYRnhVEm5wtx/qbucJExkMKXuyhWook
+ipEEirISsE2t7szZa8iNM+W3gn+VLqMJGUH/o2difJmHTzhmHsfsh1DNzKRd3Cg
bko4GYMGlY2kancJoYBnK/8KRBfZZonA+Yl35ppw9Pukg96+ZUbayYW65JtHNui6
rf+gSBEEgFhwSOMvLfd2uQ++BVguXmwYdeW7eoeyxiHZji4qmKuNteP5I8RROvA2
MFVBJeOVBRf4nvzIJvLofRfspU+ELMRFx76WTABfpxFFd7zBsTjnkkXBeUWk/HC8
sSkuDu6/r+z1qTCQgkoG3IAU26iP/ISIMtl/vIVCAkLLYe7KUKZ2gtU+fNwOqh9u
H56lxgE8c0S3LhwNBGtsSXH7eF6Iu6sX/pKQuD85PjbavKweiEtZKWkMHZHX8Rpw
V/GDes270Di7sOKIh7QM
=A3qh
-----END PGP SIGNATURE-----

--A3RWl4qWgABmkY4K--

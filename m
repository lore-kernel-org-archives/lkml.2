Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2EVKLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:11:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38796 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723Ab2EVKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:11:09 -0400
Date: Tue, 22 May 2012 11:11:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Add terminating entry for i2c_device_id table
Message-ID: <20120522101106.GG21999@opensource.wolfsonmicro.com>
References: <1337614402.15342.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JbKQpFqZXJ2T76Sg"
Content-Disposition: inline
In-Reply-To: <1337614402.15342.1.camel@phoenix>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 21, 2012 at 11:33:22PM +0800, Axel Lin wrote:
> The i2c_device_id table is supposed to be zero-terminated.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Samuel, Linus already pulled the regmap tree so this should probably go
via MFD as a bug fix?  Might have to wait to after -rc1 to avoid you
having to rebase though...

--JbKQpFqZXJ2T76Sg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPu2YzAAoJEBus8iNuMP3dRmUP/3oVkra7Ox4jL1NEcsftyjaG
lj41Kmc46HbwiOlqzVqg8srFO9EKnP0Ud6l38MEM8SlAq3Fo96l/Dg3A0WQjfiI0
o1gHmk8+tGYXnV88HBgI5wg8SbI17jw2OYHPLffYNuEpMNgZJs5cht6FjMv4Y83M
/nNX05az0+5kubDj85z0/iDN12+rCZCMONixGbxMBlub7HEIp47lVmldyq+qVx1k
bCQO6pWVx1TkQnU1LDlsN8DmS9hzNi/eX6/hQV4w2N6mSdAnJkno3/Xmw1gOw2bk
d12XVnNq6RVqLZQYtS2GgeJD5VZKCA/MTvvlf0WOlqpYSixr0m1ZZ4A1an+pm+8y
Re5IIO/ndmFuhidVGrhnEKygYdDtYcLKSwdgGrRzU2AHgNBKsY0uNhKnLU84jzq+
1gQo3LQWqQGAQ/xqga+IyZlZPa0iOoylE1zcOYu6FRKhhCIQDSPLvbnez7tBzI+i
h60zgxl6cAf20CmvmLvZA0mB04coPO3T9VQno33JAHH4eNXUI+IJ3H95y+5ovgAr
cu7avaSyAXIPEFohqQATw1QgZB9JHftZM84vJqUFp4HZis8ovWn3L3Dl1NRP52gr
fIUQ38N24h8AL50ws/QlF1KQ1gCjMK+sxY5E+MZ08DwC8fq8Wvbm02yxnG7QE/9n
0HFTf4r2KhihVW73DNGb
=2rU3
-----END PGP SIGNATURE-----

--JbKQpFqZXJ2T76Sg--

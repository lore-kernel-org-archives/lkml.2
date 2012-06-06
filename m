Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2FFOwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:52:09 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:36739 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab2FFOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:52:07 -0400
Date: Wed, 6 Jun 2012 17:50:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Joe Perches <joe@perches.com>
Cc: Felipe Balbi <balbi@ti.com>, trivial@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH] trivial: treewide: remove extra semicolon added
 by module_init/exit
Message-ID: <20120606145014.GD14628@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338991324-7051-1-git-send-email-balbi@ti.com>
 <1338994062.9522.12.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <1338994062.9522.12.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 06, 2012 at 07:47:42AM -0700, Joe Perches wrote:
> On Wed, 2012-06-06 at 17:02 +0300, Felipe Balbi wrote:
> > The definition of module_init() and module_exit()
> > already added the final semicolon creating a situation
> > where most of our drivers end up with two semicolons
> > at the end of every module_init()/module_exit() call.
> >=20
> > To fix that, we add missing semicolons to the places
> > which didn't have them and remove the semicolons from
> > the definition of module_init/module_exit.
> >=20
> > Patch generated with the following sed script:
> >=20
> > $ sed -i 's/^module_\(init\|exit\)\s*\((\w\+)\)$/module_\1\2;/g' \
> > 	$(git ls-files)
>=20
> I don't think that script works completely.
> It doesn't find the module_init in fs/autofs4/init.c

hehe, there's a trailing whitespace at the end of that module_init()
call. Will fix the patch and resend.

--=20
balbi

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPz24mAAoJEIaOsuA1yqREqSMQAJexwgryFdLn5JS4eT7otB1b
nMnOWBhsm+/L/KV3jW2Ll6fwjXsz19v7w5hVdGgl1S92ME7xVD4Wee/597xVTEBb
KmhFr6GGdJ+LWobMjntc8/E4cTmR/l6Kx4UGveq11kx+iUQNfaBxZiEsoDc0Cwie
JXkPV4YvX0gGmLXJGp58VaW0x/esJdamWbp7oNFEBXQauDRIAmzQG+xLOw1nNIqY
G9Qty9iJtDz7NH/+/BTEi1jDB7Bo9HHrwEnDep9tgyYYGwViO0qyrQVdEC4XFKP3
Di1yekVG1Kz7iHR/kjaAE8yHlA5t25JhU0LusZVlUx24hsCWMsPD/BaRBj8IdNd1
2Ag9y0q5KIzHMlNSOXBv0NPA9BaoBKBRpvkQiQhuNrUvGNHARFCZC2+UAi32dJ7Y
v0lPS+GKp1JhE5qbcXBlMjjSyNLotmEm38PnzaFmgTG3Fd1UaLfEJ+qdM/qmgDZL
MV/q1OkfUp9NPSxFqsHxc1zH0xnCnkr6GvOYFSTR/xN5v4XAb+Vj+rY2fG3t6bYF
pcoUaXM0IafYcxLrdDMhbqIeYCpprcd81LR05L5of0XEnDE0w2aRAQY/SGiJu/hf
5D3a4KJlj5RZ1U4rb2vsAcQ4mJO9PvuxyykDByNUkcG0mHLTei0jx0ejwh6nLAEn
JyW1RiVmxBdy0K7I1XYB
=klfU
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--

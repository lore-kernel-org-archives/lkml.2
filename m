Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2LBP1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:27:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58032 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab2LBP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:27:08 -0500
Date: Mon, 3 Dec 2012 00:27:02 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [RFC] regmap: Add no-"bus" configuration possibility
Message-ID: <20121202152701.GF17981@opensource.wolfsonmicro.com>
References: <1353705924-25401-1-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vx/N56bIaYnO6ICL"
Content-Disposition: inline
In-Reply-To: <1353705924-25401-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vx/N56bIaYnO6ICL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 01:25:24PM -0800, Andrey Smirnov wrote:
> Second version of the patch with incorporated suggestions form
> Mark(hopefully):
>    https://lkml.org/lkml/2012/11/20/249
>=20
> Once again at this point this patch is for illustrative purposes. If
> the overall structure and nature of the change is agreed upon, I'll
> work on properly implementing it and testing it with my driver code(SI476=
X).

This looks basically good  - I'd like to see the refactoring changes
split out from the new API (and in general done in smaller hunks) as
it's a very big and invasive change but the top level API and the basic
idea look good.

--Vx/N56bIaYnO6ICL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQu3MNAAoJELSic+t+oim9TDwP/1sKf9z/iFrX4AFIHfARUKYe
WrmI3EESh3RBMfGhyNE3ouCMVT7gOoArdq1/Kn1YkG82RlVW0muc+MZ0IyaY9fm3
n1XjBCW2BnhkaAwwqfT7sy4CyasImqqHxLotcwU+r+uip7ZjlUhSSLjGRatHpk0X
VfpjYT7q8FZY/AOFTeGUsORPnMw5HYW2FRqHq1wIQYtFn1SX6RqIDRuxTnf/1Pp+
vycF6noWro7gUpApu2XciJjt4P41Em+o1QYhlNBhamnfgr95tqJ5q+f+qVzk9UpF
MHYghOwrROUdPpySO1CDt9Ic07iasDXaWNWALdETFhEONiHfV9MGkcRBbEL8K8rU
Qn34w26i4AA8ndrxVClG+E7h6h1mJwwLsjEi94UM+2fD/MMgNymXlIaEXfrY0Rwv
8TDO28/szok4dlbJTF8oBwywiJG8D9trI61ov07sR8cBw5FobjLXZbF+lYuxziUt
zlZEkowcXtVuZoj7nT2TP6A8B3czHCZ4NYIqT/1b2USvz1kmNhLOuLXfGUhb8Paj
meXEeT0at1k2ssrJ4Zip+awa4CGJPXncyiN6F2fluLSaNitrUFNDIh5cp31oGM1E
iYQOT7rBQJP0MyGgurNFrNXc0yJq3VyspYGFv5PVYtVZnPsGDYRCC+OW41mf6n1G
VlRVb2YIMBcocPXOyezZ
=/glS
-----END PGP SIGNATURE-----

--Vx/N56bIaYnO6ICL--

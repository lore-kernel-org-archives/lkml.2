Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab1LTGkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:40:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59180 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1LTGjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:39:54 -0500
Date: Tue, 20 Dec 2011 17:39:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 19
Message-Id: <20111220173945.8744055611309f8aa79cb7b1@canb.auug.org.au>
In-Reply-To: <20111220142048.eeccb51ed290d8223ba2c580@canb.auug.org.au>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>
	<20111220015235.GB8290@sirena.org.uk>
	<20111220142048.eeccb51ed290d8223ba2c580@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_17_39_45_+1100_.ENXpofIHJ0f3hxt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_17_39_45_+1100_.ENXpofIHJ0f3hxt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 20 Dec 2011 14:20:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Which I reported to you on Dec 15 (along with another build error in the
> regulator tree that you have fixed).  You even created a patch to fix it
> (Subject: [PATCH] mfd: Declare da9052_regmap_config for the bus drivers)
> but that has not appeared in your tree yet.

I have applied that patch to linux-next today and will drop it when it
appears in your tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_17_39_45_+1100_.ENXpofIHJ0f3hxt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8C2xAAoJEECxmPOUX5FEJMcP/jdbm8rThaVXHvX7Mzj1uZ6P
eNwlWCrm2SbfxTNYZMz1IpmrHGWzfGzAiSv3youokSkqecz6kzQVyaH2hKOkC+bf
Bf1lJIZM29Wwg71P61GR6kN6w/hZCuL1h0/YV/esVwVEg+V2VhjgC7LyaFtejFGZ
QuXozqjpCLR8pH3eJYHyHfuO7y2MvEMvH0ax/Plu/EG31tuws4+3R11l2qcxBhCX
/QP4FbOp+lruUvZqmXwnBUuHyW1jkzvVDcwYz38VO+EgGGxInd2J5tp4LQZr+7iy
c58IZy9KDxSMbaahCjV63bdYRWoJaognOF8cMlLe+0rXpgLHPWFcs3cNbl0YqnEZ
N0mwJoLqO6mowz7k9R6GkycJYhQkblE59Sh8wNnsHhVi+B4dSM0wEEyxaVqIaL+Q
R5clLOoOyrQFGZ5pv0CkBCfjwnqEdtqVrMuUI2GdSIEx+AOYolCYq5nanZRJ0+Bz
nkgoBRZ2QdT+6EKJ8Mz0afkOCMrHI/mykWC+rs/kE3LdtzfyaVv/z9H1jJ/C/jZo
ohk5u/7xzzs9xmIim+uoGmZVbGD3PIhgUmceC/vo+jRtQif2KJRzNmPlAHH+ABWA
r1PKF8rPTt25+hv6xvZ+bfQdK7+DaDakNrmxlBBNn5z7BUrkl6Ridni49DEkVItb
enwvY38RzkjAiLtKyyNb
=0yxe
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_17_39_45_+1100_.ENXpofIHJ0f3hxt--

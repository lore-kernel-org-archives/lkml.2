Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab1JGMg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:36:26 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55261 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1JGMgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:36:25 -0400
Date: Fri, 7 Oct 2011 23:36:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary relocation of the regulator tree
Message-Id: <20111007233607.dfaf5622a5001c594163d41f@canb.auug.org.au>
In-Reply-To: <20111007114046.GA24534@sirena.org.uk>
References: <20111007114046.GA24534@sirena.org.uk>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Oct_2011_23_36_07_+1100_M_AShC+n=frZspeq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Oct_2011_23_36_07_+1100_M_AShC+n=frZspeq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Fri, 7 Oct 2011 12:40:46 +0100 Mark Brown <broonie@opensource.wolfsonmic=
ro.com> wrote:
>
> Due to a combination of the kernel.org downtime and an intensely busy
> time at work for Liam can you please change the regulator tree in -next
> to be:
>=20
> 	git://opensource.wolfsonmicro.com/regulator.git for-next
> =20
> until Liam manages to get sufficient free time to keep up with the day
> to day flow again.

OK, I will switch to that tree from Tuesday (Monday is a holiday) unless
Liam screams.  I have also added you as a contact for this tree (called
voltage in linux-next - would it be better to call it regulator?).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Oct_2011_23_36_07_+1100_M_AShC+n=frZspeq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjvI3AAoJEECxmPOUX5FEWWoP/ApKiljRuQhhN1v2YVL5gGxc
MuG6qSIM6b6EpLPQn30BzwsTdjoY4aZPe5/Gt+ZkB77h/6trWhI+1k7Y7bnSB58z
SQyUj7UPcVO2GvHLJeRMC6aVa26gSBz1HAJd0b/ckkqAwOyJ8jErfQB/Pa5z8wXW
L0R9DS/h17i3ZUySTFsChjbyzr1Ghk+/yQ8NgSjSam2H8SIVD6BzcInfPdyqT1Ix
OVF3P/UdetvWWObXJpFFOcHkH7p5J9KkEw7YIDavBGgk4/Yni0in9vcEuQuXDCQ2
W3ByROqVvkWhDOliiTPrCE/4gR82g6caMK0cesnud2P7lVhWShtn0HJMUmle6WsB
7BYFVJzFa90Bqcpi3EWS61I3yKpfd9KT43bYp3fEoEc1S0Lqd7sm4Tj4f8TyUSjs
4/mvZjP7lK/KyS4DTmFXJH72xZIGOBq2LJDGPyoOF8Rl0SJ8uSHP2A/5PFxk5Kdw
UVn2tNByTjS+2+9zXbisHx99YWzrqckypkGmmNYD2Yx4wwgm2Phy6kgA7EedEyf/
+xAI1x7ReOQps45zWktbw+Kh34IyDXq8JA+QNHuMEECdjyBmFLq4y670qdmFTQ66
hMo4t8qmNzXvdgf38tbtG9cO9ecE1ecJSmbuT0LGpFahPeEHoT+sI5ciVEE/4DKh
Dz4CX7jZSh13FODupcAE
=CwVl
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Oct_2011_23_36_07_+1100_M_AShC+n=frZspeq--

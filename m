Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1LSLdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:33:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42068 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1LSLdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:33:05 -0500
Date: Mon, 19 Dec 2011 22:32:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20111219223251.b8e821261330831e4861b297@canb.auug.org.au>
In-Reply-To: <4EEF0856.3040306@kernel.dk>
References: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au>
	<CA+icZUWrpTFPhM0cTQgvBPnMqT3zZufcxQ6c6wh7=EtkD4of9w@mail.gmail.com>
	<4EEF0856.3040306@kernel.dk>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_22_32_51_+1100_d1TGDQCD3brYTt39"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_22_32_51_+1100_d1TGDQCD3brYTt39
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Dec 2011 10:48:06 +0100 Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2011-12-19 10:45, Sedat Dilek wrote:
> > Just FYI:
> >=20
> > - block           git     git://git.kernel.dk/linux-2.6-block.git#for-n=
ext
> > + block           git     git://git.kernel.dk/linux-block.git#for-next
>=20
> linux-block.git is the one that should be used, however the 2.6 one is
> just a link to the new one. So old urls work just fine as well, it all
> goes to the same spot.

Thanks, guys. I have switched to that now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Dec_2011_22_32_51_+1100_d1TGDQCD3brYTt39
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7yDjAAoJEECxmPOUX5FEfbIP/j0IfzR9fr0lrX7xSUSKWITy
df0m8r/1eQ8zryHvp8oedbaAGLlFXCLazcvH52Pn+L/93/dLN7M249qjX0muzxja
OAApVJNRjO3eCMHe1j9lO9pzO2z3+Ajp2vo7KstLff08G0IjQMbP/YhoWLUsRhCY
ttGxarC85aNxRP4qs6fMCdw15b6KoqiP+rDhEo8o0Ex+Mk57Ou4Mqmg7G0iV2J9D
h3Il1DMfbLA0l/5qbzpmbnFZKRxsr+NN8HUykf/idsWh1mTCDBk1uUI/kqTbMi54
L2vmMJ7fbs8DO80zqxan2LoRfgYHKkm+928LhqdakKEilSXanVb6d3ZE2ZWBYKFm
4kpEhJ1oxXW0G72NCkswQPyJzNvrcR+cIZc7/aJJb6qVntg3mSDw8R0SJ7pYXdQi
RelXDA3pzxvwqPuwPjY/XYHEuua+nhmQ+96B62Q4TMpG+AeAtx2dHDkRz09rPfWL
S7q6CWXyUYXc9AqElb+UI0K8TVhGRVhktXLZrAPkU8Xo8S7wnsz/g6QwaLyd7EuP
hXsP2Cmk58HNvSha550y0VVo4ycVIoXRjLl9k+tu8Uh7XtBqjqFJlk5UaLh9i56X
vTKqYPzdseIpSJHreWLx47siIO6B4KYMYFGNrvSmOr2pSI1YdHsZudOYsEN8eL3d
bVGJNXyxjf6Pro6hxzuh
=igWm
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_22_32_51_+1100_d1TGDQCD3brYTt39--

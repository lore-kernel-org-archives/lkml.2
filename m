Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab2LCSD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:03:26 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:38365 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2LCSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:03:25 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Mon, 3 Dec 2012 19:03:18 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121203180318.GA22323@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Dimitrios Apostolou <jimis@gmx.net>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Theodore Ts'o <tytso@mit.edu>
References: <1353855815.22969.20.camel@soupermouf>
 <1354452243.22969.48.camel@soupermouf>
 <20121202225051.GA13685@mobil.systemanalysen.net>
 <alpine.LFD.2.02.1212030120090.1646@soupermouf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212030120090.1646@soupermouf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-12-03 Monday at 01:56 +0200 Dimitrios Apostolou wrote:
> Dear Ronald,
Excuse me, my name is Roland.

> sorry for not replying at your first message but I didn't consider changi=
ng=20
> kernel as a resolution to my problem.
>
> =E2=80=A6 =E2=80=A6
> > =E2=80=A6 =E2=80=A6
> > One advantage of Linux compared to other OS is much more support for old
> > hardware, if a  _proper_  kernel version is selected.  Many years ago I=
 used
> > a notebook with 40 M total RAM, with a 2.4 kernel, Blackbox window mana=
ger and
> > Opera web browser =E2=80=A6 it worked flawlessly =E2=80=A6 just rather =
slowly due to swapping.
> > Your notebook has much more RAM than 40 M, thus there is surely a Linux=
 solution
> > for you.  Try a 2.6.27.62 kernel, it supports ext4 (=E2=80=9Cext4dev=E2=
=80=9D), probably it
> > supports all devices of your notebook, and with a slim window manager e=
=2Eg.
> > WindowMaker or OpenBox your notebook will probably =E2=80=9Cfly=E2=80=
=9D.
>=20
> I appreciate your advice. I remember when we were running 2.4 much less=
=20
> memory was needed, but still I consider the kernel /fairly/ lean=20
> considering the time passed and the bloat in userspace applications. I=20
> choose to run latest kernels on old hardware, hopefully this will continu=
e=20
> to be the case, and if things deteriorate much then let's hope we'll have=
=20
> enough time to help and fix them! :-)

Ok, this is another story:  You are not looking for a least-effort solution=
 just=20
for your notebook.  Instead you want to contribute to the LMKL community=20
solutions how to run current kernel versions under extremly tight memory=20
limitations like with your notebook, right?  If so:  This is highly appreci=
ated,
thank you!  I will interestingly read your findings :)

--=20
Roland

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlC86WYACgkQdN/hKfT7G/KiqwCdF5RGbecyQqDtnWxMSVVJSMxN
eU0AoJ6PocAgR2EqSQuKDCVpsLl7T/1R
=sqKF
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--

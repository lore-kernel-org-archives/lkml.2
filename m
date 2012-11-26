Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2KZDLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:11:48 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:44854 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2KZDLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:11:47 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Mon, 26 Nov 2012 04:11:40 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121126031140.GA26738@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org
References: <1353851735.22969.18.camel@soupermouf>
 <1353871800.22969.28.camel@soupermouf>
 <20121125225954.GA14653@mobil.systemanalysen.net>
 <20121125235651.2f73a539@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20121125235651.2f73a539@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-11-25 Sunday at 23:56 +0000 Alan Cox wrote:
> > Does anybody know a x86 distribution or live-CD using a 2.6.27.* kernel?
>=20
> Probably not a good idea, there are known exploitable holes in 2.6.27 era
> kernels and nobody maintains anything that old.

=E2=80=9Cold=E2=80=9D is relative =E2=80=A6

cd git/linux-stable  && git log -1 --date=3Diso v2.6.27.62
=2E.......................................................
commit bc4e1a77b06519a01e7aed1125695598e27ddeb2
Author: Willy Tarreau <w@1wt.eu>
Date:   2012-03-17 14:03:53 +0100

    Linux 2.6.27.62

    Signed-off-by: Willy Tarreau <w@1wt.eu>


=E2=80=A6 and surely less exploitable than a system suffering oom-killer ac=
tions.

Google "linux-2.6.27 download" gives some Ubuntu hits =E2=80=A6


> I guess RHEL/Centos might work for you.
>
> I've not had any problems with leaks in 3.6 but there have been a few
> reports and its clear that some obscure configurations trigger something
> bad.
>=20
> Gnome 3 on the other hand leaks like a sieve.

For a system with 128 M total RAM, Gnome is obviously off topic.


--=20
Roland

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCy3ewACgkQdN/hKfT7G/JE7QCdHXVognKD9q2kIVat5nd21vio
bdoAn0xutxExvYZFZqOgJZSPaBgf1Kf6
=dbVK
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0GALEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:04:53 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:44096 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab0GALEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:04:52 -0400
Date: Thu, 1 Jul 2010 09:40:52 +0200
From: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>
Subject: Report for 2.6.35-rc3-00262-g984bc96
Message-ID: <20100701074052.GA3501@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc3-00262-g984bc96 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning!

A short report on what's broken in 2.6.35-rc3-00262-g984bc96 with
the Lenovo X201:

=3D=3D xrandr =3D=3D

After using xrandr several times in xorg, the screen gets
"fancy": blue/white/black changing patterns.
Getting even more weired when changing to a conosle.

The only thing that keeps on working is the mouse cursor
in xorg. This did not happen with 2.6.34-rcsomething, neither
with 2.6.33 iirc.

This is a Intel Corporation Core Processor Integrated Graphics Controller (=
rev 02),
attached xorg.log.

=3D=3D netlink/carrier messag =3D=3D

dhcpcd does not get updated when the link is established,
need to restart it.=20

=3D=3D suspend/resume (to ram) =3D=3D

So far no real crash! Only xorg is sometimes not coming up
again, but this may be related to the first issue.

=3D=3D wifi / intel 6000 =3D=3D

Works! Works! (Besides the netlink issue, which is annoying,
but for all devices).

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwsRoQACgkQ19zI5DGHffBPKACffY5a0PTNwt+ldstHcOKPYdv8
w6QAn12MJHsNn4rEgo+LnvUpHOvP/aHf
=1HHt
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--

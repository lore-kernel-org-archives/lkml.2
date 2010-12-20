Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab0LTUrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:47:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54348 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769Ab0LTUrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:47:36 -0500
Date: Tue, 21 Dec 2010 07:47:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J.H." <warthog9@kernel.org>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ftpadmin@kernel.org
Subject: Re: linux-next: Tree for December 20
Message-Id: <20101221074727.00900015.sfr@canb.auug.org.au>
In-Reply-To: <4D0FA098.8000405@kernel.org>
References: <AANLkTi=gjHyMt=W4-+PSMzt7PN7i-_Yvmx7EE8z0z74q@mail.gmail.com>
	<20101220230007.e82487b8.sfr@canb.auug.org.au>
	<AANLkTin4dvM1B8GkxZH6DADJVg4ZWNSQvUHAviy-4O2J@mail.gmail.com>
	<4D0FA098.8000405@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Dec_2010_07_47_27_+1100_k1fezbPcLF.wpvjD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Dec_2010_07_47_27_+1100_k1fezbPcLF.wpvjD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Mon, 20 Dec 2010 10:29:44 -0800 "J.H." <warthog9@kernel.org> wrote:
>
> Gingerbread released last week, loads have been spiking to well above
> 300 on the frontend machines, RAM usage has been in the ~20G range (on
> machines with 16G of RAM), and we've been running an *AVERAGE* of 2000+
> simultaneous GIT processes worldwide (normal is in the 100-200 range).
>=20
> Bonus points that we blew a drive on one of the machines yesterday.
>=20
> I don't think anyone was quite expecting the onslaught we have gotten
> this time around, and I'm going to have to make some changes before the
> next big release (mainly shifting Android over to the bigger machines)

Thanks for the info.  I figured something like that was up.  I guess we
all just need to be patient for a while.

> With cyclical patterns of fast and slow syncs.  We seem to be (right
> now) in the middle of one of the slow cycles with the last few syncs
> taking a couple of hours each.  The culprit, for at least the current
> sync, seems to be the box with the highest load and the blown drive,
> which I'm also reluctant to disable since it's still handling it's fair
> share of the load and dumping all of that onto the opposite US mirror
> would not be good either.

Fair enough.

I normally wait for the sync to happen before I send out the linux-next
release message each day.  I will continue to wait for a while, but will
lower my expectations :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Dec_2010_07_47_27_+1100_k1fezbPcLF.wpvjD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJND8DfAAoJEDMEi1NhKgbsHCwH/1TbL0uWeYX+zc1EH8VgadJF
8TF9izpYZNictB+ockomACFKdLU2HDf0AAYioTR2Rk98Ur6a2BdQnw/r4kxOkc8N
LKmo2fIMDbeXWMmX065P57BurIQicS3aqSqxeu9qgJhDP/wgm98ubnJpCTojDcHZ
LjB2R/F9NGcbeGONUmVUenZkYqfa72mlM91oj11gfQJdMaw6ZGMFdUjMoX79BATm
R7ccdvmULy5RuQUHI2Hq+2cEkqPwQeCzK9uL8kQkz4jjGL4dp1fwIgYhSrO9c9UV
VtBboarnx5EjoxgDHxwIzjx9TgghveQ3+uxtKso8f4AEh23BJxQl9K63Fpj7vy8=
=giNY
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Dec_2010_07_47_27_+1100_k1fezbPcLF.wpvjD--

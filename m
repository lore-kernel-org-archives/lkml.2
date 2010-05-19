Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0ESVeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:34:22 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46533 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0ESVeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:34:14 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 17:34:12 EDT
Date: Wed, 19 May 2010 23:29:06 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100519232906.3be82279@mjolnir.ossman.eu>
In-Reply-To: <20100519230426.47c6c1ed@mjolnir.ossman.eu>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29891-1274304548-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29891-1274304548-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Managed to provoke the bug twice more on this file:

--- good	2010-05-19 22:49:00.992620437 +0200
+++ bad2	2010-05-19 23:06:36.738619944 +0200
@@ -1223670,13 +1223670,13 @@
 012abf50  fa c2 39 be 53 35 a7 d4  03 1c 72 71 64 c8 02 2c  |..9.S5....rqd=
..,|
 012abf60  51 7f cc 03 96 9e a4 62  00 18 9a dc e4 f9 69 c4  |Q......b.....=
.i.|
 012abf70  30 b0 47 4b d4 5f a2 ef  d9 cc c3 59 c7 c5 c5 a4  |0.GK._.....Y.=
...|
-012abf80  de af 90 f2 a6 46 36 93  4c 8c 38 95 cb 65 5a e7  |.....F6.L.8..=
eZ.|
-012abf90  42 ec 2f 7a 46 42 2d 01  e3 26 ce b8 14 90 d1 6b  |B./zFB-..&...=
..k|
-012abfa0  eb 17 2e f9 42 e9 a1 e2  f9 47 b1 ac 23 7e 52 18  |....B....G..#=
~R.|
-012abfb0  a1 40 99 28 a4 d4 13 5e  85 54 b5 73 58 59 53 63  |.@.(...^.T.sX=
YSc|
-012abfc0  3e 9c 4d 0e 31 4c 70 fc  ee c6 17 3d 4b 22 78 60  |>.M.1Lp....=
=3DK"x`|
-012abfd0  01 e1 2c 26 88 a5 a3 63  b9 dc a8 7f e9 90 da 53  |..,&...c.....=
..S|
-012abfe0  f4 84 f9 b6 a0 85 ed 87  0f 6d 9f 14 04 1d 92 fa  |.........m...=
...|
+012abf80  55 dd ed 51 6d bf 0c b6  f5 79 d9 5c a5 7f de f4  |U..Qm....y.\.=
...|
+012abf90  ff 47 61 a7 a4 fb d5 72  3e cc 74 b1 61 e4 4e fd  |.Ga....r>.t.a=
.N.|
+012abfa0  7a 37 44 0f 32 e7 47 75  73 3a 46 16 3b d5 b0 47  |z7D.2.Gus:F.;=
..G|
+012abfb0  ed 24 37 22 36 98 1e 64  11 5a bf 80 63 4e b0 7b  |.$7"6..d.Z..c=
N.{|
+012abfc0  2b 00 bc 02 10 c2 69 cf  d4 82 f9 d7 ad 1e 70 37  |+.....i......=
.p7|
+012abfd0  37 a1 44 6a 6a cd f3 ea  31 7f 46 c5 0c 11 07 7c  |7.Djj...1.F..=
..||
+012abfe0  33 ca 6d 53 ef f1 6c 5a  0f 6d 9f 14 04 1d 92 fa  |3.mS..lZ.m...=
...|
 012abff0  13 af cf 24 7b cc 09 f9  55 a5 72 4a 92 da ca bf  |...${...U.rJ.=
...|
 012ac000  fd 4f 96 09 ce 07 08 e2  d3 15 a6 f4 d9 30 08 84  |.O...........=
0..|
 012ac010  88 6b 89 8a 42 b3 56 98  9a 5f 6a 08 74 2a f5 c7  |.k..B.V.._j.t=
*..|

--- good	2010-05-19 22:49:00.992620437 +0200
+++ bad3	2010-05-19 23:21:17.600620102 +0200
@@ -693238,13 +693238,13 @@
 00a93f50  de 0f 0d 8c f3 62 a8 fa  a1 8c ec cf ca 0a 46 93  |.....b.......=
.F.|
 00a93f60  4e ee 6b 03 8c 44 29 00  52 0b e6 18 0f 97 96 91  |N.k..D).R....=
...|
 00a93f70  c0 b7 c5 8c 8b 0a 45 30  71 8a 8c 37 79 2b 0c 93  |......E0q..7y=
+..|
-00a93f80  87 5f e0 1f 0f 64 77 85  8d 42 db c1 01 1e d7 d8  |._...dw..B...=
...|
-00a93f90  b0 00 2c 59 c9 c2 5f 45  50 ee c7 a5 cf 89 15 82  |..,Y.._EP....=
...|
-00a93fa0  9a 1e 00 f9 be 84 01 99  05 7c 70 c6 fa 1f ae 44  |.........|p..=
..D|
-00a93fb0  e3 fa f7 a2 dc 9e 69 18  1c a2 06 5f a9 b8 65 d5  |......i...._.=
.e.|
-00a93fc0  86 5e 97 96 08 0e a6 19  6e 65 2f 33 7f 6c 1e 3f  |.^......ne/3.=
l.?|
-00a93fd0  39 39 e9 94 c5 e1 06 52  2b f9 27 07 90 d9 67 d1  |99.....R+.'..=
.g.|
-00a93fe0  32 d9 4c b7 99 8a 7b e0  9b 96 9c 1d cb 5b d9 7a  |2.L...{......=
[.z|
+00a93f80  a8 68 75 de 11 79 03 39  cc eb 1f d7 53 08 dc 0d  |.hu..y.9....S=
...|
+00a93f90  54 e9 55 fc d1 31 5b 18  f7 75 7a 16 3c ab 53 b5  |T.U..1[..uz.<=
.S.|
+00a93fa0  e5 f5 ac 46 0d 4d 0e 01  e7 82 60 df 36 44 cd a9  |...F.M....`.6=
D..|
+00a93fb0  01 42 a8 c6 5b ee b6 c6  84 0f 8c f0 50 9d 37 98  |.B..[.......P=
.7.|
+00a93fc0  44 52 2c 61 08 38 b6 03  2f 67 cf a9 e6 ab 75 8f  |DR,a.8../g...=
.u.|
+00a93fd0  c8 de bc 0b 58 8b 61 68  09 34 35 11 81 23 ae cc  |....X.ah.45..=
#..|
+00a93fe0  ef 1f 85 8f fb ea ee 17  9b 96 9c 1d cb 5b d9 7a  |.............=
[.z|
 00a93ff0  f4 46 62 60 a3 a2 10 23  1f ba a9 6c 1b 40 e2 61  |.Fb`...#...l.=
@.a|
 00a94000  1c de ef d1 a4 67 de 38  3f d2 70 68 9f d2 44 43  |.....g.8?.ph.=
.DC|
 00a94010  c9 32 c4 8a 48 b2 0f 9b  d0 d7 12 e7 4b 67 25 f1  |.2..H.......K=
g%.|

Again these are "read aheads" of 104 bytes, at 1024 bytes later into
the file.

Noteworthy is also that the last three nibbles of the corruption are
always the same (xxxxx380 =3D> xxxxxf80).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-29891-1274304548-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv0WCQACgkQ7b8eESbyJLh/sQCdHLMIQoHNyG/ZK2p3fsTY0cR0
kNIAoKNE9NIYOzY3Rs4E+iF8y7VEe56W
=13f3
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29891-1274304548-0001-2--

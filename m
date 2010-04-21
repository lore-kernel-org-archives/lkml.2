Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0DUCYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:24:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45806 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab0DUCX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:23:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-help@sourceware.org
Subject: Re: mprotect() failed: Cannot allocate memory
Date: Tue, 20 Apr 2010 22:23:52 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.33.2; KDE/4.4.1; x86_64; ; )
Cc: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>,
       linux-kernel@vger.kernel.org
References: <201004210105.20942.pluto@agmk.net> <201004201917.23286.vapier@gentoo.org> <201004210144.18954.pluto@agmk.net>
In-Reply-To: <201004210144.18954.pluto@agmk.net>
MIME-Version: 1.0
Message-Id: <201004202223.53664.vapier@gentoo.org>
Content-Type: multipart/signed;
  boundary="nextPart24001650.QfZFFvqinF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart24001650.QfZFFvqinF
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

On Tuesday 20 April 2010 19:44:18 Pawe=B3 Sikora wrote:
> so, let's avoid EF and run following test:

good, the info is useful now

> mmap(NULL, 4896, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0) =
=3D
> 0x7f5fd97df000
> mprotect(0x7f5fd97df000, 4096, PROT_NONE) =3D -1 ENOMEM (Cannot allocate
> memory)

since you're using funcs that go straight to the kernel, this most likely i=
snt=20
related to glibc at all, so sticking to LKML would be best.  the next step=
=20
would be to look at the linux internals and find out why this is failing.
=2Dmike

--nextPart24001650.QfZFFvqinF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLzmG5AAoJEEFjO5/oN/WB3WQQAJ7B32nzA16xauKQ/STiD0VW
LuWJiK1GMzqzsoDdvfGjJnkT7IrTt055ybYZDZNOp9p4cST0xoGVjoznfBxkfjpR
FtNbMqNS5pyP3X5mmx7vz4URzdcblPq8ofxmMkn94WYIKu6TtbPVY5MOM5cBoSQq
Up3HvGizFCXpJRl3u9q6b7hpSduspW85cD+rD6LuNekiyKLGg/cDCGQwWd75fyi3
2IMNT5P+Qrj85vUERRhPUQzE99wvJ/69d2cvhfBp/xYXR08UysVLlA0iWz/gHrHw
aiwXBeV+ux4gG53APLwXlXWAnItU6+SEDnr3ICpy40sOytd4j+HJSOZsjpG28V6K
IAcHbJXTp6MhhDyx2oFt33WUVmIlROL6Rfj2AqKI73tnUmAHvT8zJTDHL4TlOK6i
dSA6Jnh+dcGnt73TXo0zYyLKxpq+bNgGqwleFG7emQrN+BoKA46Cnm1/p+PWTKcf
0dBMC68UJJi69IzfW46hNWDEIhn6LHA0jDQke8d2kFOr565tDtDoCMFIfiUn+H+/
UodLoRwTMS83diwXkeo4QR3luNcx6xvysbY58vuJQlj2hsRINAPuNXmD+YR2qbxO
iqpnRRsSnNfCS/1C32g/p4jkqwADNeChMbeUNhpR2EER5ykRTiO0Q35zeB9lwaGb
U29nlN/9v+SaeHVnroSG
=93VS
-----END PGP SIGNATURE-----

--nextPart24001650.QfZFFvqinF--

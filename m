Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab2GPEJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 00:09:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47312 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2GPEJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 00:09:27 -0400
Date: Mon, 16 Jul 2012 14:09:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: build failure after merge of the battery tree
Message-Id: <20120716140917.f780e8c3c7c74f1db1fed0ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Jul_2012_14_09_17_+1000_O=aUB.UyR=.yZX8="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Jul_2012_14_09_17_+1000_O=aUB.UyR=.yZX8=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

After merging the battery tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `charger_manager_probe':
charger-manager.c:(.text+0x11d61a): undefined reference to `extcon_register=
_interest'
charger-manager.c:(.text+0x11d7b6): undefined reference to `extcon_unregist=
er_interest'
drivers/built-in.o: In function `charger_manager_remove':
charger-manager.c:(.devexit.text+0x8f3): undefined reference to `extcon_unr=
egister_interest'

Caused by commit bee737bccb03 ("charger-manager: Use EXTCON Subsystem to
detect charger cables for charging").

I have used the battery tree from next-20120713 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Jul_2012_14_09_17_+1000_O=aUB.UyR=.yZX8=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQA5PtAAoJEECxmPOUX5FEFxkP/1gIOAyJrcqFpdKdb7B5ztmX
fgic/uCjBS2WWlWbbPFORdUI6YoyhZ4/VLI+TpTvKoXxLdGzvnXkDuFhyAOVzYgf
9pofJdTMTa++BKhXsCPHMaSv859u8dW3dUdyXcWrRt4WLYjIFH+p1dhbvcvZomsA
x3iq6KWoUfITI6cEaZp86uwPXK31jNiWix1dNrNsYHhgxK0p0sIKkFy8KLYwIWXB
pjyhLFm2/UPWrKZguNL8bGQhHurEHV3yijLieiI0qpbVHC/SfpA44JOJwqF+cuat
CWPl605/l75dndyYMTICmfhbh4q1iW4B3acfKkcqoXalFo2TbvKAYfi14O91E7YW
BzKSohVMWdsFJkarGhrQaf1hi/711NBIeg/g1rKekQzANkZo0V3NDPKr9nAmgsDb
NzyIDiDiat32+ow4ECCHjEEhLNcQ2CNmKRVo6O6cEUws6TJZX0+fbHAgDy6X/d2y
j3wKDIX/A+zz1Uz9DGMS/WhhhH0PR8xbdjGMwf/CA9668s5ZNwYY9jrEO7JHnjSO
Hry5//kt7FdpU+cQKnpWCch5G1WWEdnFVXn9vsVyy/1WUF+vR0Wy8oh7xvETko2v
GWs7vuY/TyhhLRf8XgbsdE/RTDWvO21gZthDEr7p6dRwG9ryIP9PLX3nJKC83lHs
LlUwLn1r1cUHQSIDBkQb
=OB/C
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Jul_2012_14_09_17_+1000_O=aUB.UyR=.yZX8=--

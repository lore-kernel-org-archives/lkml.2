Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1GTBft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 21:35:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41684 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1GTBfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 21:35:48 -0400
Date: Wed, 20 Jul 2011 11:35:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.ab@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the s5p tree with the arm-soc tree
Message-Id: <20110720113536.72c28c19d623c5e7f8604ca2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_11_35_36_+1000_N1eGXAS9x+n5XZ=g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_11_35_36_+1000_N1eGXAS9x+n5XZ=g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got conflicts in drivers/tty/seria=
l/s3c2400.c and drivers/tty/serial/s3c24a0.c between commits 632b7cf6c056 (=
"ARM: mach-s3c2400: delete") and af0e060e24ce ("ARM: mach-s3c24a0: delete")=
from the arm-soc tree and commit 470805f8f958 ("serial: Remove redundant co=
nsole_initcall from s3c and s5p console drivers") from the s5p tree.

The former removes these files, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_11_35_36_+1000_N1eGXAS9x+n5XZ=g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJjDoAAoJEDMEi1NhKgbsNekH/AozUGu1mIZC7Nds36bX5pnf
E5AmQDDUGlR8EZO/BeYSLuhCjWrCUCVSBn2ItfOaBaSdqQInik2LMtPrMvGx9pZs
1OKGB1QQTBIa/n5aHi3anb7VAqwzhn6GSjDHqaIR5j+NbZ9fY3nHvFtVAau+Y7sY
dQuKrmY6StJharcmUJLWaGjiCYvAbqO1aal1yWz8rjIFnX8Dx4vbcXdugUQjA1B2
44lRQkdN5tNlVH7RPQCcSJAlF9dCCtNltMC4yqsRaJyIMUvp9qVG3d++3gIuv82L
X7vR+maOXgJYchFoJ+Rcj242xcWW4C2rDvnGzvnCltTTu7FEZLle82dVbx9hKBw=
=P7Ba
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_11_35_36_+1000_N1eGXAS9x+n5XZ=g--

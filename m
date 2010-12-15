Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0LOCJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:09:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36017 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0LOCJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:09:18 -0500
Date: Wed, 15 Dec 2010 13:09:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Shen <yong.shen@linaro.org>
Subject: linux-next: build failure after merge of the voltage tree
Message-Id: <20101215130911.e6edddfe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Dec_2010_13_09_11_+1100_brhEKw+zrebqvmA/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Dec_2010_13_09_11_+1100_brhEKw+zrebqvmA/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

After merging the voltage tree, today's linux-next build (x86_64 allmodconf=
ig)
failed like this:

drivers/built-in.o: In function `mc13xxx_regulator_is_enabled':
mc13xxx-regulator-core.c:(.text+0x9b01c): undefined reference to `mc13xxx_l=
ock'
mc13xxx-regulator-core.c:(.text+0x9b038): undefined reference to `mc13xxx_r=
eg_read'
mc13xxx-regulator-core.c:(.text+0x9b04a): undefined reference to `mc13xxx_u=
nlock'
drivers/built-in.o: In function `mc13xxx_regulator_disable':
mc13xxx-regulator-core.c:(.text+0x9b256): undefined reference to `mc13xxx_l=
ock'
mc13xxx-regulator-core.c:(.text+0x9b26f): undefined reference to `mc13xxx_r=
eg_rmw'
mc13xxx-regulator-core.c:(.text+0x9b281): undefined reference to `mc13xxx_u=
nlock'
drivers/built-in.o: In function `mc13xxx_regulator_enable':
mc13xxx-regulator-core.c:(.text+0x9b323): undefined reference to `mc13xxx_l=
ock'
mc13xxx-regulator-core.c:(.text+0x9b33c): undefined reference to `mc13xxx_r=
eg_rmw'
mc13xxx-regulator-core.c:(.text+0x9b34e): undefined reference to `mc13xxx_u=
nlock'
drivers/built-in.o: In function `mc13xxx_regulator_get_voltage':
mc13xxx-regulator-core.c:(.text+0x9b3f5): undefined reference to `mc13xxx_l=
ock'
mc13xxx-regulator-core.c:(.text+0x9b40c): undefined reference to `mc13xxx_r=
eg_read'
mc13xxx-regulator-core.c:(.text+0x9b41f): undefined reference to `mc13xxx_u=
nlock'
drivers/built-in.o: In function `mc13xxx_regulator_set_voltage':
mc13xxx-regulator-core.c:(.text+0x9b67f): undefined reference to `mc13xxx_l=
ock'
mc13xxx-regulator-core.c:(.text+0x9b6a4): undefined reference to `mc13xxx_r=
eg_rmw'
mc13xxx-regulator-core.c:(.text+0x9b6b6): undefined reference to `mc13xxx_u=
nlock'

Please build test this stuff ...

I have used the voltage tree from next-20101213 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Dec_2010_13_09_11_+1100_brhEKw+zrebqvmA/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCCNHAAoJEDMEi1NhKgbsvtwH/jYREgBsm1iBLyyn7fvy+/oi
J3Fp+LTkUGt5rCZW4hiZNYSo9ZRW8zsCL8NGuenfIMeNHX+iaiCqevY7mRW2Y1EA
R9Uw6rK4Hd9EoVPHpVPXB1p/aw27nEiRx6AzZAStRt0OxP+ejSfUy7qpogYwUSsW
B8NONrOhCBqo2s2WL+mALStyGwOTx+znBStzXAftlMEOcdKL78DADXuO/+uQ6DCd
+26vz//WPBY77u2lm6pvs5qowlvlzZpULlIaDdGrGkU5sJzEA91b6CLNuwFNXt94
5Gd7unWIF+9hyfEow9v5oSqHR6NyaDEGdQmCXwpWLGP36rLGLpjo14jTIRyw8R4=
=uOqR
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Dec_2010_13_09_11_+1100_brhEKw+zrebqvmA/--

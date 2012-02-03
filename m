Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2BCCyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:54:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46883 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab2BCCyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:54:44 -0500
Date: Fri, 3 Feb 2012 13:54:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the gpio tree
Message-Id: <20120203135432.e9ab5f0d41805bff0df10333@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Feb_2012_13_54_32_+1100_9veh/wvfeF/W.YA4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Feb_2012_13_54_32_+1100_9veh/wvfeF/W.YA4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the gpio tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/i2c/busses/i2c-gpio.c:18:22: fatal error: asm/gpio.h: No such file =
or directory
drivers/input/mouse/gpio_mouse.c:17:22: fatal error: asm/gpio.h: No such fi=
le or directory
drivers/leds/leds-gpio.c:23:22: fatal error: asm/gpio.h: No such file or di=
rectory

Caused by commit 4f79dfb562c2 ("gpiolib/arches: Centralise bolierplate
asm/gpio.h").  Grep is your friend ...

I have used the gpio tree from next-20120202 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Feb_2012_13_54_32_+1100_9veh/wvfeF/W.YA4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPK0xoAAoJEECxmPOUX5FExMoQAICXLqtAXY7mLUb5ZLsKOs94
bSUJH0Nv7e8Qy2mG1pqqOEuUvu/7ajg60qOEI3+8cCLVEKZOvbNkelaNtEhmayN2
v9fOtysXASnXmyZTaKNuNgBUI8c5ZJuHwMbNK3q80nW3mSUDHMVtJ/nq41lt+yKX
KaBZo1z1FeTUQBmlWLMtBpVjOFCqEh0KfIEK2FLm4leiy0BrU762nJtjYpmWahWn
u25+A5LIKejKL3/fjJydjYaO7M4KhMenF+cgGa6kfC+VrVZO2TjEXEbxG++TJVA8
WFek74FTE0HjSh25phRRw6fTOYbIpqqDzkS01j0fEz1u7tKKMd6Th2yR2A4BPIBp
aG2qxIEOwp8xWYkij/7Onqx8wfEO7015ORtgiuM/cdkb/HuSSB0A6+Beuh+i01bn
EFnAMy406oAHxZ/vPfiedaqBsRvD+wr4KA02roc77N/TNGcioMZKuTfWrjS5FCxO
P3Ao8FD7/lrftuVMfm5kloXj/358agucrjdsA0134KHmO61XHwYoHZNZKcaxlxk7
EsxgmQf4OcW6BFj9Dv6Iu5sz8C1CYzRsBX451bu2OlagYTyhkZLHOtJ3iTJRR+5W
79vaqZER/0v+wG13Z7krCXswpqgoOWKFA3LIvLxigb+ojwXjbI8tgVd9L59frwoE
djAyH7ujfUhbsvFoiuCX
=xVKh
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Feb_2012_13_54_32_+1100_9veh/wvfeF/W.YA4--

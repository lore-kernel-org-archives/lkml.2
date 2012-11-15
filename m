Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423590Ab2KOEBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:01:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43260 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423543Ab2KOEBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:01:51 -0500
Date: Thu, 15 Nov 2012 15:01:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the spi tree with Linus' tree
Message-Id: <20121115150139.178644970192d226e73e94e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_15_01_39_+1100__RZVL_p6POMT3Oeq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_15_01_39_+1100__RZVL_p6POMT3Oeq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the spi tree got a conflict in
drivers/spi/spi-xcomm.c between commit b31659004337 ("spi: Add
AD-FMCOMMS1-EBZ I2C-SPI bridge driver") from Linus' tree and commit
0e312dcca718 ("spi/xcomm: Add AD-FMCOMMS1-EBZ I2C-SPI bridge driver")
from the spi tree.

OK, so the former commit added this driver back before v3.6-rc1 with an
author date of 2012-07-20, the latter is adding a slightly modified
version of the dirver with an author date of 2012-05-22.

I used the former version , please sort this out.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Nov_2012_15_01_39_+1100__RZVL_p6POMT3Oeq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpGkjAAoJEECxmPOUX5FEGuAP/1IfZVlwn2xqsDyAhn6Xxk4T
BJ/LoMnNxet2CT5A+IZltNRwoQBV2ske/Ke9aoK1p8fZtULgopg6VN2o8hmvi9Hw
v2gf9kk/ra5qIs3WAS8FbXa178Dcj1jWIlhY+j+o1pEXRnayDSUDuGzMX5/jPy6V
/tCCG7vOsFEhpnRlJljXqXqhER7YCRRSYnk36fPRYiihrOY1OQX3+v1SGSYYY0n0
/iNy1ARR8P/k9AxvjmFT9XoVCtzUAzI0YOEDyAUR++ZuzuHzaHHc+wmslrcsKE6+
08MrQp04pu8dIe88QlmYJGNgx3yekydPcNLUtArUT8ew0ZqJjVUQOvjQS+ywSwsU
eKL99Evyba+ThaNiThSxHf7LgCISFuHrW/yaR00wxa9GuAohK15gxEtG0HnI2qDx
CZoC9UYd/VXxw97tGiH5H87nB5Fj9AkvsPGQbhdkfmCMsQoTtytdbQewtKEbKsVO
107ocIbJNi5tUiGPshApgjo64DvSouMIC4KSruOVE5BdPA9bJ05VFK6EC8XqJdNc
kMqVZr4dJh0E7mhrvnZQDUVP8xuODy4EkGPfKsqNfXHm47I/Vcde/HdfC/UQVets
9HIlABjSLRVYrD2Svvc8WeE/u+YL/mxMcKxkJ9iCfCQeTosdNETojTfAME+Nzldb
lYjm/0SNHsoSPODAqsyD
=M2oX
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_15_01_39_+1100__RZVL_p6POMT3Oeq--

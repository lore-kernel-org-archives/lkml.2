Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2DWFog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:44:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55502 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2DWFoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:44:34 -0400
Date: Mon, 23 Apr 2012 15:44:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?IlNqdXIgQnLDpm5k?= =?UTF-8?B?ZWxhbmQi?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the modem-shm tree with the driver-core
 tree
Message-Id: <20120423154420.09f149266ae36bb8e08b4207@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_15_44_20_+1000_JO9A3/RW7+Yd21FN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_15_44_20_+1000_JO9A3/RW7+Yd21FN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the modem-shm tree got a conflict in
drivers/Kconfig between commit de55d8716ac5  ("Extcon (external
connector): import Android's switch class and modify") from the
driver-core tree and commit 021fd6178bcd ("modem_shm: Makefile and
Kconfig for M7400 Shared Memory Drivers") from the modem-shm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Kconfig
index 0233ad9,918e943..0000000
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@@ -140,6 -136,6 +140,8 @@@ source "drivers/virt/Kconfig
 =20
  source "drivers/devfreq/Kconfig"
 =20
 +source "drivers/extcon/Kconfig"
 +
+ source "drivers/modem_shm/Kconfig"
+=20
  endmenu

--Signature=_Mon__23_Apr_2012_15_44_20_+1000_JO9A3/RW7+Yd21FN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlOw0AAoJEECxmPOUX5FEb68QAJAOvqTfCD5eqXwUI9jjd43J
NN2Qfz1htHKGHJ53A9JK5lt+DjrrGziB7fXaqtpkNjJsaKJXjx3JGmToyJTwQE5x
OgkmOfvLbWmYFGipMWEZhBAfS/QPrmey17nB5vPepA3UqPmXWMGPYSvkyoMBtofy
eX9PAEF1e+ZW3ivST041poyPsc+l0eh2uTsU8T0hHRxO1b9eOsGT4CA6h/w+P/g7
bGJeCs6VBryVAyrFS2kZMmQiZTQSjg8M3T6z8EHTMishdJchDVsTxg15vN3mS+M3
jA8RhTdRkwbtQ8KpwoJ11gO1cfIkG3jQsgd2AB1W9CaQscEbKI5igBlf7tawLlGM
A1SwnagKRyFioaSLft6OMOa934Zy8+1IT0mEzz3COo6kapvQ2hCoBpkkobDFq7gk
xYnaFPfapY3v5Rz3an/NdMCIvSyAkpCb9Fib0ujRSmXITNC8VF+k7luAsd8TMV0M
gTRNy8NQRw//gyAufPbnYhkd4OsAwhUCMyJNprydBh853NDqDfKiuF8rQNpxWoa3
an5LNjEMzSwu8I/qm5rTWwtShe/TCiTiHqwxrtBKGSQcZd+VphYfYE3Jfz/m0b7F
/CPp+Hmhe2T5bq9UcuIyNkhvPrqMzdAuDMr9oPpVQHj4ZdG8Mn8+iGAV/53FyQe/
/dX6Dot9RQrSYguRicGv
=dX0b
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_15_44_20_+1000_JO9A3/RW7+Yd21FN--

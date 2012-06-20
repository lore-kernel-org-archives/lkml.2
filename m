Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2FTEu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:50:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47190 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2FTEu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:50:58 -0400
Date: Wed, 20 Jun 2012 14:50:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kim, Milo" <Milo.Kim@ti.com>, Axel Lin <axel.lin@gmail.com>
Subject: linux-next: build failure after merge of the regulator tree
Message-Id: <20120620145044.599244256884c96a9131a06f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Jun_2012_14_50_44_+1000_=Ua9StRMGkj6r7eX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jun_2012_14_50_44_+1000_=Ua9StRMGkj6r7eX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "devm_gpio_request_one" [drivers/regulator/lp872x.ko] undefined!

Caused by commit af8b5fc31099 ("regulator: add new regulator driver for
lp872x").

I have used the regulator tree from next-20120619 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Jun_2012_14_50_44_+1000_=Ua9StRMGkj6r7eX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4VakAAoJEECxmPOUX5FEJuEP/0zipL5+ahm1YL6G1j/TguM6
sBMzMMCVEBRE0oAeiZVO5xS3NknuRyoIhpfuEBQYbJr09NHDzaK7jc12uQqSYrg5
To1bmd9sTcjL290g1QThp9lh/Yw4XsehI9NwY6rfz6rUyIBc4WUkyrHx7jYQ6erz
NFEx6N31uGZtHVZP4U4ncUYR7HH/t+2r/zqvO1TN9SmPkY6F9Ey0d51Gz1p9ApP4
dfOzf9x/Q3jHOQXKG+flx+usj8hRMMKVMH1D7FSXTU5Cn838/6oBrJFfMiQkwjsa
HFFBHxoZWn2fL0pPnU8yFEC1YXc9KMD6Yz9kABtT1lNfXWH7+n1+qOKa/sfLlSCW
J+0uXMIldCuuG92rWT5g+cpou46JbX3XlPuuCbJSxGx8HvCebV2kneZyUp4KsTks
VJhL2SaDMXEYk2IpoEx2O7zDXTFa9Gw3dPE4y9Vh/XD1tQ1pIrXl5KPAQ341a4vQ
P015aIZEzgR9Iub/7ZcFiA4vpsfbdrXDZlUayQmVGzv01BZHJTIdnJl/AC+dbfDU
H+fvP32B2VxDkVOp3JElZRPJbaMNUTi5n6ISCnoTwjRyXtx7lsuJmlP1FbX9zxo7
1j3ljFWHOvhcUgDazaTHpHkcBsyGmYOTB/Zz956qa8jIcepuVX4cyFm29Rg4oAfd
C2O2datIOtL+vNkIdu9y
=GV0r
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jun_2012_14_50_44_+1000_=Ua9StRMGkj6r7eX--

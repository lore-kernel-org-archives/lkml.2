Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2JZDYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:24:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41051 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2JZDYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:24:45 -0400
Date: Fri, 26 Oct 2012 14:24:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the gpio-lw tree
Message-Id: <20121026142434.00b97d865478dabafbeb2c52@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Oct_2012_14_24_34_+1100_eCA=scwuOz.hKVRp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Oct_2012_14_24_34_+1100_eCA=scwuOz.hKVRp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/Kconfig between commit a3b8d4a51357 ("GPIO: Add support for GPIO
on CLPS711X-target platform") from the gpio-lw tree and commit
4a8355c4c34f ("ARM: clps711x: convert to clockevents") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index a7c541e,d9b7a84..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -366,8 -364,6 +366,7 @@@ config ARCH_CNS3XX
 =20
  config ARCH_CLPS711X
  	bool "Cirrus Logic CLPS711x/EP721x/EP731x-based"
 +	select ARCH_REQUIRE_GPIOLIB
- 	select ARCH_USES_GETTIMEOFFSET
  	select CLKDEV_LOOKUP
  	select COMMON_CLK
  	select CPU_ARM720T

--Signature=_Fri__26_Oct_2012_14_24_34_+1100_eCA=scwuOz.hKVRp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQigJyAAoJEECxmPOUX5FEpE0QAIoMOAY6iIkNO8auCAU2Ts2z
W/oC22jtFfs+reIg7cSgXdg8nAQE/b9eQXigxkre06OLJDA/syT7k0bkdseCj1+d
/ptOc5AEOEbJboNp/86rHr4aOK+InJS8bMHx32c7lNH8l5LegVwaT6D/4hHid1Ae
89y4iZ/uW04+PgLhweUDiQczdmjfFOmbxbhbrmhj3HH7nysXjHZ6Sa6rozrIIv99
CuYcJgi+ysgo4n4WoF5pr9lpCp9n1wI0BIcT/0D/Dm7o03Tasa5/H104Z94u/U6a
n4FnGp340e8q/Wj8GMJuD5vinolofT1kj8wxGstftxzwuR5ZurD9i1D7EMXjjv7W
Y+GEX8w4MJ+WASKC7iu8Quam2zIdhCd5v/v5nqAXBYsiFUwKmtpItbHRoSS0uK0b
4PoTaz76CUW8vooyxe7tcQfGLMuUjBWt3PMjGmCk6l51wXh2o/JMIS6JDwLlZAfr
TYrMpiTMn9YsC0Ezzwj34xC+OJCFHkMdgYUlUmc3YQEb6pNq8uyTvN/c2ypwKdDO
6rV2T9jkPJUAoIKOg4YSRVMkIsRQZ2Q54sHjwkDGdbtUnoK1wFtcTjv0vCLtzV44
Qwr7TGh4xXPo5CpYwIJJ/w2yA7pczIYVTyDhW1zC1Ax6hU7rprVrWqrXceegARVV
wO0Q9H28ttg7EkSuebiN
=UoiV
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Oct_2012_14_24_34_+1100_eCA=scwuOz.hKVRp--

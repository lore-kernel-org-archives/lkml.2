Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2AIBzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:55:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54914 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2AIBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:55:42 -0500
Date: Mon, 9 Jan 2012 12:55:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20120109125531.dbcac0481adb6376fb7e9ca1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_12_55_31_+1100_eFFWKWBK8eN0bjDw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_12_55_31_+1100_eFFWKWBK8eN0bjDw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (powerpc
ppc64_defconfig and x86_64 allmodconfig) produced this warning:

drivers/misc/Kconfig:212:error: recursive dependency detected!
drivers/misc/Kconfig:212:	symbol ATMEL_SSC is selected by SND_ATMEL_SOC_SSC
sound/soc/atmel/Kconfig:9:	symbol SND_ATMEL_SOC_SSC is selected by SND_AT91=
_SOC_SAM9G20_WM8731
sound/soc/atmel/Kconfig:18:	symbol SND_AT91_SOC_SAM9G20_WM8731 depends on A=
TMEL_SSC

Probably introduced by commit 739be96ab837 ("ASoC: Fix build dependency
for SND_ATMEL_SOC_SSC").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jan_2012_12_55_31_+1100_eFFWKWBK8eN0bjDw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCkkTAAoJEECxmPOUX5FEU54P/3VbQWqD5fxIF4Nkn/C2Gygl
L5LMOMqAL53u1fb0VzjHChkCijYbM4+xMXgMozYHs6mGqtyyC+1cjO/sZNZtl6CS
XpXNt5RihMDE1zxyLHYdhbRm+Itry3sn40ZT4ikw3VPKWFTxhOdNh6DpVHHlM56V
TbrTYvp5agegd57I8Mm6I6m6Llha8EXR1k/D/BkATgOXd/GkimjeHt4MoNvVm+YA
vCL7VqaelxxE5t0M6nGLlIhKaRRcXuJvEurnpbyzjsCT+TXhOYY/oyML+00eEVgp
2tOnlgblgknS7sLkFT0KGx4zRCYZ7StO3nsY0UYoP1dgDhyMJlOiQu48+zXm4ilk
8w76uSZwtRphCQ+MGFm0ijvyOm07QFRDtz9AqEh3jmuBb4LhuTrQVMRWTwmD+sqO
rd625FNa6lt4nVbI49aHO0e83TsCRI8Mk9HJ4EKP2m/dOYE3WYMvvtBmiy2PLpue
LkJawkc7bN1YcXWgVEWA23kaXGDj29Jl7iV2tZn4kzcsjYaeGx8gjoVLp7ShJ00J
h7nM3bLdmhXfKu7ixtftUq+abTEeiixfmMaLhNr7VCs4D8zRaFQ1/K0HMbavQm5/
mDTKfpbGM7x6rCHeL50Liptrxjc6lPyd2lSPdVhEY7fEensY2A/DJZMwzwOK4K1j
EHe871EfvfxCvHDFRqSp
=giaY
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_12_55_31_+1100_eFFWKWBK8eN0bjDw--

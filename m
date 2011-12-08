Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab1LHENg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:13:36 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45157 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab1LHENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:13:34 -0500
Date: Thu, 8 Dec 2011 15:13:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?IlNqdXIgQnLDpm5k?= =?UTF-8?B?ZWxhbmQi?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the xshm tree
Message-Id: <20111208151322.146d37ed76b5a4fead2a6e03@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Dec_2011_15_13_22_+1100_9LV5GW2k+1kYNG8S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Dec_2011_15_13_22_+1100_9LV5GW2k+1kYNG8S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xshm tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

warning: (XSHM_CHR) selects XSHM which has unmet direct dependencies (CONFI=
G_C2C)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Dec_2011_15_13_22_+1100_9LV5GW2k+1kYNG8S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4DliAAoJEECxmPOUX5FEOicP+wWb93rBBDIP2tRYu9HR15A0
m7vXnOIbmvmY9ISGEOafhqQws0bqrDTM4tGticdhHUhuqh59l/UJFejIgM1Momyj
s2QtHMu55AlJz9nPwSXh3XVwelcg5xmNfvcJkWySc+llJhDWfb4PmGl9NeGFp4qf
2ixJun+1uwD4lIOdWOPaXiuoqx0ENDS5oQUnz50o09NtcHiVffBcpVceBLCrY7Od
n8M/c3dyQiObRhHI5p3TlffuO49iINXnWB5qaSpVSStETScO6cqgokx1W472eiLd
YKNA3aVTLsRAcFRS4k/fv7PsaWt2UEoWyPUJuIphPaEpQZI0lAmdb25xHZxB58cD
bOG2FoiQcfTN0pXjOwdUlZpx/fiq9iwyGpBtZvnaf/Yrb5UERn9N+f2zSzRMhusw
tZ1CT8dDVzJbX0LpLlWWD+2o8Jx9Fqm6s0fEBuXDLFLZSo0KhWlttSw3WN2+bMTH
zV+/Zp4anSZ793d5q3kLdorMOALcw6LVEqyourdjdeWtrTWY1Z+kIU0frIGaJNRf
MIv7ciAWryda5Zcb+OKSp3cDTXzxrv+lAmDRQYZFXU9OvbUIo/mnvFkvi0A0lypT
as8Ud8idL5Gyt9R9oTJkfzbRwOqX7gK8nLWqCwgx4kOXr7rfprWJjSr31az7ykha
yLVtEAuEvRU9kHs4ZAOC
=XvfX
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Dec_2011_15_13_22_+1100_9LV5GW2k+1kYNG8S--

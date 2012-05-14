Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2ENIIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:08:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57456 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab2ENIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:08:41 -0400
Date: Mon, 14 May 2012 09:08:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, paul.liu@linaro.org,
        Richard Zhao <richard.zhao@freescale.com>, sameo@linux.intel.com,
        shawn.guo@linaro.org
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120514080835.GB31985@opensource.wolfsonmicro.com>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
 <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
 <20120514035137.GB20367@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20120514035137.GB20367@S2100-06.ap.freescale.net>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 11:51:38AM +0800, Shawn Guo wrote:

> From what I see, it's reasonable.  Then the immediate question I have
> is, should we remove "struct anatop *adata" from anatop_read_reg and
> anatop_write_reg completely?

Given the way these things tend to go it's probably guaranteeing that
your next round of SoCs will have two register compatible anatop blocks :)

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsL10AAoJEBus8iNuMP3dQ0kP/253lpwpSw3tTtNNWCPON0QI
Cq4DV/lsxxU7CoJKp6jPDItKSBZ2yawpxP/2aD24S7DBnRX3MnArJhbqjjX9dJjB
dQdn+B5w57thiYpBNfh6HnnzifaEMIGeOVMC5et33Sx/mmzIbS8JCFHwDtGYV7dE
kwiRkb/yUsy9Oko7MbussUT4NiVJCQJRybILuMR1kIDh1o5hChaQFrR1xFQxjwyP
VKLbWcuq9Q9EG3miKjYdIksfRYmDPxFZZY4FI1t/aaPM+EYOBoMGCUUENSgyMchQ
NuMDIS8/X69/im+Lve+6qpa7oVuzplsncjRfIiq9PmB148fLgZD6kmMpUDhgUfoi
2qJ7zlJ4dyi7qiGZsp4cpQPOVXP3My6Jd9oEIB5Cj8ClhNFBvQ/ts41uCMKxksVO
CuwZf0cvJLPnTEekQDonKAN7y94/CdOC9NQGdPrvXIHhfWpPYFobQmiq+9209CLF
gPZpRqPdQMt0JPrvaYo2lizpq83wLOJfptkT5nDKVdH/44dDkDBUGRli34D0J3Ik
9kON/NCSHiG5b2M5TwmGOp2hX91mkhO9WWbYxTRxFF0xbg+G4c2rB2As3Mx4QhsS
wQyZAhROPrZSQjUMMoBBoN8LjMp9B5nSGVXdNSQrg1rsD8nHKNFrqLH7b2IKBhzk
Nip6Q4gKyZAWyMddNq4H
=Y7im
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--

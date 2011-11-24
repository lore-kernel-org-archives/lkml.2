Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1KXRVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:21:50 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56396 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab1KXRVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:21:49 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/8] firmware: Sigma: Skip header during CRC generation
Date: Thu, 24 Nov 2011 12:21:57 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <1322138908-32127-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1322138908-32127-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2215194.Cnroy5tqst";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111241222.00189.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2215194.Cnroy5tqst
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 24 November 2011 07:48:21 Lars-Peter Clausen wrote:
> The firmware header is not part of the CRC, so skip it. Otherwise the
> firmware will be rejected due to non-matching CRCs.

that's because you didn't compare to the right value ;).  include the CRC -=
>=20
compare to 0.  omit the CRC -> compare to the CRC value.

including the CRC and doing a compare to 0 would probably make for slightly=
=20
smaller code ...
=2Dmike

--nextPart2215194.Cnroy5tqst
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOzn04AAoJEEFjO5/oN/WBoXcQAMaYc+cLzqK8KNEgmh0Y7H72
1hls+trsn9gZNBK9ewv3xiYksSnEXocm3aYxXJ6lcmhb7ZgmpwLtSPtyK09t2HdD
VkRMMCwQm+soSBIB7w/PfnR4IkL0GSZN7u7UIRFxxSk0KRe4DaoeEQja2HPC9Om5
5CCx1KAweZ+XbxR7fsytOl5zhAYjlVRCfw0FHavyOO1y2jhVMBJ7H6Sev3EkV5xH
et4otpPrxGNB28F5yzdkJXWZoUPz3nzP6+xfI95rRNT3SDDE+JkhRuFK3FsDkQsv
/pCeWpp/uZX+hq2/JAFgV3xZFVYfA0XMWQMPz9zJKXyqPxxBcCg8urPFx2483+1h
fj4J/jga0nuzuPef7JXdS383DYBh/OIDkiAPd8H6e/WN016mCUHSTXlhGgBMb3Id
YnP/QQqgFPNO7slAj8Co/fWUUASYOC07vY0wdVJWG87EOt+txr/rPTDz0jsBU77H
mheOfnGG7FQG5uwbcsyns2VDiJVGZKfF5PW7aPis1AsnwGxYFGZDnL2TNjKFEpIQ
Fc/MfRI0QZIX/foVIEzU4mk6Mp/O6xcqcefoUANEkXCSuoHJZAaJvblSa8Cu0xZN
JKx7Sm/SQgjFEK2Tj7BuzFYneEKCrz2a5onzaZvooN6Zx4Enzaf79SNehnzt7dEk
PLVCMLWAe+CN9dJsnxqm
=HD9I
-----END PGP SIGNATURE-----

--nextPart2215194.Cnroy5tqst--

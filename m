Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2FVJSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:18:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47698 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714Ab2FVJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:18:17 -0400
Date: Fri, 22 Jun 2012 10:18:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: tps65910: Remove unused min_uV and max_uV
 from struct tps_info
Message-ID: <20120622091814.GG4037@opensource.wolfsonmicro.com>
References: <1340275546.2922.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iamKNtDj9HjMhSdE"
Content-Disposition: inline
In-Reply-To: <1340275546.2922.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iamKNtDj9HjMhSdE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 06:45:46PM +0800, Axel Lin wrote:
> The min_uV and max_uV fields of struct tps_info are not used in the code.

Applied both, thanks.

--iamKNtDj9HjMhSdE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5DgOAAoJEBus8iNuMP3degsQAJKxtCTrpS4iLzqS0B5YEAn4
kuA25sh8bWh/DMYd2r9jdH3V86LdJfbe3/VgsIn/prKAY2EQIFTQoovAcV3sNWP0
hD5hrZvQF/etV4osY2WATPAeA76rdsE63KKSIPgBx+rzqzNAtlbljvMZPP4zK6/G
uiwKOSthqc/xEVhg8733ufb4rJ+8q/ut4C9yiDm2R9bORzcTMwny8RCsUpeC/Qvt
tGgdQOJFFi5HQN1VHHzVFEuHulV6bcrdjTJQB2S9YihUtHFVBbwXvT9XD39bGNwN
bWrSuPSkITSZwLpky/lpXW2IBuNC4zdXbB7QdrlW1BtEORW3WfbyfxeM0rI+mMvh
CJVf8R0CSPAg+wRRpug671kwu7WzRcASs4ysZMEsJMBm5q9Y94lbkR+Zicu43vDm
bMo1XkgTRnQp8qAq7wZMxCD2ZiAQybO2eO5cej5tOMRtFelticZJExpTOcLfZreK
1ylkCo1pXjjS12l5I7qXc36MPKyf+HpQY4lLR/pXVWPclE88lAImZtiJ7slkCFOc
0Qe4OH5VLc1q4CUaSTM4yKuz5OUwApzvQSB8IQxBXskfkmsTAaUt2qGhDzNPYEBW
Vpq2VjG/l6HvfWZpOenGSp/7TX89BhPcbRxWqFlcsey9W8Cmy/uw8atengYTgJ3A
c2TGtGwWkFqULE5Vz7up
=+KeG
-----END PGP SIGNATURE-----

--iamKNtDj9HjMhSdE--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab2FRMwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:52:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51534 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab2FRMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:52:34 -0400
Date: Mon, 18 Jun 2012 13:52:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, "'Liam Girdwood'" <lrg@ti.com>,
        linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: Re: [PATCH 7/7] mfd: s2mps11: Add samsung s2mps11 pmic
Message-ID: <20120618125232.GO3974@opensource.wolfsonmicro.com>
References: <067901cd4d45$a949f150$fbddd3f0$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NT59pYSnj1ZLVgEN"
Content-Disposition: inline
In-Reply-To: <067901cd4d45$a949f150$fbddd3f0$@com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NT59pYSnj1ZLVgEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 08:29:45PM +0900, Sangbeom Kim wrote:

> -struct sec_irq_data {
> -	int reg;
> -	int mask;
> +static struct sec_irq_data s2mps11_irqs[] = {
> +	[S2MPS11_IRQ_PWRONF] = {
> +		.reg = 1,
> +		.mask = S2MPS11_IRQ_PWRONF_MASK,
> +	},

This looks like you should be able to factor this code out into
regmap_irq?  Might be worth doing that first before all the renames so
that adding the new PMIC would just be adding some more data.

--NT59pYSnj1ZLVgEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3ySCAAoJEBus8iNuMP3dTw0QAIvQ8H9ZZtDDw9k3Fl8ccACE
cj+HwNqaRLB53iiUa5H72LA3v+VBwnfzQTXJcD7bR4JyQK103Sirn9FjUhBt7VgL
NXIMA+1Q3bd21KYVQFk2UU1pUVEbqVfhdfQ0utWvRON+cHMthmPHiYG9LavwXg8U
udIJ4kBZG9J5EBrYpSe2169tFJPZUBUdxxHC5x8SkEYtBUHVwH8jVbPnl6fkNbpJ
cWOR1+sjbhF6kBwEtOB1x1izqMaYHBS8AxdwOwnn2F0HYVZSy7CLrxk4rXLfYkYy
m+UoF5UhRn8U3+aWgRI5kaiAIaEbTU6T/MfZu93KBBtfiKgu/NiGqb1c4KRwduBX
BHNklrC3Te9I5Y5Xu1UFl3k9Pax33v8HqHsM85bk04Pv9OILdHAb+HgSJYgz1jiF
Fw0+l5/yUcv/S7itOqmnqmOBbxcISmb1Ii3mq8x4p+BtgE2t1ep6ne+XwXftUUyW
FFSjbEOJbEpeZBlFixtXC2SdNDReC7rQ6Np3w3vWahhOjOf1OGA/X+QUA6mda2Ca
1PPL0iGydF56L/6kKDMEjenw0UzGjEi2qi0fwjUx1TgJXWAzgWCWupCYWTxLu0pq
BU8OnYq+9RK/pTMdcOKDbwMU7THF4OVBOWhTMDUkVDC3sCQu4KdJluHnn1wr2PrK
5oly0WwWWlAduKkUCnRQ
=wli/
-----END PGP SIGNATURE-----

--NT59pYSnj1ZLVgEN--

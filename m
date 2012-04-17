Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2DQNoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:44:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45748 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932338Ab2DQNoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:44:54 -0400
Date: Tue, 17 Apr 2012 14:44:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8660: Fix a memory leak due to missing
 devm_kzalloc conversion
Message-ID: <20120417134451.GE6652@opensource.wolfsonmicro.com>
References: <1334657210.7265.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Content-Disposition: inline
In-Reply-To: <1334657210.7265.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 06:06:50PM +0800, Axel Lin wrote:
> commit 4d26f7 "regulator: max8660: Use devm_kzalloc()" missed to
> replace kzalloc by devm_kzalloc. Fix it.

Applied, thanks.

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjXPHAAoJEBus8iNuMP3dc/MP/0DofGws4m5ZjbaB594got85
8AVaIZ0TxyiEPxc+dKFYlj2jaa4LGrizXPKzT9X3i7Y2PEXsbFdN2/3x8BKLsW8Q
HmZKuHSb6zzEA6H1U/L3iF4H+w3kiHOsVqFPNhWgR0NnFl5gRe9YYsadAER4K5Gy
hwSR0KNtdOjUD92it0SyLRC5eNyeHDarOc6TOZEtCAyIqRE7VfnUy2UOkQFuY5SV
yyNiYTATLyUsvwUpPrQZyzN8LVkyXEAoI2mQVtBoiskAj//oQOEMJdXkx1SbwHHj
1f2u+czutvzS4Cf1nGFLZ1TZVax6lyiMuD5dTBRqClHOcysdoP/puk5XtYwJYF36
57GNsnYK+x19OZD05fcQ1F9mdn9LPWOeu8PBIFkYF4U9d124Q02YInOcAVYu9eEG
aQdjMcGRctBoM6NNDRkilVFmYHjfrau8aHgeW3iL0sGhDP6o11+gfSGUgUUNW3fy
djd5Cev4yfQBIaFSV2JIG6MsvWagpQ2HQaGaDR0xTS6yJXuFHgnLImqeIej/PjN8
07It6aI8cdc5vEFCPmwgvq+5Id1qqctSkSMwd0PNwqXepuI2CGvDlmwh1OnoxHOk
v1mmDIkvmouJp5mhChwtIjzEqQz6t633ghfVAYLp4gzBiYUA1u2Aa91BiqJyLhj0
pDVj/aGJsjkY9xidY0tr
=Qnc/
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--

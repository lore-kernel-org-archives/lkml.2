Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2LXQZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:25:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46346 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:25:08 -0500
Date: Mon, 24 Dec 2012 16:25:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lrg@ti.com,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] regulator: s5m8767: Fix probe failure due to stack
 corruption
Message-ID: <20121224162505.GT30837@opensource.wolfsonmicro.com>
References: <1355282820-18364-1-git-send-email-inderpal.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Dvf9Qz7hFaodvwE"
Content-Disposition: inline
In-Reply-To: <1355282820-18364-1-git-send-email-inderpal.singh@linaro.org>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1Dvf9Qz7hFaodvwE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 12, 2012 at 08:57:00AM +0530, Inderpal Singh wrote:
> The function sec_reg_read invokes regmap_read which expects unsigned int *
> as the destination address. The existing driver is passing address of local
> variable "val" which is u8. This causes the stack corruption and following
> dump is observed during probe.

Applied, thanks.

--1Dvf9Qz7hFaodvwE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IHNAAoJELSic+t+oim9AvoP/AqwtNeJNYSJxpg4jukdJmVl
TSG0Yaq1Ben2O3ssTWLsVhfoHP1ViLrramIUOjTA1TbcT2jMMGFkCAYiplb9nfgS
189uoGcz49/A1mKEgvjlFv4p8zokPBsqmth1zRyZNVEtSCYtnHsp5gSI4dqvPysT
Y4fCAt3f//BDlb7phu/H7lpg3LaFV4GvDguWF2av/lkwAleyQWd+d6MqSYGgNMEY
8MuCTVmc7lfGBCEqbTgSnxYSh56HEIkVe6Wl1eqk/XovP29fnIk5S/82bQr2h8xh
ITTG6J3irmc9LHCQbfPzfWf7XHt+YHObYDnlyfaZ68SEeDnyJ60JoEwPumA2Wr1a
OvDoTXFVHno46O53GFEQHvKoFix9ywqn1srqwAX/AqLYYZ/CqNi5acE5fdb8u9Ky
RXDnQ/70rPw1Jm7XOXqu+EwnE9QV3jKCTOe0aIYKGGI9bZsFz1OMBH0ofJFW6c0m
pDkeLbLP6YWAQ/bUCptfVN68LvJQ0UGZfuP1VZnnYUt+lXhikgmwKHn+uSsILqhj
NnBi5JBXd1b5Q2lEsLCCrNbvkoOeALE32pZd6Cr0tDgfAs9tAr1rc4M4nwJRyGKO
IafC7H6XqOFG4qQLp2uBRIv5E1amVXNjk3DAJxAaEoDEEXJXIdnQaGCMFVeqh0Kn
0AMeD7MhG1C7/eTJbRr3
=GnP4
-----END PGP SIGNATURE-----

--1Dvf9Qz7hFaodvwE--

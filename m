Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2GBR0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:26:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41377 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab2GBR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:26:50 -0400
Date: Mon, 2 Jul 2012 18:26:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: tps6524x: Convert to
 regulator_list_voltage_table()
Message-ID: <20120702172647.GJ25093@opensource.wolfsonmicro.com>
References: <1340202615.8003.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="07FIeBX8hApXX6Bi"
Content-Disposition: inline
In-Reply-To: <1340202615.8003.1.camel@phoenix>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--07FIeBX8hApXX6Bi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 10:30:15PM +0800, Axel Lin wrote:
> This patch adds fixed_5000000_voltage table for fixed voltage,
> so we can convert regulator_ops to regulator_list_voltage_table.

Applied both, thanks.

--07FIeBX8hApXX6Bi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8dnQAAoJEBus8iNuMP3dbtoQAJEyvH3J0kQQuVJBWl3hS36s
GswQLHTFN94aO+lKN+ubdcW/ch4MufPa28Rg+yoo3Avk1lGyYA1OeW0W8t3BAgdt
V14Q+X93E2HLTCuj5ZSq/uZ7FLkNctldPP+c4dVAbcyqwQSOcYIi2BPoMGtJ4+UG
GbSe8fw4vaJGAIxOkc8w00huXWOnTT8pfGfC1pAw4A9lIietbq8w82lmBT+cMHLr
tYepS74nU4blf2+2VDvKhqwgyb54FQiXp4yK144Dv6Y4V785si0Brp1wcPwx/V7k
QawJMyLn19srHath4ub2HQS6mdEgN76gIl6jwGXVslm7mdLP47dO7vik/M5Ov07g
ldY0dud9L1vKkAXOqPao1Dy3d1fL6xf6Hy8YaxVhKquXoReRvpETMoQLCoZFGZWB
kDLh5V/t5eQjN0CaDeW+Bdabpdqzngy/AsjIlF209vV/xG9f3WX1EdSmLRAEm5MK
APg45J9U/gZxneDFMk0n1TV336SNZ5delyRXGSYwsg0RloRpnykipVP5n53jCVPT
cOh1uXX924k4tc/fUuXmZIQ5vfc6QdZNXmHUhcpbIEbDWwVJS/h1abSC7nbZKg+8
2c7R8faXVVg6T1uoB6bktHfFaN5hnxmBIu8uWFFObPGF4s1PxHHWllf120D5M0B/
h+0DsHu/2pAecPJtca5W
=WBAC
-----END PGP SIGNATURE-----

--07FIeBX8hApXX6Bi--

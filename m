Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2JQHew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:34:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33653 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab2JQHev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:34:51 -0400
Date: Wed, 17 Oct 2012 16:34:46 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: vexpress: Add terminating entry for
 vexpress_regulator_of_match table
Message-ID: <20121017073445.GH14199@opensource.wolfsonmicro.com>
References: <1350435620.5718.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <1350435620.5718.1.camel@phoenix>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 17, 2012 at 09:00:20AM +0800, Axel Lin wrote:
> The of_device_id table is supposed to be zero-terminated.

Applied, thanks.

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfl99AAoJELSic+t+oim9iM4P/2Zt8jy6d2jJ59dtZkfeJuQO
rHJXDDbJkOBp/sTfgOGl/PI6V9tOzh5bu/bqvaMlC/U1MYrWsyObSyv4ygxxFmg0
Xx8d5Z4GvxWcDk5kj8z7IwTkmtXr7Ph0Ergn5o6XaWbjNyoxoo8Dzf6WRTdgY1at
DQ9vhHnpxaL6Q+iATaIe+PMc9ofj6K9aewC7urB2QH8BeAmqcrvEaQyOYoK6wdZB
Qoso4foAXS9FN+LoaIAoYf27fadhuLeH4oCOwPq5wEka0AYLiEE1oswsZ1nghQtO
PaOD7kYnj3g+yWOEYaQ+Y1qDYCIlaDTFH1tFnj5BuzHiD5XQGBB+Zm0PdbrmbsIC
m4/Sgtj6lFmvGdMdMA9uJThUHfUqmQK25+6CihZm+qAOVNxAd+9GpCGsI/R8x4x3
MYe06xXkHNCJFJgIxxTgvsANxJMsJHlpWjFrMTxgfP7zQvux3dvsGbpM7UNFwA1x
aeocKXEmk5oxh31uUzsvMbfhxrX2usehy3nbh2Wtsjdz75PR3VqDFVwSk1VZ8JRv
/ZrhjLbBZKbLqypxTiHH+osHx6jYWWMeuGgOwkSJXIVhQfMGB+AigpsZMc70otVN
P0rCC945j3zrABLCCsnIq7nMjsSNwtf7OM96dUG3iN1lOzE9SF40Upe9jCyqZZg7
DQznHIHoSj4j7qP0SM3e
=ELoI
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--

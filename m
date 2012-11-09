Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2KIQms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:42:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51789 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab2KIQmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:42:47 -0500
Date: Fri, 9 Nov 2012 16:42:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@nvidia.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] spi: make sure all transfer has bits_per_word set
Message-ID: <20121109164245.GR23807@opensource.wolfsonmicro.com>
References: <1352452005-13789-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7UIJfHqpdi+oBJdT"
Content-Disposition: inline
In-Reply-To: <1352452005-13789-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7UIJfHqpdi+oBJdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 02:36:45PM +0530, Laxman Dewangan wrote:
> When spi client does the spi transfer and does not sets
> the bits_per_word for each transfer then set it as default
> of spi device in spi core before calling low level transfer.
>=20
> Removing the similar code from spi-tegra20-slink driver as
> it is not required.

Applied, thanks.

--7UIJfHqpdi+oBJdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnTJ3AAoJELSic+t+oim9IwwP/3usqsl6LKvu5vDSQeCgZwcu
dPZ0/u5geVA+yypNAXGS6v0RPVX40JvxSx18DseRYfFCgH3JRN6rm1PMG8Z7VCfv
m180ZdzkYO1iXiFbEQILn4OhwWvEQAMWw51EF2qpD2qPjvo/Sq0S5U6bF7JLWIft
OOyA3cd7zJM4CDDKCuhrIUAYvOWpgrpVy3L7OCpD51cBWm9SPalTOE77kro2fp4/
lVK+wcAmCoXGfalpRUBY95tPzQ0FtaRo6N6XKV3apBmNL/24HzmO9FwgX1vcTMyp
wO4fqW/qV913cTbJ/c2Xwi1gJPxNbkR4HTiikNhYkcO1A0UYE6oB75+1389RGoKN
2Cin+LvNReNv/ec0rraA/1l415P697iM0yj788EI9EORYf/MItzXFjQBKQ2Z5D3/
2JYFGBh9lnoDiu1JnXiD9FHbc/V4zA6nlArkl67z8W0iskrxYWEds3YrSG22NyY/
9j5m4/0tsGhW1D3Anyfoeye8FcyzdIB5oRht2m5vxe1WnyY3dadPfmaa24vouMle
LDfaxhk2v8D5IhC5/WeNcraBSPKEGkNu3SUdlDy5N95OnL9OZBo5IdEQJip3B9AI
DElmAGApjg/Tuz4u9gzCu84n1JX/j8zfAhsR/onyztu3xrzsjKB1QqHPHpA/a1D5
5IhijB7wZfcgQWGtJMv9
=rBYB
-----END PGP SIGNATURE-----

--7UIJfHqpdi+oBJdT--

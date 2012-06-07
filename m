Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab2FHA5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:57:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58904 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057Ab2FHA5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:57:06 -0400
Date: Fri, 8 Jun 2012 07:53:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Danny Huang <dahuang@nvidia.com>, Liam Girdwood <lrg@ti.com>
Message-ID: <20120607235351.GW14525@opensource.wolfsonmicro.com>
References: <1338907926.5581.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O7hm+SMpb/lu0d4d"
Content-Disposition: inline
In-Reply-To: <1338907926.5581.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFT] regulator: tps6586x: Convert to
 regulator_list_voltage_table
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O7hm+SMpb/lu0d4d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 10:52:06PM +0800, Axel Lin wrote:
> Also adds tps6586x_ldo0_voltages mapping table for LDO0, so we can remove the
> hack in tps6586x_list_voltage() and convert it to regulator_list_voltage_table.

Applied, thanks.

--O7hm+SMpb/lu0d4d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0T7mAAoJEBus8iNuMP3dxacP/2O874o1FE3/ihkasb99/xzr
p/8vO92Qelviojv6DNbyVyihH9Sz4Ixvm+j7b2i+Aeu/NXczbGduT2YFkPQcPkEp
EvoH2HPdekIjEtjqD/xmYjc8dWslgEVfvy/8wKLpSJ8lCYDpuEKAz03tgbgTB6sb
NkT3NPpAMQESGiz6VFa9h7kcvkHdPzmQGjUbYY761ZGlZ3H/4ka+NVqBI5kWjX3B
KSRu9R5ziHu7c18g7b8DFw5NwONNsaf0LII60AixLURwW0Qxci74aqvrK+sxF4Ho
+6vPB39kqYKYeU3cgLvoV37qEB0OeF9ZzadMzKJTJOP+jMW9IVu6KryPv6Brcgij
iGE5vjAfhLueQqZzKOCm3eRyLd9oX/svY0uZtnamR2UQXCl3WW57NHv9UsFFgUzR
fGVPZ+uWONPk9kuYrWSnPoo+geYBwzqkPRUnZ6+YGQBNrUq4XxHqLdgCSI2bzRsU
JlNfvXPuKXNwG1417ebQqZDZjLGsYz2ZGquBC0uJsVbHhbgVMiWCJDh2EvoSCjbP
hokrZLrHJfwrDaFgDrU1JdlaZnYWNynu8eATE+MqP/SXPNtcGhC5oV7A0LJ4iFaE
sRNj9fumLCrv9/16naQ4P7dcZEZFE5NWzeyQ9+Cj6BJOPuKoN8yE0WO8+csXiAgm
4WNq3YjOOMHIPZX1F2XE
=b9zu
-----END PGP SIGNATURE-----

--O7hm+SMpb/lu0d4d--

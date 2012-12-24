Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2LXQb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:31:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:31:27 -0500
Date: Mon, 24 Dec 2012 16:31:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC/RFT] regulator: core: Fix continuous_voltage_range
 case in regulator_can_change_voltage
Message-ID: <20121224163125.GW30837@opensource.wolfsonmicro.com>
References: <1355275366.11924.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ByM1h5nouWwd3kz8"
Content-Disposition: inline
In-Reply-To: <1355275366.11924.2.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ByM1h5nouWwd3kz8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 12, 2012 at 09:22:46AM +0800, Axel Lin wrote:
> Regulator drivers with continuous_voltage_range flag set allows not setting
> n_voltages. Thus if continuous_voltage_range is set, check the constraint range
> instead.

Applied, thanks.

--ByM1h5nouWwd3kz8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IM9AAoJELSic+t+oim90YQP/0cE227B7EDkPusJUu+dI3jw
/jjq4a8Kzwlz+nKnaFdqI5KZqgYH2A4st2CfYG76yR07mkU6HVMcLMv915zkxLnZ
mNurpF+2TO3mmzEE0Mz3vTcRK9URXuO1ZYQEdS8ZvK4FTYzvG7qFfIE9PrNp/Ec1
M4rbhHjHL4oYspB1HBbsgVEFPb0QxNoKf8c408xVL1GiGNhbf03QegQ1Q7SNa2V8
2AbHKqy9Td+EocdDM0tKL7EiJD0hh/GMxDdh/zx1zNhh0GmzdNkXBfDSjbb2svX6
zm8+HlXyMHjtEQ2TMYwPVW8mmydDb2/aHZAD4HfWGoTpDZB1pfMoqV8UnX7DSRfQ
KyWpiaTsIDG9m1Ks7wD/tCT+0ZNZo4DhYNPKTnkgDt4+U4UzZam4RXO7J6iKUdOb
sUQNrwJTMkMINJRjkQ6AVE4Rj5XjBMnqpDALOv/skqW1Qh+Kz5X5KK6r33511fBI
Em7OrtcPK0O/atJQ3m+zeVXPVfdRZbQy1YsCV+8oc9nMmYkJlN1adOLTfjhSHwJ8
aSNZ7BgeJy3DfytvzO2rT0RgmYrtY8n+MQuJelIUfroqeVaXGiO0qHkvvtOjrHGS
PrtstjXKTMZziD1fkthvY/FUFeZODndpnBpS+p948AxXwisJ59utGSUZhhq2LBCL
GIMKqYU/xUxsr9iZuZyb
=IkEl
-----END PGP SIGNATURE-----

--ByM1h5nouWwd3kz8--

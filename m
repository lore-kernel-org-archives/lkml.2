Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2CIMe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:34:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab2CIMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:34:26 -0500
Date: Fri, 9 Mar 2012 12:34:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: Rename set_voltage_sel callback function name
 to *_sel
Message-ID: <20120309123423.GQ3273@opensource.wolfsonmicro.com>
References: <1331259740.6239.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="90KBcPA0h13nTGdQ"
Content-Disposition: inline
In-Reply-To: <1331259740.6239.4.camel@phoenix>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--90KBcPA0h13nTGdQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 10:22:20AM +0800, Axel Lin wrote:
> This change improves readability.

Applied, thanks.

--90KBcPA0h13nTGdQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfi6AAoJEBus8iNuMP3d5hoP+wWyn+qZI7J1TW1mYScmTVh+
RQgpgfWMRZTljoQMUxQgc7b5q9AcAW1MyRIPMG5JEDYb0aMTt1E6Za1HCAW4HxS4
/5Rr6vE5XGAa2xqFe+HUMBjkdoDULI+4XyI65YjcMggas4N7ItTN7gXkGl202xpg
AM1ixOQDrJI5TvOsaiL+gB5+mzbvvFxMy7D5zkEjfERP3MEcnl+R79f/R6FZFNqT
BUza+d4vX//FDSJq8SJHdv7rS2cMTGy+xP3+PbysMMl0vWzMu2rpWTIpCnE2pgpX
jkcgcWaW+n6VCPVVmQa4WtqpZAZPnDrFYUwq+Zt56W8pjhZFrhRlhnBZPjr+J9n2
Xl145L2u3ZyemYEU8H5+tYV3cO6ISs6lXCcQWVlFR56Tp3lqFn6wcKoUq2Pvm0YT
Y5gANuoaNDW0S+GaU3mJTk0X3jGqA7sMsKs9SgRAqoYj+KZeSHQNtiygcx/4PRaT
XkDTPzudthJIQTQix/nZoHw4tIRUQbhujCpP9qYc9GlDrC4I6DfiuXQeEoyv3dpd
laGl8n5XegJMa3iobAyqRFxl6QfcmkGhouHR73zK0YC6OOBz4wagJHFfR3N2dnxR
0KTgzYffA4MeCnkEhgqvhBpQvF3LCdk5vSvH3mqje9Lu+U4hXFL2YMsxaJBSFWK5
BFme4N8YGeqXZ87CGFfr
=L0dD
-----END PGP SIGNATURE-----

--90KBcPA0h13nTGdQ--

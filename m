Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2FSLHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:07:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33416 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab2FSLHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:07:30 -0400
Date: Tue, 19 Jun 2012 12:07:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: mc13xxx: Remove
 mc13xxx_sw_regulator_is_enabled function
Message-ID: <20120619110727.GE3974@opensource.wolfsonmicro.com>
References: <1340086797.9329.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gnQ/OOKD4CRsnGw/"
Content-Disposition: inline
In-Reply-To: <1340086797.9329.1.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gnQ/OOKD4CRsnGw/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 02:19:57PM +0800, Axel Lin wrote:
> If .is_enabled callback is not implemented, regulator core assumes that the
> regulator is always on. Thus we don't need mc13xxx_sw_regulator_is_enabled
> function.

Applied, thanks.

--gnQ/OOKD4CRsnGw/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4F1QAAoJEBus8iNuMP3dJJ4P/2eSXh9b1u9EX4nEBjypPNyg
V4erkHVCgwMndzfx2FujufRJT6R6Ps49aWbTftxqwxJJjeXosQzctobFtnkfIbfv
D7MgO5yIXMk8VFQGHzKA8JSwp2Z9llg8Gr+v8LK43a/had3WZu3HIHwNkexGQnP5
YfqhSnB2oODqtEHOxy/TAAW+kWTpngVPX2ww8ieXOEm1N8fsbjFwB2CGKc9rIbZO
dp7ibqbHOyh6HBclUWFskqLzAj/JoTHVuqDCEd2nkKWD5EihpK1AtuKRAKvI73Ov
qj9Pi3UezrP0edEwZepbsERzRWTOjQZZPE/0hNIP+fXVOBYl/KQFRHXYpxoCdiWR
4NBt3ESby7Frt/M/ngfboKDN/QYZza+WkC/f/vU53lzpNHX+0rrhq1z3OZ8eetWJ
uog/QXs2yjAcb3FQRf2jKJQfwqVLI17QKqBMJvc/l9tKbhjoxI40QwzB5Kqw/jl/
kqXe8ayDq+1YWh/+bSfPmSza+wTNfwG2YAKf/hgP1769QT1a0sZk9c8uArqZeJ/I
rY688iYqUGb77DMa3kRUE5ndLqNZnga+ZhjWSwWtSVvWMl/O9xCayliyihXHCNRH
N1wkrO7Ll/vbzj00WEuGNWjVKIJyN5NBGlC1ZyiN2T1seTOz0efnDMtYoyu0w6Vn
UZ66FjPhyB710hhW2Vwd
=AsEY
-----END PGP SIGNATURE-----

--gnQ/OOKD4CRsnGw/--

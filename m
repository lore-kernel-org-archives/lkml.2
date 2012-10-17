Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2JQN6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:58:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47094 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186Ab2JQN6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:58:21 -0400
Date: Wed, 17 Oct 2012 22:58:12 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: DAPMise Headphone and
 Lineout enable controls
Message-ID: <20121017135810.GX14199@opensource.wolfsonmicro.com>
References: <1349953265.24126.39.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bJ3jXuwtxrXxD2iT"
Content-Disposition: inline
In-Reply-To: <1349953265.24126.39.camel@matrix>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bJ3jXuwtxrXxD2iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 11, 2012 at 04:31:05PM +0530, Ashish Chavan wrote:
> This patch DAPMises headphone and lineout output enable controls.=20
>=20
> Earlier these output enable bits were permanently turned on in probe.
> In da9055 codec, right outmixer is directly connected with right HP and
> Line out. This resulted in two side effects,

Applied, thanks.

--bJ3jXuwtxrXxD2iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfrlsAAoJELSic+t+oim98ccP/3IzEzDwyyNXTN+cZEqB3qRd
PxY0Ybo1Is+EGABuob8uwWHQFifHTSLI9CMdWQqoTJIeJwEluNdno44NFjpVWduZ
oCNBrquC0ahRURnbTMTSfCCClAh0PaVJqffKUSYt1nzzAcEEDXXunIQEm619WqwQ
EMeLqtwP4mof196atA0wswBQpo4MYpZL/6f82+dR2pZP8Nflxqq7IQ7TUJBma5oI
ks9zbYDAuZkyA21WTJRlO5ONnb36whER3NV5dYjwnJOM8UlXCKwT7IluGHU8uHLL
jorEZyXwBkYQMKKKUxIHo5xzV0x/5iztwnTubcDhQb4bnZ/kaZ6OXSwvMANUcuGo
k9uLUWPztetk7qh/5c2a3vR8AHoA+3nvt10nXWpxHiJYXZ90V7dDaU2A4Dzx/N6g
6VqPLisial+eRPT+hqOFeyIvTrV0ab8/TKCCL6w2tPHsH8o9LAtmHmTT5/oPHvZu
KIbTH6rjqAZVxSvKpB0J62zRU2hvJgBgiz9+VBAyD1oBhRZSfsBHqu9ohi0pjfb/
bOzE3KJOlTzk3dUMzPhDa+QUBuQbzOODLW4GuI4GxL7JTYFbbyjVq9r/38rB9NwH
RhNwdgdN8SFM/ypt8ydrTH9QzUEtZVbS+ChS6oUuaCTO/Cgy4/lFDW/uC4PkkNjZ
xVqhmCIRbohOuiGNDTIb
=gUQR
-----END PGP SIGNATURE-----

--bJ3jXuwtxrXxD2iT--

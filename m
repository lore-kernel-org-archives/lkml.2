Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2DLRJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:09:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50755 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab2DLRJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:09:28 -0400
Date: Thu, 12 Apr 2012 18:09:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] pinctrl: implement pinctrl deferred probing
Message-ID: <20120412170924.GA18049@opensource.wolfsonmicro.com>
References: <1334133248-1452-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1334133248-1452-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 11, 2012 at 10:34:08AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> If drivers try to obtain pinctrl handles for a pin controller that
> has not yet registered to the subsystem, we need to be able to
> back out and retry with deferred probing. So let's return
> -EPROBE_DEFER whenever this location fails. Also downgrade the
> errors to info, maybe we will even set them to debug once the
> deferred probing is commonplace.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Note that the probe deferral code already has info level logs every time
it does anything so you'll probably have a hint from that when it kicks
into action.

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhww9AAoJEBus8iNuMP3d3o0P/RE5eFUTWZ0x/FGanLx8YSs1
1kAR9ws6nahzhwKSPgAZKQSzdP80DQYtuKn4Uoib0eD9tZ14xwqokAZZ+7qawHf9
q4om59WQk6Rpoz1fHEcAOQk2AlKSN/SnGAT+G0eWTbo4mV+ownuJpZavtjEpLVCc
N7fF7/BBRKy6Hs5PRATClhvcgzlgLHJJ2v3B08k1tWTkkiMOnrBe08JNRJxqLA6h
Z/meOLyfja6lnrYZ4fSJ5QYtr0ouWp3drPr2mKgZXWrk8VuoXmByARnNoHbxbFRF
gEpk51dQRvUd0oAtzocA/8ZPnlaSlbzyn9QSooCa0byXOMOFpIFJDlsZFGH83gwU
uf/J2e8Jq78yrnRk54tcINfqo/iQdPJwc5jPF06ngSOXnwxrmaDbP6usqlA/XYZz
UG2p5kf0LMBJAvr+oUyjVMfmcYHXXrjja0wbS1aIP63urVd87jVqD4WeoLS01FKn
1c4ZMoAEHmpFMQCn9Ma6Q/Ag9FWsbAatJn5iZxl48aI8kPE0tBaCl8XQNlJuKkDz
ieNFoewK8ndAEXflxxPZuQxkdLgKKmPVx1PLBP4k17QfyAqNuP6JPttT1OSsJiJZ
yB86pgt1cJQXwhixUrni81UP8Tubz9xbqA0tg+u58yuW8BDz5pxn/q/gmmcekAQw
TY5cs7ml7a6O6ixWXlIB
=+ryT
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--

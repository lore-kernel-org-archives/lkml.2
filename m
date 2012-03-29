Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2C2FXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:23:50 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:36702 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752240Ab2C2FXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:23:44 -0400
Date: Thu, 29 Mar 2012 07:23:35 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@linux-foundation.org, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCMCIA updates for 3.4
Message-ID: <20120329052335.GB5823@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@linux-foundation.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20120325170512.GA31282@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20120325170512.GA31282@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=2E.. and on this?

Thanks & best,
	Dominik

On Sun, Mar 25, 2012 at 07:05:12PM +0200, Dominik Brodowski wrote:
> Linus,
>=20
> a few PCMCIA updates for 3.4 are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia.git master
>=20
> Please pull from that location. The diffstat and list of changes is below,
> the individual diffs are sent (at least) to the linux-pcmcia list.
>=20
> Thanks,
>         Dominik
>=20
> Axel Lin (3):
>       pcmcia: convert drivers/pcmcia/* to use module_platform_driver()
>       pcmcia: Convert to DEFINE_PCI_DEVICE_TABLE
>       ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
>=20
> Joachim Eastwood (1):
>       pcmcia at91_cf: fix raw gpio number usage
>=20
> Yong Zhang (1):
>       pcmcia: irq: Remove IRQF_DISABLED
>=20
>  drivers/pcmcia/at91_cf.c        |   52 +++++++++++++++++++--------------=
-----
>  drivers/pcmcia/bcm63xx_pcmcia.c |    2 +-
>  drivers/pcmcia/bfin_cf_pcmcia.c |   13 +---------
>  drivers/pcmcia/db1xxx_ss.c      |   17 ++----------
>  drivers/pcmcia/electra_cf.c     |   12 +--------
>  drivers/pcmcia/i82092.c         |   11 ++------
>  drivers/pcmcia/m8xx_pcmcia.c    |   13 +---------
>  drivers/pcmcia/pd6729.c         |    9 +-----
>  drivers/pcmcia/pxa2xx_base.c    |   12 ++------
>  drivers/pcmcia/pxa2xx_viper.c   |   13 +---------
>  drivers/pcmcia/soc_common.c     |    2 +-
>  drivers/pcmcia/vrc4173_cardu.c  |    7 +---
>  drivers/pcmcia/xxs1500_ss.c     |   13 +---------
>  drivers/pcmcia/yenta_socket.c   |    2 +-
>  14 files changed, 47 insertions(+), 131 deletions(-)



--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPc/HXAAoJEJqXYIlMjaMN6foQALjPWZtyC3IwJkBOhusK3TWB
XYMKpWEDg6BTtq5Y5fG+TiWliwwfjuNl5hcoR/YwhuRpIHBkLrImaty7JgT4awzl
XXv24Y5p05w5eS1agQSCcUZUB1SayG7WHikc27U0RgktzO7nVhT872UOh0EtKBqC
QHPcj5hSeKnozrL2ivcRWeSyRSE9XhQn/E6qtxbeeiKNeIsh5LHfdo3bZSW0imwM
gCQ6BnVyn69ASclfg/bJbZFKSHte4LbqZYEHNQd4p1Lgv5iFjpOt5waOEX9Csl1+
i9/fEt57GSV67TRZDvOIYtbNJaEqC23NQzhz/ZzYkPsbZYmJlVVHnKyoWTuPUH1P
QpqXdxypa4yqy5WfBpnFvaAQ4Ilr+aZ4SZX0UWgEvCK2Xo44iVTOxJ0Jf/IGd14e
5aF95sG5qU8TszhGerA0TsDgy84Tce3D37cUpoLmzp3+m9lP/ZBiOmNK7LipkJcZ
O7Mai1rYicoXcoAeEoELOYvOwG8E8xxk8DeSKEFcRdXfC7hJ1vrvsXJVP04/9NB+
2xOchAu9WybH5t+cqBJCxZYiuZ7S/HW9Qv6LnAFNNHbFksNBp516Wd6m6eQrpH/t
3fYDIGfbKY5zO+uXj+B7qYf707VcD5/bM2oFc0xE+4rrteCX1WbjOIXYH39LIZI3
DP2dBmlbC2nYFWvfXGLa
=Ahfz
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--

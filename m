Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab2KPIpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:45:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2KPIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:45:10 -0500
Date: Fri, 16 Nov 2012 09:44:49 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v8 0/3] Runtime Interpreted Power Sequences
Message-ID: <20121116084449.GA20785@avionic-0098.mockup.avionic-design.de>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:gTCy02T/PmQtw5tVJ0Nqkd32Pm3j9OTrv6UQn238pgL
 8G6S6gJ86lu38C6miSECmvE9wNnRg+8U+3q1Cch6GmtqAjPjfj
 aNERZYkLq+I4uNX3EM2dKToks1RvlooOYWiiF+sTrGyeaMtrTg
 nUAmkV64mOVUxD6OvI9Dv177JsYautI1mgtn52j7uSnJFu1QAD
 6LSW9pmxlaZSxP4/g1yytc67VfAlZWN5z37V8jjZjAYlhF2aDz
 J7/iFuT8r8O07XbA8cUo0SKvuYH9WRoeaIl5eKHjv/jAs7hXlx
 idOhKCzQJj+Dw3EQ4/3E0TKAg0loOAkFBM+ej2to7me4dVmaRj
 /XuyHt+NoU4FZyC77K4IqOJpdEHU2uucjtGCZz+eA7zVSEiBYT
 YtCtoUIWV5zTP9GfOfo9oPBsaN1AkM7rtpXp3lqdiKiiyUnUPu
 pA54O
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 03:38:20PM +0900, Alexandre Courbot wrote:
> Hopefully the final series before the feature gets merged. Anton Vorontsov
> kindly accepted to take it into his tree, so this series is mostly a call=
 for
> acks, tests and reviews notices before the merge window for 3.8 opens. If=
 you
> are interested in seeing this feature, please add your name.
>=20
> This series also adds an entry for the subsystem into MAINTAINERS, settin=
g me as
> the person in charge.
>=20
> Changes from v7:
> - fix bug reported by Tony Prisk
> - add MAINTAINERS entry
>=20
> Alexandre Courbot (3):
>   Runtime Interpreted Power Sequences
>   pwm_backlight: use power sequences
>   Take maintainership of power sequences
>=20
>  .../devicetree/bindings/power/power_seq.txt        | 121 +++++++
>  .../bindings/video/backlight/pwm-backlight.txt     |  63 +++-
>  Documentation/power/power_seq.txt                  | 253 ++++++++++++++
>  MAINTAINERS                                        |  10 +
>  drivers/power/Kconfig                              |   1 +
>  drivers/power/Makefile                             |   1 +
>  drivers/power/power_seq/Kconfig                    |   2 +
>  drivers/power/power_seq/Makefile                   |   1 +
>  drivers/power/power_seq/power_seq.c                | 376 +++++++++++++++=
++++++
>  drivers/power/power_seq/power_seq_delay.c          |  65 ++++
>  drivers/power/power_seq/power_seq_gpio.c           |  94 ++++++
>  drivers/power/power_seq/power_seq_pwm.c            |  82 +++++
>  drivers/power/power_seq/power_seq_regulator.c      |  83 +++++
>  drivers/video/backlight/Kconfig                    |   1 +
>  drivers/video/backlight/pwm_bl.c                   | 160 +++++++--
>  include/linux/power_seq.h                          | 203 +++++++++++
>  include/linux/pwm_backlight.h                      |  18 +-
>  17 files changed, 1494 insertions(+), 40 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power/power_seq.txt
>  create mode 100644 Documentation/power/power_seq.txt
>  create mode 100644 drivers/power/power_seq/Kconfig
>  create mode 100644 drivers/power/power_seq/Makefile
>  create mode 100644 drivers/power/power_seq/power_seq.c
>  create mode 100644 drivers/power/power_seq/power_seq_delay.c
>  create mode 100644 drivers/power/power_seq/power_seq_gpio.c
>  create mode 100644 drivers/power/power_seq/power_seq_pwm.c
>  create mode 100644 drivers/power/power_seq/power_seq_regulator.c
>  create mode 100644 include/linux/power_seq.h

The series,

Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpf0BAAoJEN0jrNd/PrOhZokQAIsuhlur+Ch6HtW/T51TB19Q
91Jyr22W11fc2p9ECijst9ZY6ebpt4Yy7ZwtqKTGLcQE5oGZZhnHzNRKTipEFGqp
E4iFOrWtq3ulRmhjaOTA1xo1yL6GjuIy07cdxrVMOMy5BVKV1ymOPyVqt1Hazimf
s00QBMvpgyjLSsLatyl6f7QLGCvaEjsJ+l8xeObGATew7FrmYHpeAAYqSecG1SxR
1ypzflnAHYPJ4pqCo2eveguMJeKoxWk8/7jm1/7Sayu9urm27U9H6JLZiKjLZ/Tb
cNZw7n8hul3pTGmEbLDK/Y45LNZ40tisY5dFhM7GS9JF6ca+eRYt2cQ8pDsJ8Fwy
ry0PsCYv/PZLflJazlFt7NyQs91ELjcwAv4ySQogBwGvZ58vDgNSjNxtd+/7Isvr
1mXJoqxV0wNimUb/YhbNBURk4Q3kOKMOrxS/NSJ5/L8UobLGXyGubVEIILqOg6eg
NYuLyzQocaxYRVadzeUBpqp2Qac7dFue2oN7FAlxy04GAR9Zj4ia3YyNHY21Z/PW
D1ryX8EsHMHObIHoup4+7VixRf9ffcL+QAC4XlOtD8m5m6KWZEgO150QiTpFUHAv
ECtBoj96iuO+VKwL/2uAmKw7ZRDSLVB4WPRzdHcZUdZc94kcR3wFNd+VkhzhTjrr
lAAorLy1m4tQZH/nfnQs
=E8ZZ
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

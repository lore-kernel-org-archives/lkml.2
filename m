Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab2KPIuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:50:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:50:04 -0500
Date: Fri, 16 Nov 2012 09:49:58 +0100
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
Subject: Re: [PATCH v8 2/3] pwm_backlight: use power sequences
Message-ID: <20121116084958.GB20785@avionic-0098.mockup.avionic-design.de>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <1353047903-14363-3-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Q1hw7IEr+fLJt1GWSfp4A7+eRhy3TBY4+jgRFjhgiMW
 gX2Zn17jtdGYKfRgPJ+19NDeJfhFmDY7b77CBQ+nX5niF1M4Qw
 3NHmOOhvMzxDWKsgh4L2M7AQusI9HM6GgUU9VeLWe6lVlRfYDJ
 w9pdyn486pb4MNrsVQTf4YHcB2wOy/X8BBFUINs186mz8ralHi
 q4iq4BSwJBivvF1FUxjl9yrzjqrkyUQ5E9I5H9DODJ8zYgNaP+
 /4g9wiquM9iz6oIeH7Cq7G/dS+RI5JBgtXtXV793tlaCcU0nrq
 uvkymNOKm3JyPeCtzbfT/MFKsWfMejotUNag1KLmY8tEBd5XFf
 DowKeCNErrnaobeWX+ToE9Lb33CYlcFS1bQjU8IywgWtTG2MZ0
 ASHN4l0WuodNbChUAIlupv7SotxqMkKNxE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 03:38:22PM +0900, Alexandre Courbot wrote:
> Make use of the power sequences specified in the device tree or platform
> data to control how the backlight is powered on and off.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>

Anton,

I would normally take pwm-backlight patches through the PWM tree, but
since this patch depends on the first in this series, I think it would
be easier if you took it through your tree along with the rest of the
series. If that's okay with you:

Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

Otherwise just let me know and I'm sure we can coordinate to take this
in via the two trees separately.

Thanks,
Thierry

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpf42AAoJEN0jrNd/PrOhIAQQAIpZRiO0Ir4ZgNr1p9P+MKLJ
Czzca7/YmN4VbqeeNvCAEaN/g1yOb948KdynjRB5RjFqjd+pIGFWlOF+BaZCt0Xn
18DWDar4eWOiy/ZGuOkwL5iKtLzTzSmCLK+rSUHvxGnIGZo/xqO6W96R15/zEJmw
EKMnGmM/vOodjJdxSimbY82Kim+PdbUbecqCNKFSyi5bTXeOd/xYmHml4MysptyB
YLRYeP3wEXflCXMAluPzz+Oo1Rz3BCTmh/VjlE/4879PvpIQjX9jiEmfGnyTaMqG
ZRmS5xwqMaHoQGOkMqQi71P7Fq3P/kUfF05y9A/E9yni2c3230217v5ai7x2JJYd
DalB9WYcPS/836g+JsecH7KMCa6mwjtZjfxoTMILhXG0rOA9QTHguHkFdBb8IGU4
B2dgLACZCvwCLGoTc+AJJJyqWa3Pz7vAjTZ71xCi7e/lmFCAUC4GJv8L/fawSwGv
SFmAXlpBgSgph6hyJolELdnom8R8CzEMQGTWO+chTp2UXEk5iFrWTCfcJ7I77C8D
JevtTjQgiw/C+xot2+cDq/6ghWctupXxNERo2hepW3XRXGKWaAPccgh/YNbI4fGR
I6IVKpVjFVm2+/42R3KknBmz9ghcA0i3hYF0GH5V1sHUVSAqfzfBBWGEHJvhKTC8
O3fkU9G5MYokmDT+i8x0
=ncjv
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2HTTpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:45:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab2HTTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:44:59 -0400
Date: Mon, 20 Aug 2012 20:44:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/10] sound/soc/fsl/imx-sgtl5000.c: fix error return code
Message-ID: <20120820194455.GN26991@opensource.wolfsonmicro.com>
References: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr>
 <1345359780-18647-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Content-Disposition: inline
In-Reply-To: <1345359780-18647-2-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 19, 2012 at 09:02:52AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Initialize ret on the second call to imx_audmux_v2_configure_port so that
> the subsequent test checks that result and not the previous one.

Applied all ASoC patches, thanks.

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMpOxAAoJEFJkBDiqVpZ4rF8P/0Zg10jkPs3h1QeygboiX62P
NbaGfV/tvrUfqE6J/JP+TAXbKAdRKlh+AYISMGhZsCXqD0c5RINrmOEsM3grxI92
WsM6H8Ca114MFTWEfdQ72JqEjwiXt5Y5iA6i7v54E07DgpWWiGKnZo1UWWdUPGt+
r4/iz/fhutz+wRH1CA54x3a/+0PdvKQzJQO6R+rFLTHVi2yq/konH1AsI5Vo9DeV
jI3iCIHc9mLAHQvmnF45lNQLNj/r0XIIPc7tLwweFQnCL8ZJUlNBYj+qJDyPlaC5
fp071IBepzp0qSQz8vA9CtGCktzXoFzj1sIST4/3++chKe9UdD3ifnw2ANr9mJqm
+ZWiGCIrsDVL8knupX5Ax4JLMIT7LP6eIHuq0nM8ComR5njGS2bmazA1TupKcslK
tMnyUXWVYUvRr6RilV87YneN5WIfZpSjMhrYFh5akVh9d0220bFZQ2ZwD0gFT/Ht
HdLccyqk/UKqg/JrgOd5YKug+Lwb19oFWImcIcQv5dwgsInJ/q112KkyJGlQ+2vF
/tfA8spkr/L6no432HzOeqjQvPktskzZi5Ubmhh1ilg+i7au8E6YJHsL8jbcDOQc
0XDdscAnUHjxAIw31kv3OpsPvMaY7KGWOq6NJSxGUA4+IqQtIh1SOE0oKTWoHUVT
/5jz8POclpcRymOeKlpl
=yLGW
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--

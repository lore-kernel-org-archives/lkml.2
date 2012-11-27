Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2K0Tgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:36:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143Ab2K0Tgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:36:54 -0500
Date: Tue, 27 Nov 2012 19:36:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
Message-ID: <20121127193651.GH4468@opensource.wolfsonmicro.com>
References: <20121123081307.GA4529@opensource.wolfsonmicro.com>
 <1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 10:12:13AM +0100, Lothar Wa=DFmann wrote:
> Due to a broken make rule, sound/soc/fsl/imx-pcm-dma.c or
> sound/soc/fsl/imx-pcm-fiq.c (whatever is selected via Kconfig) will
> not be compiled into imx-pcm.o when building as module, i.e.:
> CONFIG_SND_SOC_IMX_PCM=3Dm
> CONFIG_SND_SOC_IMX_PCM_DMA=3Dm
> resulting in a non-functional sound driver.

Applied, thanks.

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtRZMAAoJELSic+t+oim9P6wP/imhPloqqGrGfvVv/zTNngGm
Hnbxx0JCzvjkr0Mq2skTfwalvLrmPe4WVtoaAfUOedatNCcqP9N/yCmhU+HFbL2Y
LSPcGNQxGaUHbC6DZJt2F7Dn3ceVKeyVT1WBbsuuMsxDIXqIXarcuABUIzSvJ/re
UzjF/RlUOiOStgoa0c7sRbUhcAPHfNa5epny3gDvSf2XTAO1T9/pZtlupxOn9XMi
xAvCAp3aN9GE2FcAsEsLnjnk1SeXZD4BxUyn8CVV1CEZDznhFiB2rgtEZkPIJtBp
GehJFDrgK911Q2ArD3Sv8VpBECMfx+wtd/XSMZFwWc0zAWknXC21YhoE/HUsjHe8
nwS2MMOlaTMCIwqZbe2SFyfRCQ5V5Lxln/ax4YUamMXpf/SJKFpJ3cW+suSll2lG
vy5qSOE+1fhN5X2D3k/ssEQvIOshCRyUUU2VlXewXt3+ophJMzAlQdM6/CCv/jmr
UVq8DFXAEJdRRo/dMKTLZLpTdIxXD3aldUrwfJfbV2Fo1fKPnn/Mia4rEoDrvGlj
LHxKZIdW+nwf6ZhVzA4Pcq0JuZtFDjq/Cv1w9lRWFA+SSknrGk2HFUhGrFWxzsBw
13X9wDUQ3PhZrFvzuQ+idDJBGYrtYIr37NRT0hOXc8Xiu4av99oAU83fQTBAfliC
vudw+YIQ00MgDmnE6i3L
=uyw9
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--

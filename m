Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2GZL5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:57:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50628 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab2GZL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:57:51 -0400
Date: Thu, 26 Jul 2012 12:57:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 04/21] ASoC: ux500: Strengthen error checking after
 memory allocation
Message-ID: <20120726115749.GF3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ugMgaRwDDWDxqvmW"
Content-Disposition: inline
In-Reply-To: <1343298534-13611-5-git-send-email-lee.jones@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ugMgaRwDDWDxqvmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 11:28:37AM +0100, Lee Jones wrote:
> Currently there is no out-of-memory error checking after attempting
> to allocate memory for the ux500_msp or ux500_msp_i2s_drvdata data
> structures. Instead we go about populating them regardless. This
> patch applies the necessary error checking to prevent a panic.

Applied, thanks.

--ugMgaRwDDWDxqvmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQETC1AAoJEBus8iNuMP3dvEgQAJQQ4N0si8kBeBLoLos27IxL
43adUukfh/hAESFOWfiLbieCHjAig+XSRMKfpKWkM2/2cWNV6Ps1s1P1SG+xTVZE
fFYtNNtPWZpRp7d4TlT5EvY9NHq8ZYPW12917nOsJGlgxSPqZmYRLM0wB//dmF4d
yY6O9iPY0aEr2fRsOWVOFTrUZFJPOW2r0OFqK9WYtv8PcgzFaSEyF2bKuYf+fFWL
9jjeNh18NcCoHAqFRCAadoG+6SmGJPl2rEVT4taR2sg13m7rCg3fLgLh9iDgEWDU
oHlQcRtc+Byqct1+YdB87zg12u9fTihU49ggxdLi15eEA1Lu59OlZZkzxocoylo9
gPMF1kFMbuMav3lJN2ZhLz4AnjYEoaX2ySOz12p9dqvKlseyYiX/QDvZSs6iLJ9/
yLbUFOaAxb317euq3j27Az236/1u0mGPCUlB4ynbLLaC/vRIZeOFyFYX+o8iWcao
E8bGe/+DA2USmlt8dsSS+YAuqGJ49HazdnnOhIp9UoQLIzzPTB/PN9617V2ZqMtl
U8UX0Sm41BX3npgLTfE7rXfpD5WDivrqz67U31r/ovw0rHtn6CNAroWvWkwPkpfX
iuDkYDuQYZ97qRCHWhLKA6cyielO/2KSJ70aD0r4qkk+3ltpHEsYcwafao4pvv8h
uMARFIixaSeXsWZv2P03
=29+Z
-----END PGP SIGNATURE-----

--ugMgaRwDDWDxqvmW--

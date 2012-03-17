Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab2CQVwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 17:52:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51827 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab2CQVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 17:52:06 -0400
Date: Sat, 17 Mar 2012 21:52:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        qi.wang@intel.com, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, Liam Girdwood <lrg@ti.com>,
        joel.clark@intel.com
Subject: Re: [alsa-devel] [PATCH v6] sound/soc/codecs: add LAPIS
 Semiconductor ML26124
Message-ID: <20120317215202.GI3315@opensource.wolfsonmicro.com>
References: <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
 <20120306100012.GC19635@opensource.wolfsonmicro.com>
 <CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
 <20120306121222.GK19635@opensource.wolfsonmicro.com>
 <CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
 <20120307114811.GF3107@opensource.wolfsonmicro.com>
 <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
 <4F60D804.30804@metafoo.de>
 <CANKRQnjhe2F-1OeQvcXZQEckOtkFnHD-8BoADQ6nN=x1xTZSWg@mail.gmail.com>
 <CANKRQnjLwRtkaW32iTZSr-ffnsNdcwNJOyKO=Ru7y8Qw7ekW9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zqjkMoGlbUJ91oFe"
Content-Disposition: inline
In-Reply-To: <CANKRQnjLwRtkaW32iTZSr-ffnsNdcwNJOyKO=Ru7y8Qw7ekW9Q@mail.gmail.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zqjkMoGlbUJ91oFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 16, 2012 at 06:55:09PM +0900, Tomoya MORINAGA wrote:

> When SND_SOC_DAPM_SUPPLY is executed ?
> or
> Do I need to execute from application (like amixer) ?

As with all DAPM widgets it is automatically managed by DAPM as needed.

--zqjkMoGlbUJ91oFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZQd2AAoJEBus8iNuMP3ddjoP/17ztlrypniEWW9pTgHrDM0p
tf0iWC9J69CMkce7/zPDXZdz5N9RKc5bNZJJMrE80GZJc1ss+oyE2Xtg6VZQxqZm
CAlz7DqXJLDfl7dLGiX9niymGQF+7hqhagSo5IgyJq4JeaDL5ZPH6TRAQYR976ow
9w3jNt7cFxhLmJRdTjxPFKiOVhZLOOgKr/pNB4FnCod9Qx5ixij6uRWA3ddrbwNa
crOqi7QEV1fPaFEJvVpabiPNvqiGkkAv1nq/ogUEyd1EU4tzpt+jhPmNIoCN2MDs
d70RvS/8I9ADzlJb2TfRuFXtyAH1duZVT+zPYrNCwMdSipZ49TOT3dpmsBF6AGwW
BQM/oxy6BhhKW7RlyCgLuF2yVFkgusTbcafBenbxI2F+43meQ9/g+vcgHjDmfBMF
tsb6aHlYH7MM7cxfuy8NXG6j7LZ83O+LodkltjypuJNtkfF4CpLJWASi7h1HM+dY
GkLN6bOi9mFZo0DC1QCEZamzQXEf21JWlasSzkIrV8ozle8AzcgnDI3jzQLv2BJV
Q/M7BuM8LNHRe2Z3+kh5nHxpTZ/u6dKuCW229YC9asSOKHCpixvx8LS+lfo8Cmbw
hvrk/MsQiCMkwa19aLDdarHJ60X5n1SYBpIAWApt4jRvpMFhupMjwUgxDsS+FHD2
pmqbLjEvmMFfLou2r5Pm
=nCFV
-----END PGP SIGNATURE-----

--zqjkMoGlbUJ91oFe--

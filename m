Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab2EOSLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:11:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50074 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932628Ab2EOSLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:11:51 -0400
Date: Tue, 15 May 2012 19:11:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/4] REGULATOR: regulator driver for Palmas series chips
Message-ID: <20120515181101.GC19592@opensource.wolfsonmicro.com>
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
 <1336960712-2812-4-git-send-email-gg@slimlogic.co.uk>
 <20120514085223.GH31985@opensource.wolfsonmicro.com>
 <4FB1F3DD.3060005@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
In-Reply-To: <4FB1F3DD.3060005@slimlogic.co.uk>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 15, 2012 at 03:12:45PM +0900, Graeme Gregory wrote:
> On 14/05/12 17:52, Mark Brown wrote:
> > On Mon, May 14, 2012 at 10:58:31AM +0900, Graeme Gregory wrote:

> >> +
> >> +	palmas_ldo_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);

> > Could use the core regmap stuff for the LDOs too.

> Enable/Disable now use regmap but is_enabled cant as it reads from a
> different bitmask.

Yeah, I did notice that and actually meant to go back and say that
really your current is_enabled() ought to be get_status().  The former
is supposed to return what the driver request to the hardware is, the
latter is supposed to return what the physical status is.  Not super
critical though.

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPspwuAAoJEBus8iNuMP3dRi0P/2yFZpgseHLMtBXv0iQXSWZj
VogO3t+xgzi/DVmj2P/BgHDRx1OVno3XjDvMGkpnRathw6pRs2MdORgCcCMhvchZ
1ohpkUFiHFHowqR/LtNtgizRuDPvzC6vMmCAgrT4qrou1p/1+q3tKcspO/pcaOa2
U5SkSHPZ2zSuXrXrKeWpO3nf70w5+LmblA1W4H+OgYBBq6lFysz9a1RmsD+O4fR9
AzM7XztqkFOAMqFKgMNOFFFIr/83MSY4b3HPYNL6sDx5kGkSI7bB1rvPJtBMXcUe
HMLNK184YfJKUIzio3jdAiRYQAal7G/dgA2oMVFgBlqWa4JL2OuoZ0EJmQQuE7Ft
b4mIzMUD+IYJtUm2211mB15vrvBp8yGqVRP/Mf2MPrpFDMzpPM1VFRpnN7qsWpA1
29/emLejR0+plIUUGkZEV+94mEdEaoC73wNjCGMi7A17ajyY2GHWscqsG/spRNMN
oaU33frLuEhke6bW/8Bog5SBzuNRr+UP8sKB0tpOPF/RHrG8fO2fcPj8jMLepRnl
SbisP8FJWo+9TWHAe/8+k7UUdGAZhBLA9kqBDZs6ZsssIz+V5DET8005c9y+++zz
6dacY2XXk8M6bI1/flAeUQmcp5iQwkZn0NKU0DlRFXsCSd68vjGWg0FPltPCKP/k
R9O3npDLK3kDirEwxoQk
=f086
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--

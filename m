Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2FCMFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:05:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53199 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab2FCMFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:05:11 -0400
Date: Sun, 3 Jun 2012 13:05:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator
 tps65911
Message-ID: <20120603120506.GG4258@opensource.wolfsonmicro.com>
References: <4FBBCA8F.3050903@wwwdotorg.org>
 <4FBBD33C.8020802@nvidia.com>
 <4FBBDA97.6000006@wwwdotorg.org>
 <4FBBDE06.5080806@nvidia.com>
 <4FC916AC.4060804@wwwdotorg.org>
 <20120601204052.GB4258@opensource.wolfsonmicro.com>
 <4FC92990.5030104@wwwdotorg.org>
 <20120601210451.GC4258@opensource.wolfsonmicro.com>
 <CAOesGMgYAR938F8PnVWaymzMBQwDKeAiUgEP81bv2nN14NmLGg@mail.gmail.com>
 <4FCACFB6.2060601@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5GLnnZ8mDMEwH4V"
Content-Disposition: inline
In-Reply-To: <4FCACFB6.2060601@gmail.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e5GLnnZ8mDMEwH4V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 02, 2012 at 09:45:10PM -0500, Rob Herring wrote:

> I tend to agree with Steven's and Olof's comments in this thread. As the
> node names generally don't have much meaning, I don't think we should
> start now. We've already got multiple styles of bindings and I don't
> think we need more.

Well, if we're going to go with an existing idiom the normal thing would
be an ordered array which is absolutely abysmal from a usability
standpoint.  Compatible properties don't work as the whole reason we
have an issue here is that people want to have a single node
representing a group of regulators - for regulators which we can add a
compatible property to we're already doing that and have no issue.

What device tree seems to need rather badly is a way of representing
key/value pairs - aside from the legacy bindings that seems to be the
major source of pain when trying to contort things into DT.

Using the "regulator" string that we have to put in the binding (which
is currently totally meaningless) does seem like a good way forward
here.

--e5GLnnZ8mDMEwH4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPy1LrAAoJEBus8iNuMP3d8RQP/1NAUydX26zNJ22zFa5HGSqk
KEhRiGVXVP7go5gm750s8wwT1D4KRlu+hOt1YuL82elZVAx/j6R7JmfCLFV3hYGX
u2dolI8x/IE/zrZ4vF/bR3s2MlCkhfB9XvNkCcH8kmwCI5CNJMrPk9rh8wBWN2lB
pw6V1gOY5hRFuLlPAjLriC9WeSp/TXkifrhrcTOvhl3SvczTCBSWe/zUiUitnt72
FtyUVa3Mf2tt172lyNv/y+11BUyHtlKc2NFoslYYspPCzfYsseo15yaSP00ZA46a
vlVKEb/t6RX/0EGfq8P1XJfaE2ehuUDO1UUyseXNuTD/4Ssny6ZpRGAzbTHI/ahJ
CkTwfSfMDIV+enyfjlZFu7d1psVsQLUPKSxxLIHMu4Y03ECfK2O2hKuWw1JGXv0A
oooFaCNRmuJxx0sPQieAG4bvvpPIxC39MdPoaA5jxhsS2+a23VGPnoE5FNQHpgwF
YJkj9eXu0rlFXIQLChpIhw+DrfEaixC6BSzxyvhfpj8LYqDrSkJDurJsJT2fGh1Z
ao2fmEvVY1nH3/kT70mVL+axi/sfr3th7WV42Y4D+l1Qk2ab36bP8mZwNW1pqLgU
wwgqnbDvx3o0vdUL72tYD9jWZ+Oc3gK8XgtwwkIVVpGA97D5o5gwB0VSGMofO30X
e1QjMgeqUI9PEPpjIx2W
=t9T4
-----END PGP SIGNATURE-----

--e5GLnnZ8mDMEwH4V--

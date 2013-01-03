Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3ACVCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:02:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3ACVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:02:04 -0500
Date: Thu, 3 Jan 2013 22:00:36 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/9] ARM: Initial support for Tegra 114 SoC.
Message-ID: <20130103210036.GA4412@avionic-0098.adnet.avionic-design.de>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:epJiB2t1X8vFyxNdDy65noXZdM43k/XnIWXt5O6yAre
 5ffCwIf9xrUBmkjlSmPDd9NIFok6ZBoGdYRZ329FVN1cAoEIeL
 WQGc72M8xm3vrUB7UZISSNJIYTgB+AS+VglSORiP17KmhDodfP
 TC2q2E4b+e4xweNapxonoL3IYIw4YM5n690RoHMeq+yB6J1WSs
 DTkxlm1odSvlY8qhczNurCZaOYgMKmTMY+UdZjQA6RQ4+g422H
 O32nKbJkycb/bpm/48FS9fY1QrqKH0CZti19EStcceZsg3/D1S
 PbYThg5+0w47yPSwAFZduvDmaXR+snaYx3y100VeQ/5T4Cfb/U
 cYQOgKKPDeI+isxfT2lUq/Dq8xN95fEUvGDwr/OTILnman3/u+
 Ulf79omFiLv2GT91Xz9JdgBzJPJ3VrE0qs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2012 at 11:43:58AM +0200, Hiroshi Doyu wrote:
> Hi,
>=20
> This patchset adds initial support for the NVIDIA's new Tegra 114
> SoC (T114) based on the ARM Cortex-A15 MP. It has the minimal support
> to allow the kernel to boot up into shell console. This can be used as
> a basis for adding other device drivers for this SoC. Currently there
> are 2 evaluation boards available, "Dalmore" and "Pluto".
>=20
> This patchset is against Stephen Warren's linux-next_common branch:
>=20
>   git://nv-tegra.nvidia.com/user/swarren/linux-2.6 linux-next_common
>=20
> For those who want to try:
>=20
>   $ make ARCH=3Darm tegra_defconfig
>   $ scripts/config -e ARCH_TEGRA_114_SOC -d DRM -d SUSPEND \
>     	-d PM_RUNTIME -d CPU_FREQ -d CPU_IDLE

I wonder, what's the reason for disabling DRM? And while on the topic,
are there any plans to release a Tegra114 TRM?

Thierry

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5fF0AAoJEN0jrNd/PrOhVt4P/jph/maNKN2enADPkeBS9Imp
oKy0eZ3iMg8OcMakaAc44EK8qaQP9FRrITd/PJkUH/oeu5WefAPTG+unbH0mGu/m
Rhq5IP+SiqikqAXXMmvpI3K7xjkqVeUrNBRgBg7j9to0NB5SGsnE+Qp/d/dASjju
iMIViGq1eARAzXpdbo4IoUHuaeDJAbccOa6NPCfIvWGvPnpDNIQnYwOdUH6en9QP
KLX1JleuCGJKnpILM89EoCnfG6CT0AxqDh9EIXho1ZYdhZmfJTm5dgW4RvEz24GN
uKRBwrYrWfnFof0EtKkcL+qkIoCR9+cbxJqatbrSygli0j7+6hMCvz0mejKksBnT
b2GVESytQgYrgdHyRhtYYnKD3VGQ2Bp/rTlgV/OqPaJrdwpw2yyBAUHHn85kxc8p
5hHUHppBGa0JPm0hUazNjvhhCLjezRBG8IsV3BLEmzGvUk3QxLzn64k8tPbxnGGq
9vdpsz7YxA1hOEOeokmvpQYMOuUDUXTQX3jJoGwaWO3oJiM9AI4QavtjsVsqkp6n
cm1Lwvc4vUtfmhIyRxFISCVe544PoZi1Ag4PptZnLWyKqXCebZR+Bgv0/xOlbU2Y
nr8nA5nOPSTT1NktldWDXgps9vhvUxr/1czrFDoR0c4M4qwGY0p+eSpAdJpkT8g+
UpyanWjTqBeC212fabfS
=psOq
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--

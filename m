Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2DJKCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:02:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36350 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab2DJKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:02:51 -0400
Date: Tue, 10 Apr 2012 11:02:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] regmap: implement register striding
Message-ID: <20120410100248.GC7499@opensource.wolfsonmicro.com>
References: <1334000424-19916-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <1334000424-19916-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 09, 2012 at 01:40:24PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> regmap_config.reg_stride is introduced. All extant register addresses
> are a multiple of this value. Users of serial-oriented regmap busses will
> typically set this to 1. Users of the MMIO regmap bus will typically set
> this based on the value size of their registers, in bytes, so 4 for a
> 32-bit register.

Applied, thanks.

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhAU6AAoJEBus8iNuMP3d6bQQAIYjdTH3R77TbPL1hmXVyqyY
6zkOWh7xI/CoRGjFgOnL6FATWKEseeYvtm31spChi/jqXqcg1A1K4Owv1vskSIaQ
CYdUzLgvJWDR64A8qLLUepHL2Kvz0esB/1QcpSfTgAXpnuWtpOBbGevHyA1phFNS
LI9OYnSCd1peI850gBVL/tbp5A8ipUEXBCyBpIH3cxpCPHj+ySvNS9smPi3PDz9N
c1vmpcN103+dRmfZmnKZ1wlEtFTtVqaLxNlkUOA20ICEm7nFEoC/0sKJPNWASYGH
DKZhFYrCxQcpfUh7NlO5tE7J8xj9vYjqw2knvzKEmadghRYIsFOR0LdI+V/LTaYl
H6LbbP3NnFvoPJQt7S02UwcLey5oxJrmoVAyWsRQldM/DpeTqJ2XMC09q6IMkm4S
pIbjl0f4HxoGfLOLEYRcwAuebp40bH3ynM3U6+NeYfhGtjKPkmG1m9xHVkt+mv4l
qIylRHy1rz0bzbq+402CBBMzGdpPw1OyWO4nNgBzBGIMUSYrVvmFjTc1tEVbvb2d
/hVrgLThwOWwOXz1YmNwAOmBe/AV6z5io35BEarKlbDSYgqwW+9Nvkhqa1IjKAQV
Z+Xpi45+hc4yF1XR2kv1I6EF4aMG4iAtiT4FMn3TuWLC2WMWURB++YM3G9GHX7lZ
UZwHXF7X1uE2VR0gNE+5
=sesx
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--

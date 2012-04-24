Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2DXN0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:26:53 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45735 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab2DXN0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:26:52 -0400
Date: Tue, 24 Apr 2012 16:25:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Message-ID: <20120424132536.GO8444@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120424123248.GG8444@arwen.pp.htv.fi>
 <20120424.153930.1438573079107186567.hdoyu@nvidia.com>
 <20120424124115.GL8444@arwen.pp.htv.fi>
 <20120424.160319.1903472399760352200.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SENi13OXelf/Rv8V"
Content-Disposition: inline
In-Reply-To: <20120424.160319.1903472399760352200.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SENi13OXelf/Rv8V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2012 at 03:03:19PM +0200, Hiroshi Doyu wrote:
> > > Only Tegra3 has SMMU.
> >=20
> > but all of them ? In that case, you could call this from probe itself,
> > right ? But an ifdef won't work in all cases, so you need to do runtime
> > detection based on some revision register or cpu detection...
>=20
> So far we don't have so many variants, and presently TEGRA_3x_SOC
> always has a SMMU. If there were some variants of TEGRA_3x_SOC, where
> some might not have SMMU, then runtime detection would make sense
> there. Now it's something like TEGRA_3x_SOC =3D=3D SMMU.

the problem is when you have single kernel for TEGRA 2 and TEGRA 3. If
you rely on ifdef, one of them won't work properly, right ? ;-)

--=20
balbi

--SENi13OXelf/Rv8V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlqnQAAoJEIaOsuA1yqREZW0P/A7/gjbSlw+WF6VgWaASdJeP
cly3mUm077ha8GHJWreYAnWBldtHUX+2TYont9S4yemlMxV7+v3FKalzbNN71leX
KusiwMO9wSQErBignREvlojdVAHk8G1wxVrp12fZeJU9VLpwIhnK9saBiB1v1ipN
yInxZnaUuoAVI3fSoNQkdqqIaDiOHaIvJpvpBiilixQs5/U27ePykypV5jNJ6F5/
saPYRhP26P/cQTJPae8PuYhiKBntiUZw7OU0GO2SC2v9R+aWKFr/66qjAoTjY9hG
ovl3EHfMelFTY3UGtzBtq3la98X4VFEYmFDVQLQdR9rw4ps72MPHEJEwa8pyb7Im
eoYSKmN3VgXNEek9ukN96BNjH/BbnY/IgnoMbBnlSZCEFyjZ7pIk6hsbM8trG+AQ
7fXWNwW+1eLZSB4XXlaDK32Zg9JlSDFMGjchupoAE9BG6xmk0fADL7AKNaVBC1kw
uVZVq1270k1xG3aXkRoh2BJTpvxbeQaHwAExQoIHKBpstz6RJHveOkpAg9NoZ4aH
fuVH5UaufzYKEUNp0k/RVQ7DtUgACaPrtmjQiqP6h8t2LRoTkwNaLGcDP+SH55kH
xFtO/8BeJxPYh74950YHne7VhLmr7fqmPSCvIVnC2jslUTuIXs1Me9IAWEaF4fl9
rFou2g2lyNgqQz6ZLBNO
=khIQ
-----END PGP SIGNATURE-----

--SENi13OXelf/Rv8V--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2DXUdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:33:09 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60301 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756888Ab2DXUdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:33:07 -0400
Date: Tue, 24 Apr 2012 23:31:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: balbi@ti.com, Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120424203150.GA9176@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
 <20120424121619.GF8444@arwen.pp.htv.fi>
 <4F9703C2.50002@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <4F9703C2.50002@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2012 at 01:49:22PM -0600, Stephen Warren wrote:
> On 04/24/2012 06:16 AM, Felipe Balbi wrote:
> > On Tue, Apr 24, 2012 at 03:05:14PM +0300, Hiroshi DOYU wrote:
> >> The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> >> High-performance Bus (AHB) architecture.
> ...
> >> +static int __init tegra_ahb_init(void)
> >> +{
> >> +	return platform_driver_register(&tegra_ahb_driver);
> >> +}
> >> +postcore_initcall(tegra_ahb_init);
> >> +
> >> +static void __exit tegra_ahb_exit(void)
> >> +{
> >> +	platform_driver_unregister(&tegra_ahb_driver);
> >> +}
> >> +module_exit(tegra_ahb_exit);
> >=20
> > please use module_platform_driver();
>=20
> That won't work for a postcore_initcall.

aaah, indeed. Missed that part ;-) My bad.

--=20
balbi

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlw22AAoJEIaOsuA1yqREq84P/R72MEEXe6F6PbkEFz/0R9JJ
cem70Bpc+YsyF9+h2XEC3osULUxUiPHSTijFmKlPw4+gxQWAOreSRCgQHwUS/i83
FtSUSnGP3jl/bYaO2aSmwcw3qpPl5z43xcTRQRy//qV9xlNf3OjUIQ2tTZazvqbw
UhkFYOoqt+jkhgxfnz/wye5zDmgWmQry7cv4//PoSzIux1Fm17P1iWsqTq9vWJpY
22kXT1XrAHSyti4rQI1ZGUSP7+G4vfUCatXw/+natmXSI9ea66BQyfZsNtI2l5vE
nhxeFfUiwHvumdpMkbhL1PX3EqUSI8k51qHmM9h2sF5ce9gBuJYRUoOihe7tUN1O
yctJUg6FDdZuN34+PyXIHNZMCbhA02eUYmnTTIAkwlRFPwGCXZaa7AarzjPQDIdA
lNqqmQ1/T0k+D/e2fHPGFK4sMK0hTwprnQLGdOda1byq2MfVooSF3AhQhFw7bLS4
OLSm9/OIx+00ew3SgIBoKiUFqq1nwBiELkwz6vtrawtdBeeOtpVEJGz9OVkNJiGg
5Rfv/RLKfK1EDfRhLv1ojmgME3UWSfsWbk55fktvTL+2548b0F6WqpsyNsutqHP0
S7oV+O/BKhcekaCkMKYM0v/3lB+uUu90YxDoyDwzICH0VIZg8npw0wtyP16AaW4X
BQRqfHj0X4f2u01laB/j
=4qYS
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--

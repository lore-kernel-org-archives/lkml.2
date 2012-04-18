Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2DRIfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:35:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50566 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab2DRIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:35:34 -0400
Date: Wed, 18 Apr 2012 09:35:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/4] regulator: tps65910: Add device tree bindings
Message-ID: <20120418083529.GB3021@opensource.wolfsonmicro.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
 <1334710829-22777-3-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <1334710829-22777-3-git-send-email-rklein@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2012 at 06:00:27PM -0700, Rhyland Klein wrote:
> Add device tree bindings for TI's tps65910 pmic.
>=20
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  Documentation/devicetree/bindings/mfd/tps65910.txt |  132 ++++++++++++++=
++++++
>  1 files changed, 132 insertions(+), 0 deletions(-)

There's no actual code changes here, this should be part of the patch
adding the code, especially since there's only one patch for the code
change.  If there had been a series of changes it'd possibly have made
sense to split the binding document but when it's just one patch it's
easier to review together.

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjnpxAAoJEBus8iNuMP3dCBYP/2hVPRPB4ekRf+/m6MYtDvCq
Xq4QAxv9ZXyL4fE79FVxuFMwk5Svm/aqfg5j9GnUBJta9Ppb+XTbhFatDKO6shbj
KCHxpflc7m6m9PfBl4sI7bAehrAr0UbgXB4l/r9YhdZ1fpHNq0S26EJeqS0T3QiT
FH5apnI7TfkqeX/h4QhipTM/SiogLthVf7xpK8yinP6PMwiRHHzv4SlWQXfjyopq
pIXu4eWFlgUAQFXefcAQM4zFIXeIVbsTCLLlw7sFYIrF1D+c5FVK1XySdY7OWBT4
ZYpRoxLU2JpEZxYMKpZ3mwSDFXspmSp+I7UiCoiFdpswL+VdXagK5TSxEFY5Wdqp
sFMOAbLpDxojLZ80f+BCOROmtVXAZZgnBgD6zT/qM9QYuzLQ9SU80XTCOH0DpzVm
4G8HOXBuG7qx2ehF7z4a5n59ToYOLS6RDV2CIBJJQe18X0zT2nNenwuNzaHsWbj/
vTKFBS1uV6Masj+IRKZoS/YjMexgtu9BpS62K+AOEBTFaNXJFdYwNpCjAbZnPfIQ
un18gBGiCOPP2WPVRVV/EsGzsOjQJyCO4FNDRhjNA1dEudRDT30eAxIbjaecr3Ba
5PQ2DmLIGZ+X1TwfhnGpfHU6d8rAh6ftrfDNnFi/zF0KtbE3HW5vRxD1khgBFIiK
XEHqw8A/UtWJZYamvPXu
=YUms
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

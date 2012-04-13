Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2DMOcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:32:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab2DMOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:32:47 -0400
Date: Fri, 13 Apr 2012 15:32:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH v2 1/2] mfd: da9052: add device-tree support for i2c
 driver
Message-ID: <20120413143243.GW3168@opensource.wolfsonmicro.com>
References: <1334324261-5476-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L0mHLbha4YKvhGtu"
Content-Disposition: inline
In-Reply-To: <1334324261-5476-1-git-send-email-paul.liu@linaro.org>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L0mHLbha4YKvhGtu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 13, 2012 at 09:37:40PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +		regulators {
> +			buck0 {
> +				regulator-name = "DA9052_BUCK_CORE";
> +				regulator-min-microvolt = <500000>;
> +				regulator-max-microvolt = <2075000>;
> +			};

This is more of a nit but these names look like they aren't terribly
idiomatic and could just be omitted - normally the name is used to tie
the name to the supply on the schematic so the above might be "VCORE" or
something.  If no name is provided then whatever the driver provides
will be used.

--L0mHLbha4YKvhGtu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPiDkFAAoJEBus8iNuMP3dmPsP/2dsHyQenKm02tknKXf3Ihnt
hajwLHUZopKM+0u2nf5WbNSaMugVOR/OxZ5yVuGFkgkqgAsciQ1F9//6l2ZPQIbj
A5CvGz6bdhkAgUh5sOhWT0s6pvGdJxbmJARExtCJ2iBAw/XagLTT4AGWcZtdnZuI
UxvGAZwTb3anLW/YKOGJDgMLXUEllMyq2sagF5s4VlgjYMqKiW0UGNilMdYYB6q3
thFhzd1xVkoXPWdWSBx0M2YJXqGn8q8Sv04Jq0SI3Dze6AmnoqOTWMVmTjs5VA0W
8Nn1ZNRDqE43CS7cIgv+l2lZuW5ELl7sUtt8NNu1xbtxE6nYBLL/qU0vp8yu3ALT
Tp/SOdrIymaonGsNv87+reNYZGOho9QqZjFqSfsOk8lovs2JPeSBOGZMeoPI9Kwj
UCvNRsVMU6Vz4wlDIVn3AmSwYEZrL88XkyGEVicNuFcnNnvP+0y0SCM5ILRxii7e
clsbDR+QTLlE7coniLh0Q6yNIQTcZeEQqccKNLeMn+189M0NcijgyJ/xx8TMhLa5
aTT5lUbAMFBLs0hwWQk//DLPlqAO74gUdUOukhW227cQ+hK3LTWVgPO8GDk9AG42
OWbSknWhJo5EnQ9fWvSsV6LHhknAK7By84psliywuOxus5bn4uZqhoU+6OY94Gz8
OQVOtmyD/KKaH2cqJQqi
=Bte1
-----END PGP SIGNATURE-----

--L0mHLbha4YKvhGtu--

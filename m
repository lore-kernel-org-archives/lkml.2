Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2FMR6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:58:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52127 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab2FMR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:58:45 -0400
Date: Wed, 13 Jun 2012 18:58:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, AnilKumar Ch <anilkumar@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Message-ID: <20120613175843.GH7804@opensource.wolfsonmicro.com>
References: <1339558031.26190.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Content-Disposition: inline
In-Reply-To: <1339558031.26190.4.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 11:27:11AM +0800, Axel Lin wrote:
> This patch converts .is_enabled and .get_voltage_sel to
> regulator_is_enabled_regmap and regulator_get_voltage_sel_regmap.

Applied, thanks.

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2NTMAAoJEBus8iNuMP3diiYP/1Ae7Dr9PfHG4+ixZoGy8b/a
aFIoUCynGX3A1EfhWIxryDyW/dCbgmnidmpW029lxiGmQuoCUXMUZ4VqNaKo3WjS
ijK3bBRUzkxep09LkGTJkMwmncYpb1MfYdEJ7/DbCbjHRqYAZBPWJw9koPnlETSR
S4gI+O3PiAfddqA0puqsln3Qo15S1Yf92bFuMF9+zF2ZvlIvvyqfMS2ysGJYiFzE
hDX0ySxVIWWgGOAUiGUAwvxIKz7pxfp8Uy6c1tM54DLPc3JZylwWNTx8KSvi9pay
oFCO3K65KXPidqikBPoHGINULkmcn/PWyjDazAnL9fWaMTtl902BCOrZBnOrvqTN
TjvqU2xnHVmfU5HRqv7dpTXLwsQseEeR9Nt3krd3Xm8bdCPz5oQuIz8A5hitcYbz
OaEGJ6x2vWB3vAB732402SrInys1OLL98oxSztzLTgPg3D8vMWEYvL52bzGDGTX/
5/GENNaMA+Rb4LCU/QOoxe4aybg7JWgL8cvqRiYUfiVM+QQ9VOqsSkXsuxvQYxm1
22DCykAkOLQdNIhrMGa2Tr4g9eUfZNlnKlQM2tIWHFIOtZIeJdls9eSQrDLUXQXN
nr2X6RMBA/7aCB9MwDR0J0UUIgL/L/5vwCPyJMtvBhU6Myi9mzve2RAszfEjXPMm
Q33kcpOrNpFgs17GDrLq
=Sc+R
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--

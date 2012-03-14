Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985Ab2CNMjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:39:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42614 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760930Ab2CNMjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:39:08 -0400
Date: Wed, 14 Mar 2012 12:39:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: Use tps65912_set_voltage_sel for both
 DCDCx and LDOx
Message-ID: <20120314123906.GJ3133@opensource.wolfsonmicro.com>
References: <1331691525.3782.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aznLbwQ42o7LEaqN"
Content-Disposition: inline
In-Reply-To: <1331691525.3782.2.camel@phoenix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aznLbwQ42o7LEaqN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 14, 2012 at 10:18:45AM +0800, Axel Lin wrote:
> commit 42b5ef "regulator: tps65912: Use simple equations to get register address"
> uses tps65912_get_sel_register to replace tps65912_get_dcdc_sel_register
> and tps65912_get_ldo_sel_register.

Applied both, thanks.

--aznLbwQ42o7LEaqN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYJFkAAoJEBus8iNuMP3dnSUP/2VTC3g7DjR9zt5+VwQ99Xdh
dcyQxY5CkXO2EzKxI2dvAFnK9YadSa23YDyrPkbS+jIBF8qq8vyHrhjcT3Owkp+K
PL3vtw0MCoqk7azGDPxmt/C/z4tMPljvhiEv1CFr+U0PsgidAvQkV1nw1TAOtqWZ
kZ/5M4OqN8N7Lm2LudbSnCq0HruRrT5wJ4f2qMk2v+ayiTIgUBgGCxZLuSCYOPcQ
vAN3GXf8NZ60E5y5gdc//ZP3ne/tvsJ1hzTM96et/6QMs3Ckg8IzhcNjI2n6V/C3
Eghg61YsP0Dtziw+skikphuXl5/TG/+ITr+96kkb4DleEt5LCTTgxIxG6h/TLPz6
YTiqG5V6j+WrfaqPTayTPxB1GhZ3Oce4rVJ0QBZmbcUg34h9irwGFW+w7SSXSQBS
cb0+X/v6Kmp2bmOz+qKA56BF2CULT9dXnnFnK2Z1E0z/+wRzWnMGIZDvP3gZgmy+
1j6fOfCGRAB3WRn9vSP0bgwbvU1xYHoWEwfSbssTW4eEYtfvRthiMtRF4I9Gdosr
FomFPWpPnZkcSE9Mv+OZdC8Hulkp1lbCaa4N9FLTn+mzm3TldgRnceWLEASHJqjb
F2MTyDdd95TKOmO/czPTRub7cd4vRazKXP8A8dMs0dkBNwN8dsm9COHWbBC236HH
IDVaabnBjVwV1FM0VTRd
=+Qlt
-----END PGP SIGNATURE-----

--aznLbwQ42o7LEaqN--

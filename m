Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2JQNTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:19:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39688 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075Ab2JQNTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:19:03 -0400
Date: Wed, 17 Oct 2012 22:18:57 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65910: fix BUG_ON() shown with vrtc
 regulator
Message-ID: <20121017131855.GQ14199@opensource.wolfsonmicro.com>
References: <1350303358-13667-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VaKJWhUROU/xPxjb"
Content-Disposition: inline
In-Reply-To: <1350303358-13667-1-git-send-email-anilkumar@ti.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VaKJWhUROU/xPxjb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 15, 2012 at 05:45:58PM +0530, AnilKumar Ch wrote:
> Fix BUG_ON() error if tps65910 VRTC regulator is used with out
> rdev->desc->volt_table data. Recent changes in regulator core driver
> which add support for "regulator_list_voltage_table" have BUG_ON() if
> regulator descriptor do not voltage table information. This patch adds
> the voltage table information to fix the issue.

Applied, thanks.

--VaKJWhUROU/xPxjb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfrAJAAoJELSic+t+oim9sWQP/RetVEZ8Qm5U/N+T6jwN7vCa
s5yR7Am7uzcXDI6MKsQ9Zndv8fGQ6lTI0fV/4V10GuqxCw0BaFUkPILuyOIbpnOC
gIY7JmF6gh9BUhdJdg49KG9VVlbOHC/uhG0GHRw4pfgWSI3NsEnxVf3joLlZGlTM
t+LPpAgboHz1Oszhm6moK8800RJRtW0jOwTRfgoeBbSNX1Fhyan5T/toqSuPtDeW
0NA8UOyCZXgwlPqxcXV5bzMNvtNfz8pahBLQR71a6sUzvaPm9BU7KL2BamRJan36
P3+vnaOsLwph51e7OVjsz0cDUGW3ARARlHIct09iaVfmzX5TtKN2Wct4iw1e8Uj/
N3BijgaCcU3rmbJlVurls64/pOjcanXUbCCQrWV6BiYS9R80Rsm6VVT26kLpsB1S
12UpV5WPplGQmj9z2rDsNI9/zleKYr/Uy/6b3M8ZJXznBrcmp2evDq+61IT0XRrD
RkwnwclhSt5cLhioflrEDCfHQPJITWtJYfvUpNLJQ6blUFVyj8/AfnIzvnU9bVVU
amTK8WfmcnmzJvpfMDM92JAQCnumIofr/iYEo1m+4TPLWKo8m6R492IC51yCr3NY
M9unT6yghukA0CK5SgSIk6uIdy4Yz7d9vwYwKDp3iU5NVJ2rb9+hgApkdG0aWaH1
Lx36pJCxeaqvuA30fz3m
=pfrc
-----END PGP SIGNATURE-----

--VaKJWhUROU/xPxjb--

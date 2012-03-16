Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2CPSpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:45:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34526 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab2CPSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:45:17 -0400
Date: Fri, 16 Mar 2012 18:45:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, Arnd Bergmann <arnd@arndb.de>,
        Rob Lee <rob.lee@linaro.org>
Subject: Re: [PATCH v10] mfd: Add anatop mfd driver
Message-ID: <20120316184511.GA3158@opensource.wolfsonmicro.com>
References: <1331885816-26902-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <1331885816-26902-1-git-send-email-paul.liu@linaro.org>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 04:16:56PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPY4otAAoJEBus8iNuMP3d/wgP/i0bonmxZ0czSXcRzD1iU5lK
BEg8U+O+/bLDpzgbRUO1t8OPY3JGAA6TPQfl/+eLJ4IhIoWRo6/Rt8pZ0s5bVTrY
S34zIfMorzBgE9/r3tnJiCdQJ3loFI7UPZEnH+qdAJQFxMLMtXe5TeM7bPtrOL/1
0Xn+lmrUHrNAi501OCtknmgOsR6sufjlxnsb3f68YBQVwKSq07vzNZE1eEci0Wso
LyxvgEB8oYEP4tkTOdeCGfVD3/3NpajlSxe5roYvrmgk2+p0ng4yC/2KWkPhBn9q
hp2bopA3iA2HLL/gOsST1fUXvPLnFwmrHiFkMfvmtG4cV+vdScFaZKrMS2Hf7mqf
xgsuIU5/5y+tVEtSy/NvQDFqLBT+vLWWBc7euNN9MBkPF2NV8Du2jL5WKpEwbUVB
WXnH6xjCxN38xfVT8l/pb2ChegkLKAizgYLAFjKjvzHO8d10KnVwPyEE3bljr6ua
qhtjJfDtNEakxgybhuLZHPAWSoIhc2KWixOjZnQst9+dNU0mzInbrbAToGYbXnT3
S5A8A4miZyb0V5dPvaOox0eMcPq2+70lPwucekUq4P9NDryryhVd+wYUy4QrZ3XC
OdHUng0niMzsu85szydQYRI57jkFRS97u8joEH2amS7pP+UlywKAkC5vIsUF5TpG
HzN11QPX8KIU6sMJ1drN
=QKZ+
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--

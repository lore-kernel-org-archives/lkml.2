Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab2CVQC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:02:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741Ab2CVQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:02:58 -0400
Date: Thu, 22 Mar 2012 16:02:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regulator: Add TPS65090 regulator driver
Message-ID: <20120322160256.GK3091@opensource.wolfsonmicro.com>
References: <1332421449-15656-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRokNccIwvMzawGl"
Content-Disposition: inline
In-Reply-To: <1332421449-15656-1-git-send-email-vbyravarasu@nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRokNccIwvMzawGl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 22, 2012 at 06:34:09PM +0530, Venu Byravarasu wrote:
> Add TPS65090 regulator driver
>=20
> TPS65090 PMIC from TI consists of 3 step down converters,
> 2 always on LDOs and 7 current limited load switches. The
> output voltages are ON/OFF controllable and are meant to
> supply power to the components on target board.

Applied, but...

> +	rdev =3D regulator_register(&ri->desc, &pdev->dev,
> +				&tps_pdata->regulator, ri, NULL);
> +	if (IS_ERR_OR_NULL(rdev)) {

=2E..please submit an incremental patch changing this to plain IS_ERR(),
regulator_register() only returns error pointers.  Note that no other
regulator drivers do this check.

--wRokNccIwvMzawGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPa00nAAoJEBus8iNuMP3dQsIP/Ati7M+C9h8Ru35P5hjQxTC2
MjKoZNTukrhbsEAwBd8re0DBbu0uS2gpHd0i+sZp2bAVXGUTbtH24NWsM2ppK+9A
hW5GH4uvJ17IZbLKtZFOTtCxzuBuhLq1/jHpHf68THnYH8KZmKsc38tSfspnhXMs
alARQ5m+9lTHPLUokaWGckFJQD8A2HpBhfgDE/uXPF9jQ/bZk4DyiRTn3T7gxsdH
QFIN6xD9g0qgnaJVQvUHOtoyOBicy8OFKAuaZfbplLJ4r9zLbNBxwaORZDseK6Ya
tOuxFCYrKv+5lJ3uymqmmRlKuUGMX28SndEycFG+3buTzibcBmtnZMxtMkshSdpO
ymU1U+WegWDOv8MPvCqlefh/ZiNpWk+VsYyYxpXWOCrV+OFGhQ55mkKsi9nCQT63
PRlD19q7nRergr4CuFp4CTW+/JvJd4uVIkWmEvWcceTzMthn0de0qJGCwvYsv+ed
FdpOEx3AaC8KDPNzN602EAIIpuqBL4YgXeKHB8etEPL8JZK574ZwYNnjD/in+kIS
VQ3FUtxuMb7FUq6sR4jJXWkIf9gcMZOZsDcSAVlys11tUtuGnW1+qgb8hoBbLtyA
6CflhBINxQ17GfvfqCr3l6qTZVlvdcJvaCljZtIgbiafefFNXRHk5s2RZXYRoUkC
jRwkMAn4oed5UNTk7Xpf
=XsjO
-----END PGP SIGNATURE-----

--wRokNccIwvMzawGl--

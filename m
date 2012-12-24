Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2LXQ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:28:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41289 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:28:09 -0500
Date: Mon, 24 Dec 2012 16:28:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: lp3972: Convert to get_voltage_sel
Message-ID: <20121224162807.GV30837@opensource.wolfsonmicro.com>
References: <1355140012.6601.1.camel@phoenix>
 <1355140212.6601.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R10gueRtU1pFqy+X"
Content-Disposition: inline
In-Reply-To: <1355140212.6601.4.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R10gueRtU1pFqy+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 10, 2012 at 07:50:12PM +0800, Axel Lin wrote:
> regulator_list_voltage_table() returns -EINVAL if selector >= n_voltages.
> Thus we don't need to check if reg is greater than LP3972_BUCK_VOL_MAX_IDX in
> lp3972_dcdc_get_voltage_sel.

Applied, thanks.

--R10gueRtU1pFqy+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IKQAAoJELSic+t+oim9ePkP/jX2xypWCAEN3y5i8toCmODB
cy5TTaYUQ1ckra71Z7NAPjx326L6NISsVbZAwZqNI6IlHpE5ZSsPfnoibkR08s0y
c8k5ca+hcZl82KNdFJ0/NqmpX8V7r+r6/H86vf4oWH9CEMf1z2069g/7ibHS8gNr
JUMdEt+qOTi+5GDU9BhsJPbeGYaQ7cLFUIRigMxVueQshoSyB/Qs11x4u/KXtA26
epMnVAsSyjJ+U5nZUkKjASFWMqxJa/jvD98WNmvVvzt0ryeDOSnPIgciUEf4mbpM
RYDndufqev9MvAGNRgti8OT89ce1/ZRlVtZ8j0axVmWeABRcQLiS4PdPIRhX+TC5
j9lNdF5SfhJLEkIzPSE1Eth5ns5dWXRTdCE60873uxGrP5bpQER/F6dO/nOyAbU7
Jrbz86mre3x8Bht70RqtVTrKGec0b4q1rav6Bo2LcSRpm9LKBlCTGL64n3DGHFd5
OShH+ppLwbWdD0bSSkauYfyTjmLdtSR4W7fokPJP296HvRoyQJ0AeQc5beznnm35
bYvaSRW+WIpk05Fyz06S/iimkepPhHpA4fPdGpjwrEm/74664kwiU+Y2bNFeN+OV
gMbpllTe79n7cXy6XNt2p7RujcSmdPXPPJQikdbMT8Ze+Hb4zOTFW8X9X5M00PJk
cbQS55AIhBhXPr4g9HUw
=N6A0
-----END PGP SIGNATURE-----

--R10gueRtU1pFqy+X--

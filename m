Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2HUSum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:50:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33489 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab2HUSuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:50:35 -0400
Date: Tue, 21 Aug 2012 19:50:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: core: Push irqdomain mapping out into devices
Message-ID: <20120821185033.GD7995@opensource.wolfsonmicro.com>
References: <1345573220-28648-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="La/RrqhzniGiVaa5"
Content-Disposition: inline
In-Reply-To: <1345573220-28648-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--La/RrqhzniGiVaa5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 07:20:19PM +0100, Mark Brown wrote:
> Currently the MFD core supports remapping MFD cell interrupts using an
> irqdomain but only if the MFD is being instantiated using device tree

Missed checking in a couple of the changes, will resend soon.

--La/RrqhzniGiVaa5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM9hQAAoJEFJkBDiqVpZ4XVMQAI/NPZL5sMPfT7KeLThL3b+5
eTYD+4hJqaaZ99YTZKsKNR5fgJHyIsMbiA567DfzLr5aNhT1QqoREkrNkDOY8foR
wUdVKk4+PV+tM+7FbcaktqrzbwIZCQjYiDkBnZ+dvDeYRIMr/zc2bslw/h/vl/6R
WYvAPcWd/HPieKRBZ/eU2mJTiUcS/7Gz6oHpfm3vpnsfEWEJqRMaCfPu4KfEa7Wj
4ameP1aq/GQ6E4WKtGHTcyAZdMGGz42LZEfsLX+/KEL6KRiqPcq9jmL9tVpByo7f
WK6LXRy95HNf6uZG/bPnJ8iS5tLgFO8a7yb4tH8bG2IpIPBqE5rqEefaPZajz6Ti
V5Ln3nQTxRBcBtTsqncWJdrUm2EtTMSDtpNkon9x4QMVM46iw63ofCezeUhUPzBc
TYOw4OzwjhMNj3j7xImihseTrmpq1ziKehPiwlClvKFVfNvXV2xCrhOI0u0AULI/
+5fb2vXK+fZkbe2y4FGsRXujBiLlF9PeYurALIfn8mwnyLYr9O2Z/IM/uDVyz+Vb
kD/1faZNEIjuqq9FqH4SYr95ejyti9bQQ7LbAiIPhuqgxZNjxCeEb5WwJf/ue40w
E7Ic9SXVgZhkSF238+WoRKBhgaE8+CWw04MU+jjAah1ZwNBrmmtz9NHE5qnvKROG
KS1sh26bfCFCB5vaZI6z
=t3g4
-----END PGP SIGNATURE-----

--La/RrqhzniGiVaa5--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2FSW3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:29:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49890 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab2FSW33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:29:29 -0400
Date: Tue, 19 Jun 2012 23:29:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC] regulator: Use list_voltage() to get voltage in
 regulator_set_voltage_time_sel
Message-ID: <20120619222926.GC4064@opensource.wolfsonmicro.com>
References: <1340069925.7937.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <1340069925.7937.4.camel@phoenix>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 09:38:45AM +0800, Axel Lin wrote:
> With this change, regulator_set_voltage_time_sel() can be more generic and not
> limited to linear and table based mapping now.
> One side-effect of this change is that list_voltage() must be implemented.

Applied, thanks.

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4P1AAAoJEBus8iNuMP3dTAgP/2dgV5uaglcv4CnUbJdoT1Qd
HKqcRvI+eVmydI/WPRs928vnrP/IoDZoVPtiKrOY2h1x1cy3MJKEfxKTcelpN8U3
YU72lkhQ/zICJYRYZoIPZllKfTKwlx4u6vtGSeTdBg+rnISjCX84r1APRi8B3CQ9
aK20QyXR045KCrverzLU0aG963reSaXAqlkd/rMlU2L5bqA6Uvz0aZ26Jk6C06MK
FIEQBUYwB9CtWd65XKWcPFbOK5/HgQ5daZizjYGDFKggqoKloDu/ZWnHEkzKUdlp
ChwpjyB9VdaNWDSv+27y/VNIN0W0tyS6D2RqplzBBLZxjH/FGZPmESua7ng4Oj15
+aMSAav8SCBLUiZtdGWa8o3bUmLvbieH4qrlaim0IXYQFt+vAU80Y37uhJ+ujH4d
E577clp2FP8YL8bQnsapbxOANiwC9wja+ppIY/za+Nf4r2wEQQnrnpQaKNdCcF2B
W8MYYeJHglV4DWunuJ58GDeof+u7OtzH8eZ+laG4Lfa3aPd4cRqIuo6F43f8zyI7
vRFKiQJBKSjkfZh4psdvj1lVmFHdaymcYI3sDWoznVAKQJFpuyckBEzAMXmfBn4N
Pg6uxzNIExecCZR12c6OuzLkYL6Yu8e7iM6U0GFXHG3D1CniZMsWvzNknK52kLLw
BgGPmjEygUCmZT6enzVC
=qtnU
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--

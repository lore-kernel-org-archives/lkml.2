Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab2FHA5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:57:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58911 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab2FHA5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:57:08 -0400
Date: Fri, 8 Jun 2012 08:31:53 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Liam Girdwood <lrg@ti.com>, Eric Miao <eric.y.miao@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>
Message-ID: <20120608003152.GX14525@opensource.wolfsonmicro.com>
References: <1339052505.5882.2.camel@phoenix>
 <1339052552.5882.3.camel@phoenix>
 <CAF+7xWnXw0UU+wc7fsoERi+YFn-p_rSrpzZS5uyDXPQWSfjLGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p11K2BJEgMZL61bg"
Content-Disposition: inline
In-Reply-To: <CAF+7xWnXw0UU+wc7fsoERi+YFn-p_rSrpzZS5uyDXPQWSfjLGA@mail.gmail.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC RESEND 2/3] regulator: isl6271a: Use
 regulator_[list|map]_voltage_linear for isl_fixed_ops
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p11K2BJEgMZL61bg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 08:08:41AM +0800, Axel Lin wrote:

> Oh. isl_fixed_ops does not implement set_voltage_sel callback, adding
> map_voltage here
> seems misleading. I'll send a v2 soon.

Please send an incremental patch, this is already applied.

--p11K2BJEgMZL61bg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0UfwAAoJEBus8iNuMP3dkNgP/i2xbQLC7mDg2bq+77WkNUkS
o8IbwrCumGS9tyNoOZtY3F5ajcGK8At6RUpqH/8RWk50/bD6seDlpxZDs+N/r7aR
MMr4iC4H84/gBryRlCEE53e4KlR78YWcB27Ml89nrThpWmyn9q0aOhwmkU4Q+lf3
NFVsArJ1sj17rlLr7YkEMRd+Zh9graXRtJhW09pdzkGX+6RC3PWhnVcOf9iJLCQd
8TOJN4MI7djvF8T6EYxADb4p3ozv79SbJHH604fCl6fvbp2QEVAXxznbsXTqEgzY
go9T1qU1E5zsXufJSqsnt4PUWduD6j5tUyNxzg0RTghPvIg+L0DtvMb7OB1YGD2O
GJCtRw8C/KW/pczMqfjyztnLfuygoigGHP8I7kxdbUK9a764DSk6y8Ljc7AKbheB
GJ8/ncfJZEwD6RVZP0/yeXyzCvBJ9cqfW8uRYiXWBWV9bSGaERYk13tzh+ghCc4r
R3BV+tFyVqKVxWlggIyXY9NrLCfeqth4vaR05mL8xTxkLjhvkJPWgyn8UehO+MmF
yz7+k7+EvbvdmsQ1aJWQixqqVG9LZ1A4ny8rhm8+jzTYlfBCjFcqvED1KCdAv7Ze
DlyatLycFE1WZoRBKp/MSnEaXCWmOJaM3WdUfXoO9xkWpLwiHtYNZ8Ssk2kweThO
CJkpQxfUz7wdD7PO3gUn
=j1j8
-----END PGP SIGNATURE-----

--p11K2BJEgMZL61bg--

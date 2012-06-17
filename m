Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2FQQzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 12:55:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60279 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546Ab2FQQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 12:55:54 -0400
Date: Sun, 17 Jun 2012 17:55:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: ab8500: Use
 regulator_list_voltage_linear for ab8500_regulator_fixed_ops
Message-ID: <20120617165548.GA4267@opensource.wolfsonmicro.com>
References: <1339122469.5794.2.camel@phoenix>
 <CACRpkdaUVMp+VstcSsWCQ-5Oe8QwcQL5Rt41Xm7kR2parUDgVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <CACRpkdaUVMp+VstcSsWCQ-5Oe8QwcQL5Rt41Xm7kR2parUDgVQ@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 17, 2012 at 04:24:52PM +0200, Linus Walleij wrote:
> On Fri, Jun 8, 2012 at 4:27 AM, Axel Lin <axel.lin@gmail.com> wrote:

> > Also removes set_voltage_time_sel callback from ab8500_regulator_fixed_ops
> > because the voltage won't change. ( And ab8500_regulator_fixed_ops does not
> > implement get_voltage_sel so set_voltage_time_sel won't be called )
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>

> I cannot test this either, it does not apply cleanly on v3.5-rc3.

> Care to respin?

This is a random development patch which means it'll get applied against
the regulator tree as it stands so that's what the patch should be
submitted against - if you're going to test then grabbing my for-next
branch is the way forward.

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3gviAAoJEBus8iNuMP3diooP/R/SMSxTDh/Vus1/9b+v/5Ps
VOfFUtHqpXg7QSZ7xavInbA+1X2J4V5ihDzXzEYGw3hIEQc9YlkKt2hKTzRODF2u
LwJ4RSCcByOqupwx+DeXC3NnbmoQRdzWMGD5vBTGm8+Vn+aTYc9dQW8MSQ2dGXrv
bGdpeXcchT3zt2IQv8sOinWj0xAiIlx2tnrUCWJabG5bSWD/a1LjDZwH6sr+mFKk
cUmPxGhQ6kjiOiHbeJYYAajBeqiHv6sWcDnm+BVn/UGV2kUhkEPFcXnnAB9MtHPa
UOYKmNXxZmx3ADV/c1sDwxTSE3BFfpYka9G8APPhkjFIkYTj/+t9tV3UmAzpWJLW
pIyG6cfSZviiCVQa56SCwVJ7AGFJPwkDcBcV3KV4vPTE1ZlX96Ba2yPUZmxdX7vL
yKfIZ6I9/N+/HRjTc3LoJYRQEnyyM2faAzPG2bclyspw0BzJfEbdSv4j8YgUoETD
G4X7eTpSGArhEu2OXFWPcJ2ZePDUTVVN5uzmUssN4TalFQUR9I4WuvknETSQoLaR
tpzxcZ/LjZTR5b82O9hL9cxosrF3JTStn2ef+446cq1kKV540t/j+jGCktMEltL3
U3LGnkNE3gpFhlBEY6HwsIDJ+4E1EL3AFBhk5SqUwrpXS21ulMrBlv61Rh2jyTPJ
fMc4vPvuYBVb2H/ZKiPb
=xjO5
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--

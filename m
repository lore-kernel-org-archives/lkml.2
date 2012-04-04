Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2DDVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:14:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38226 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab2DDVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:14:18 -0400
Date: Wed, 4 Apr 2012 22:14:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix rc5t583_regulator_probe error handling
Message-ID: <20120404211414.GD10787@opensource.wolfsonmicro.com>
References: <1333540355.5672.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <1333540355.5672.1.camel@phoenix>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 07:52:35PM +0800, Axel Lin wrote:
> 1. regulator_register returns ERR_PTR on error, thus use IS_ERR to check the
>    return value.
> 2. Fix off-by-one for unregistering the registered regulator.
>    Current code does not unregister regs[0].rdev in clean_exit.

Applied, thanks.

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfLmWAAoJEBus8iNuMP3d5SIP/00UP7a+hF2JXrJ5lK7wOclg
w93SS1Op93SB5jhyEbHOq8325n4ikvusWA5DQlSgQtpLUjilc3kR4ftLGoi0cj+d
EJRKo4A0vGzfG5hnqmQZ7mrF2IJeDXpwUP/1gA1CKty+bniGf0ZdYKzKRxTfR9an
PF0yb86WOy17YnK0ZhnNwu+LHZq7BCol1bn/Ryrp9BoZ0rpCMP5mbE87z0DeWwY2
/fyyIHBRZLwC+Lh+A/EvDB2NZ2ukA+glzA3f8hsuzYm/EcVrrGWsC6kuevH87N2T
/VOBGqz3vK1F05zTHqOh8rlcgFm+Ejdf4T8y2uooIdqjdOAfwkiyR+KwGsPZpPLe
po9E6CenbpJsxSICSpfCk9T4xNegpkim2kelcnm48YyABl+2n0ilKJBZADNWUmAH
AbHYgKvWD2x7VTWpqmBXIvPmwFlr4m4go/BYzApfx8FB4j0JAME685VX615Dq5UM
svrn49JLwv+2hWohDsq2igEUYvE+47OM9JONlGYeHCWWDMJPkrh12qs1SxtuPCS+
3nar3AMm9GD1WAFknm9DW44oxbgpBkXS3nxOdX+JH3M9MDLQlmQ5DpgTcua+bYUT
4zFfj58QBk5LWJtIX3GGco4X0v/mVVTBq4QMQkWZtZ/HLmGESC43SMaploSWZJ4n
Q8rumusOPi8Y+/c7wSke
=VqDg
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--

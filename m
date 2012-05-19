Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2ESSB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:01:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52515 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686Ab2ESSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:01:54 -0400
Date: Sat, 19 May 2012 19:01:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] regulator: tps65910:  use self device for regulator
 registration
Message-ID: <20120519180150.GA4039@opensource.wolfsonmicro.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
 <1337438050-3707-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g3W8FGNyQaC+nhss"
Content-Disposition: inline
In-Reply-To: <1337438050-3707-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g3W8FGNyQaC+nhss
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 19, 2012 at 08:04:08PM +0530, Laxman Dewangan wrote:

> Use self device for regulator registration instead of parent
> device.

What's the motivation behind this change?  I'd expect the MFD device
(which is the actual physical device) to make things like dev_ prints
have an actual physical device which seems a bit more user friendly. =20
Making this change will also mean that things like regulator to
regulator supplies are less obvious on non-DT systems as they'll wind up
having to specify the subdevice, and on DT systems it'll change the
binding from being for the parent device to the subdevice.

--g3W8FGNyQaC+nhss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt+AIAAoJEBus8iNuMP3de8IP/j3Zdd+5VDGQQ9ZKGzi4Pywj
OYpQAKjSTMB9fSYnyzsMHx9aZWlkKSQby2DU/TJsW33UYTw4g/sTQon3tbXkTl+a
0FUNOuFYS4wghU8E/CZJ7ctn3hkKoxAbwwDVgZkQ1ThP0+o5CG4jY28eDnVA+5Bv
1UByPyzZ5JKNK/roCN50uqQu2hY3srVQAL3v/FdI6ZaBJJBmpAp6SztSMuRg98sU
3mjVPc7jwOKd7E2lUwnIJ502JlDdm+dU/e5H4hqW/E3HrEENuW6W2ABE88o0RHVZ
ShfMNQEb12YuzbE9KNYoVNKHTsUHDmJkLXHVqwS0//nmNJCS1fpLDS/eUdyiDPLQ
kIL8f/tw98ipM/xIpeAZazzuozdTX0HY8WBFQ9dKW6hleI05lWobYLYnfquBNN8j
L+lrpf4Cx7BFMR3P9IOC9tQCJn+qOX1P5Wh5IMavdga4Qcl5dt2vuXo7sDF3qt9u
zVLaAcdK/EAGADmtu7nNCzItuMagyU7AGN2igOqCuA0q+8NXwVREG6VpfmkWis++
gEUThG4vhZNIrbcSrLBji3bITIDb18qP5ZCheI6mDxzl+fjT40dQ+IwQfliX8NII
scNbrEG7qom2ieT9gbp3tGhtFluxcCLDjk7Z65sLvxcDIlyfn+Db+RbcihH5/R3F
1NX5DzfTRLPalFF30bkd
=wxAy
-----END PGP SIGNATURE-----

--g3W8FGNyQaC+nhss--

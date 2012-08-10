Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2HJLfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:35:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2HJLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:35:05 -0400
Date: Fri, 10 Aug 2012 13:35:01 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH][Re-send] pwm: core: Fix coding style issues
Message-ID: <20120810113501.GA19616@avionic-0098.mockup.avionic-design.de>
References: <1344597073-14261-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1344597073-14261-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:RDll6LiXfH9a7bgsJGuKj3+Wf+X4SEB0BXqbm277VF8
 CV4QFyjU1n0xxX4hR6CTjdcxkSF2MkxPs4tS4ZBRkS5MNssLgF
 P1PHIN3JQ9dAGBWSaS4Nkav0CpXIdP1QUi8BEEcF3GXUmckhSs
 3Rj0TqXwAWLCFFg0LAJyi6WYZa1fqEnkGeeM7AOvhTwKoPVj6u
 nRQCfe9ga5kc8qvusfM7OjbxSrUP9Urcdmb4OeJGKEkkhA4n4f
 ioxKLlfLnfa03hxXdipUufMV2x+2PaE6gtRgUQhbcpen+yBrBM
 rADnlndqkSWF4ZtmVieLPqyfHN7elU8KnDHXyn+SxewbCJsbDg
 QSFGFkscPysr/7CY2TiA3MiOIHljyR9yAA7gCkS7uZ0qlyU1qm
 JjzBO0dlEWIAqMeL6A8N6x9bkXloRbZq0U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 10, 2012 at 04:41:13PM +0530, Sachin Kamat wrote:
> Fixes the following:
> WARNING: line over 80 characters
> ERROR: spaces required around that ':' (ctx:VxW)
> WARNING: Prefer pr_warn(... to pr_warning(...
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pwm/core.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQJPHlAAoJEN0jrNd/PrOh1X0P+wYebjhd8VDQBPp43wZ6tslG
CxWDrN4rcKUrbnJekz+eox4biFwYb524iceD73/UV1TyBAcnHCzYghvEdiN1mKoB
Uya5c/+VeA/rxZGcDYCenERYI1XWI34WPMn684bjNijVgRS/yBVCPqhVZjw6x1/b
zRLGdRsAwFgRmjDWYRZA9yLdnaytMMy79N1iPd5sYFGnT6zRrVpKOZc7/x82HBvd
npLULthhdvGPd24YCY0QzSf2IJdpG7U11ezH8WUwweYSMREDS6tikvf1DiEPb972
1I6O6c8sQygs7efd/hdvG1TgrZaw+zt3HHBPV1DIANM2oaM0p5PHCfKxMOKJVtoC
CS+q49ImP9v/gR4iHHkOPTBmilTLtustonnDBhHYZOKDhic3AmXDKG/QY4Zfy/YG
CApak296PvQQFw/VazUdpHTT8eIaItLTVFZX6k9S36CyMOSK42vz1D0opDHmY0Hi
edS8Qb/4LD20wjkR0sUxF2NBEI5SfYXIytBJ/BATWoEVM5mJf7UYhOmfl78MfRcC
7rfQ568+69uCf5JTUdoapZp24UsqO5A+X3qT/cR2bjVQs67hcvyl0QPyVOYWwKh/
icAqgScSKPBd8oXXxtspERxEc2Vtda3GdB+8FQfaPm0a5fmhR7YTMmWgQs9be0BV
u2B0NU7PPV2vY+4YjZd9
=hpsN
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--

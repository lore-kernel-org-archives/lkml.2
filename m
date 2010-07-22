Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab0GVMc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:32:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37277 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185Ab0GVMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:32:24 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Geert Stappers <stappers@stappers.nl>,
        Dave Airlie <airlied@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <4c472b3b227169b7c1@agluck-desktop.sc.intel.com>
References: <4c472b3b227169b7c1@agluck-desktop.sc.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H/os8kns/O0RzPmo9EH7"
Date: Thu, 22 Jul 2010 13:32:14 +0100
Message-ID: <1279801934.4883.355.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] Fix ttm_page_alloc.c build breakage
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H/os8kns/O0RzPmo9EH7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-07-21 at 10:15 -0700, Luck, Tony wrote:
> The commit 1e8655f87333def92bb8215b423adc65403b08a5
>     drm/ttm: Fix build on architectures without AGP
>=20
> looks at TTM_HAS_AGP before it has been set in ttm_bo_driver.h
>    =20
> Move the conditional inclusion of <asm/agp.h> *after* we have included
> ttm_bo_driver.h

D'oh, yes.

> Signed-of-by: Tony Luck <tony.luck@intel.com>
Acked-by: Ben Hutchings <ben@decadent.org.uk>

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-H/os8kns/O0RzPmo9EH7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATEg6Que/yOyVhhEJAQKjEQ//YCtSxevEE9S3ARwj0uAyuC87k0NYLjwd
q/7wyb3Eskpv0NgOHey3+tghPzvkVlrr2M3oJB6K3BlzvwxJNkVe4ljGnP8oImDR
bKiczAy3+M+zLJd5r6oa6b8YgM2Ed9XllvsH/vHL5rZ+MrBC97TpPpIZR/4hvoAs
1ZEI/v8t3X7aW7KL09+s8s0dsfV8ZogTjPydL0Z9UhUf3gw130OhQJMlXMsmmCpd
ompBDE0n9mrpBVlBL2uwSJbh4dUQc4sNz2rceLtn+wnptoH1qllOiglv7z5oEgDh
yzBvdHyxjI6jUeW4o7i7lu+2effplPfaw7m01lOsTUFHyrx0bGOQ429AwttEiVuE
8dnNk9kZXVeVAH+G//xG3Sst9SX6O2b+sIAC192/eO3x/adfUhioAXs255jHhrN2
MkFv6DM8vdQJVBVyapKGgOU1suvoBLzqnPgZrl+cnVk8cBhzRcXCRJ1SFL4Qo4uw
jmcCwqTc3gKu/ak/3ygxO0jbOKe3rT3nPII38qdjtCtiqkm2V547rp81AGc6ir8U
2L26N5zWvcq4qCOnv+7owpae3sNztC9Eqv1gLAk9vx4F/0TEjbilCRnRnPIKmWcD
mz5lDQjakLQbb6l79//I4wr69QK0Ja4vxIhbq0e7SNRuhCmIQcc7kzOxJCW99P19
QxiTI9Ey7mI=
=KUWD
-----END PGP SIGNATURE-----

--=-H/os8kns/O0RzPmo9EH7--

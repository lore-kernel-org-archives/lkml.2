Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab2GETLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:11:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757132Ab2GETLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:11:35 -0400
Date: Thu, 5 Jul 2012 20:11:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, lrg@ti.com, swarren@nvidia.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps65910: add support for input supply
Message-ID: <20120705191129.GQ4111@opensource.wolfsonmicro.com>
References: <1341497004-23537-1-git-send-email-ldewangan@nvidia.com>
 <4FF5E66A.6010108@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1taQt+5gib656GU"
Content-Disposition: inline
In-Reply-To: <4FF5E66A.6010108@wwwdotorg.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a1taQt+5gib656GU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 01:09:30PM -0600, Stephen Warren wrote:
> On 07/05/2012 08:03 AM, Laxman Dewangan wrote:

> > +- vin-xxx-supply: Input voltage supply regulator.

> It'd be nice to name these simply xxx-supply; the "vin-" seems redundant.

I suspect the pin is named vin_supply (ie, vin subscript supply) in the
datasheet so this is idiomatic.

--a1taQt+5gib656GU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9earAAoJEBus8iNuMP3dlPgQAInlNOyynr8J0YCLP+vz36Sx
xC5a6lmCs/TGEw+jiqyG6/3pzPCTaIZRWcd/JFWdxPVB9v/dnOiMdqFuOE0NHfhg
muUTNoNQYhZokOc5SoXtEpMTdvKRm3n76A0sqgTW9r9MAxwOOJvmaSv7wRekLVYE
yiUZtJ2yRfFeW+Ak1ulb3cqEQ09tzN/8T0KkiMNGZleZJfy77dQtzB1RT3E+0tZX
l+fcboLxwU6tCJRIaFHVYbJuEtK6s7qo2j4WGVxV4kmHo6HYAzXD3X935eL7sAXt
+CRe7DN/lh7+P3cQcB3CPuv51xjoaNVyYwx3OsGWzYcR++lDtVCQknYN6Opw4PDu
Fs2VO9YqMMAq2mOQWrAekHlMjSGWmD0S1a+qcLKEzq4LvciIoHiQohSYgqWeVr9h
07YNk6zE32Yd/9jFWnILn/O9hgR6KDzl0nxk9VWfIotVLvjGerOZqVb5SKRdRiFh
gbuDprn8NJdIl+ttFHyv7nNzyC44cSLm9cay+6WGeoViO4+p68Z7qpOttTEamWqj
SlyLKVTZylMD7RjvHroupCYLdRHSywgsD5o/MCizMYrtNr+0aBHdJTlyRD/xhZcl
tQb7sl8NtYEj+XFRxbacHBC8awvcdYX7jtaJ+lkSPX7vDu5/EpeZ7lC/h4xs9ulM
TxfvgycH12jAKjuU5avt
=W8RR
-----END PGP SIGNATURE-----

--a1taQt+5gib656GU--

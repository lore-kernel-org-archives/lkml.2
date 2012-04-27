Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932Ab2D0RfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:35:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47901 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760909Ab2D0RfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:35:09 -0400
Date: Fri, 27 Apr 2012 18:35:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        balbi@ti.com, Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: Default Kconfig state for hw_random drivers
Message-ID: <20120427173504.GK18260@opensource.wolfsonmicro.com>
References: <20120426114229.GG3207@opensource.wolfsonmicro.com>
 <4F9A91A8.4050608@atmel.com>
 <20120427123626.GH18260@opensource.wolfsonmicro.com>
 <201204271255.36789.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IA03tywDYuoVKXrw"
Content-Disposition: inline
In-Reply-To: <201204271255.36789.arnd@arndb.de>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IA03tywDYuoVKXrw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 27, 2012 at 12:55:36PM +0000, Arnd Bergmann wrote:
> On Friday 27 April 2012, Mark Brown wrote:

> > There is one, that's the problem - the driver is defaulting to the same
> > state as the main hw_random option (as is idiomatic for this subsystem).
> > This means that if you've enabled any hw_random device this driver will
> > be enabled by default.  I would argue that this default directive only
> > makes sense if there's an explicit dependency limiting the platforms it
> > can build on.  If it can build on any platform then omitting the default
> > and just defaulting to N as is normal for drivers would be better.

> How about making it default to (HW_RANDOM && ARCH_AT91) then?

Yes, something like that would do the job too.

--IA03tywDYuoVKXrw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmti+AAoJEBus8iNuMP3dK8EP/1ulTqpuDuGrwjC3X/3T+qCp
JsAAxc5PqzMug7guG33ld0S/mero3CvRVi3bbOV+lbIWjs9IaNysm2guFNo2RRwd
jnZ77c3Bxs7wAtFH36UVsIVjyk+2dxWIhgmnlwKFP6h5m+zDdCMnxdw/PeM0FcSs
LY+eRprSFUcU0xJ0jj5Vqedaf8hAfe4ihDVnYWBq6QBbUsvLy8rEEiVPfRychsUz
pdis/n0NlxZ/nFqcM2stkHiVhWPpmB5WOyUy4h1vM/WgWeAwC1tLiQ7EYekKNa+d
QST/KOz3Jkpuuc72ihhnB3FcyAzhqX+QUwjLrsMUKWJLR3AwsSWJIh6dBE61H1Ph
0pO0NHMXC1VL5jcucKiY61XdaaguPs3UBDAt/oebHd7H1owrOGs/ISLXexkainC0
llr4J9/ZL3ssM1cJBaFyCZU4klycRarDiAtE/yiypyrgZnFWOdadjIgz7Z/gpVKG
LKur1IAF96qroLxGV1pxqHprHPWTcl4mdiE3+7UiUbrKQLFHORQARljxn8mkAvym
UR517eDgF5Ydq8fxJvHYPC3WfFozajYIJFfGSZRjXmeY+lrkm69AcYkrYLuC7JbK
bzXV6cUSmEK9YuzYGJMsUDHlsui6wNSjEMNuRlmkVhas63l8tVVkp15iMjfwgchs
Kz4bua/heSHcE4Cv28H0
=fXtt
-----END PGP SIGNATURE-----

--IA03tywDYuoVKXrw--

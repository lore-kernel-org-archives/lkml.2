Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2ACM5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 07:57:33 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:41617 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2ACM53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 07:57:29 -0500
Date: Tue, 3 Jan 2012 15:58:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool
 (drivers & misc)
Message-ID: <20120103125813.GB3626@mwanda>
References: <87ehw6sesk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <87ehw6sesk.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F02FB2F.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2011 at 01:48:51PM +1030, Rusty Russell wrote:
> diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
> --- a/drivers/block/paride/pcd.c
> +++ b/drivers/block/paride/pcd.c
> @@ -105,13 +105,14 @@
>  #define PCD_NAME	"pcd"
>  #define PCD_UNITS	4
> =20
> +#include <linux/types.h>
>  /* Here are things one can override from the insmod command.
>     Most are autoprobed by paride unless set here.  Verbose is off
>     by default.
> =20
>  */
> =20
> -static int verbose =3D 0;
> +static bool verbose =3D 0;

This should be int.  Verbose can be set to 2 for extra verbosity.

Btw, these patches that touch a ton of drivers are the wrong idea.
If you ack any part of it, then get_maintainer.pl CCs you on every
single kernel patch until eventually you get old and die.

regards,
dan carpenter

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPAvtkAAoJEOnZkXI/YHqRyRUP/1B1tervvO3XnBsyKo41+z/e
aCBTfJxgWWaapfgG/L2EZG9HFTOS0TRBkb/Uk30EipVDkQKTBfVcNmoWHJ39KJt8
nb3fqeHJsT40dVoDLzGr/044eQjwO5ZBWgMmtsx70IBjw192Q6CK9xkrb1PCpbg6
QMgWQm673jsPrjOE0wXTc1G0y3376A2TOvnx02tzP4IooW66VB1jIgxUAIQK47Iu
PXkGb/GZaA0RNxIdAlj5bgu+Gy1St4iUwrfHInArr4zU+ZaS2MZbw1GZZ5SyhBU3
mECG9gMT0AyofbEd+sLHyaGIx1j7LPcybZU30+vQ6zgoFAFqKPQhxI2Ys77/A1Zl
ASFD7r/+re+A7aYBPnbuKoz0nRGveMiR1nh2oZ384oV9olyNy2FoaTF7HkUjbaGg
kFxfi7s4NZu9TwY1/+wITFzZTneEsh1FhtvbOw30mn2LKZY/jRD8V0RPeqtlDIx3
1uY8ETo3XA0LJrtu3jhw34aqJdaWU9k0+WY8jwLMyeB6r/45brAMorkUF8j/JQKy
KzvBDcdLcKbFrvYnvSlFulIJm2+4dEGx1gCQ8bhmWJy2VvjjLndo/zT1HCrrwXiB
6e1xBP88aEqWEJe80u7BDO4ZKOGqjHFMi6RZkK3rsEjvZXzgH2InCA5CyUW3HYxX
tes6gOTFoRc96QBjRCCS
=Gz+E
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--

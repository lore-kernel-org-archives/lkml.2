Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2CPFX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:23:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23725 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2CPFX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:23:56 -0400
Date: Fri, 16 Mar 2012 08:26:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Miller <amiller@amilx.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Staging: rtl8187se: r8180_dm.c: Removed old comments
Message-ID: <20120316052612.GF3163@mwanda>
References: <1331850519-20726-1-git-send-email-amiller@amilx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3oCie2+XPXTnK5a5"
Content-Disposition: inline
In-Reply-To: <1331850519-20726-1-git-send-email-amiller@amilx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F62CE69.0035,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3oCie2+XPXTnK5a5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 15, 2012 at 06:28:39PM -0400, Andrew Miller wrote:
> Removed some old comments
>=20
> Signed-off-by: Andrew Miller <amiller@amilx.com>
> ---
>  drivers/staging/rtl8187se/r8180_dm.c |  307 +++-------------------------=
------
>  1 files changed, 21 insertions(+), 286 deletions(-)
>=20
> diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl81=
87se/r8180_dm.c
> index 54b676f..4d7a595 100644
> --- a/drivers/staging/rtl8187se/r8180_dm.c
> +++ b/drivers/staging/rtl8187se/r8180_dm.c
> @@ -1,15 +1,8 @@
> -/*#include "r8180.h" */
>  #include "r8180_dm.h"
>  #include "r8180_hw.h"
>  #include "r8180_93cx6.h"
> -/*{by amy 080312 */
> =20
> -/*
> - *	Description:
> - *		Return TRUE if we shall perform High Power Mecahnism, FALSE otherwis=
e.
> - *
> - *+by amy 080312
> - */
> + /*	Return TRUE if we shall perform High Power Mecahnism, FALSE otherwis=
e. */
>  #define RATE_ADAPTIVE_TIMER_PERIOD      300
> =20
>  bool CheckHighPower(struct net_device *dev)

I meant just remove the "*+by amy 080312" line, but I don't really
mind how you redid the formatting either.  Btw, the comment should
probably be a line below to go with the CheckHighPower() function
or people will think it belongs to the RATE_ADAPTIVE_TIMER_PERIOD
macro.

regards,
dan carpenter


--3oCie2+XPXTnK5a5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYs70AAoJEOnZkXI/YHqRzpUP/AwNfmclFTINW+/lekuo7jqi
x6DDqL5flXMu615UY/jERqRDts+f7J5rYya+xqWpzu14h+YWBdMAtgHUQEXBtjzg
1Zvc40hNCWrUD4AxQETp/basFb945UQyFCYzXk9W4r+2zCxcgeuv6nzFBBFn9Thb
hoKHVcOaWaTgYpH+JiFYn3DS3SNej2HA4ZRPeBeIPHHUlrr5ttzOCXnqM3biIhrP
Gr6jGknxBW6VAWHHq6oBJz+mc7ln4BQGDchBFefY7w1oJRuUGjMFw7c6mk1/xS7t
zCegoReqQU4YQXE9CpuNrR22t8R3vMkFWfuUvaqSOHAt5NiTT6hYFIN/8/RioMsb
pMkBqRv/CUGGT43YiEJLjpnL4xkKhEpmE0u0bHO1Ytz9IuzK0APMmlVyxdc+gIPr
7ph+dJ79ljHzpq1F3l2noasG3maTLUKeCSc97IZTbnriI81cZbc2yJwtJqzVv/Zr
OKP33mySdAKh7nAgssJxw/CtFZjaNpPulVkLaXygh3uZ5yNzNzl8yDYxKIANZr41
z2Un3jdSFwiRdlPiS+8P/aoqfw7ELnfOsK1RtT+RvVhI/tsomHBQcHcoWqQAsu34
b/F77PXhC08p+iiAQtv/Z1XCTX+5wjj9w2XnjqcbGVvHDOt6yaaEJ4DyrAZgsw3O
nqmATOs1m3QzIcqw8h7d
=vZfF
-----END PGP SIGNATURE-----

--3oCie2+XPXTnK5a5--

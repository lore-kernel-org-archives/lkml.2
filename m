Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1KSHSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 02:18:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:57409 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab1KSHSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 02:18:08 -0500
Date: Sat, 19 Nov 2011 10:19:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Ken O'Brien" <kernel@kenobrien.org>
Cc: gregkh@suse.de, lucas.demarchi@profusion.mobi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: bcm: Adapter.h Checkpatch cleaning.
Message-ID: <20111119071915.GJ29436@mwanda>
References: <1321669194-4365-1-git-send-email-kernel@kenobrien.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/qIPZgKzMPM+y5U5"
Content-Disposition: inline
In-Reply-To: <1321669194-4365-1-git-send-email-kernel@kenobrien.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020207.4EC7582A.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/qIPZgKzMPM+y5U5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 19, 2011 at 02:19:54AM +0000, Ken O'Brien wrote:
> Removed all checkpatch errors.
>=20
> Checkpatch status before: total: 131 errors, 200 warnings, 648 lines chec=
ked
> Checkpatch status after:  total: 0 errors, 194 warnings, 620 lines checked
>=20

I don't have strong opinions personally, but I think the prefered way
is to do this for one class of errors at a time.  It makes the patch
smaller and easier to review.  Then send the series of patches.

> +typedef union _U_IP_ADDRESS {
> +  struct {
> +		ULONG				ulIpv4Addr[MAX_IP_RANGE_LENGTH];/*Source Ip Address Range */
     ^    ^                  ^                                             =
     ^ ^
     tab tab            one space only here                                =
 spaces after the ';' and '*'.
The whitespace on the line above isn't right.

> +      /*
> +      * bit 1: 1 Idlemode enable;
> +      * bit 2: 1 Sleepmode Enable
> +      */

The asterisks should all line up here.

regards,
dan carpenter

--/qIPZgKzMPM+y5U5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOx1hyAAoJEOnZkXI/YHqRpi0P/iJXQKCqBA+QFAgKrJ3Yccre
047RMSIoWDwT/fB14tp7GSN5URHY2K2aAD/6c40nFWvQgP/dON+uBynIJE1gejst
zUl6raHMgps7efqKA4fLx5Y1yrKLbuPoFc+NiI9/oqNfhg7D4X6f5dtgOmuWBF5X
u8dizUbkQ8Omr+VTm/Lg7LenA/or4E36ofqXVW26HEC1Rxgh7L+PhXZRJJ+zPtWV
4b35xwxrKTYA4d11hKdYRyvH6VfVhxFuB0aNgWcxF6Xe/Q0wtpqz/96tYb6WO/ff
3lKLCvj0YBMvOA8JLgCDxtz4PVQVlFdy3Fd9YGlXnxRvqJMM9KCmvYw8r8OAZRSh
6xgb64lGcq7qSPnWn9FG4PaaaHumIwIWoXLzFrf4DoTaTRD+/wWxhkH1h63Yr3eq
XjSNag0qnIkZaV8VGaJnHMfGMbyQOLvRIkp+B2leDfpg4wmFEghVyHnrnHFeDKOF
64ziW43ybq08lLZpKtheo82e4SwTlyoW9TJBeDIAUQ3XlUPrKAnJKD8s22fmuuZE
AE8k4RVTPahtihSuM1uwCFwTvzU0BiSPGwnFKOUqEMZr6j/9J6lr8AQ7Xs7YKdEA
7xlOWuzA+1JcYc48NLiRbDcjtxa9AAK+02qzUpqLn+0SdoHzlxkVbaWWfiKoEV9S
Y3i9l3sSA2QphQzG5SEe
=i2bN
-----END PGP SIGNATURE-----

--/qIPZgKzMPM+y5U5--

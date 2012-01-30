Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2A3O2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:28:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42920 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2A3O2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:28:37 -0500
Message-ID: <1327933829.13286.6.camel@sauron.fi.intel.com>
Subject: mtd api rework
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Mon, 30 Jan 2012 16:30:29 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YMTteI3J99k6Lx2Q8XLN"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YMTteI3J99k6Lx2Q8XLN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

we are doing MTD API rework and I've just pushed this patch to my l2-mtd
tree:

http://git.infradead.org/users/dedekind/l2-mtd.git/commit/a088d81808f6803ca=
6bfb9ea9148beef53fde1d2

Which renames MTD function pointers to make sure no one uses them
directly. I've build-tested this for i386 and arm and it compiles.

However, there may be compile issues in future if one of subsystems not
aware of the change try to use old names. Please, be aware. The right
thing to do in this case for the subsystem is to either not use the
pointer directly and use the corresponding mtd_func() wrapper. Please,
let me know if there are any issues related to this change.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-YMTteI3J99k6Lx2Q8XLN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPJqmFAAoJECmIfjd9wqK0S6sQAJO+9+OTCMIZvY+dknzNBgK3
zVyx5yxmF5o+OwoJbUq4247xwWm6D3ujHGiTNOwYiXwU9pj5cOawUicv06gHsmZQ
TRWQ9sdhViTas/eNb1/GIefZ9X/BrHcLdnnR2DJwi15eu6d74Qvl2/m+6bpCUOlp
imcS5tuEmNqngmhBUeZ4Zr+mEvjTGF20sk+AFYy/3l5J2DfeB3BTYk5t38IEtI/I
bQDvQ5TkPEMNTPZ8nV1NQkann3AH66143PzD+ljgyjYQQzHUFFHJ36/c3RzBcf0d
6ATUKPJ5R6AfveLp7k0sdIUbZXw4DcFyiy5GKcF84Bw619GpbnHRXB035gsRiEpw
FIJLxQcJ3o91rAFx4AY2rBAN453OQLjB9WfUMicWALvFqLYM+HvphzYCW8gSRc2n
Wr+OASnVKeQ1GNi7gPIGkBuWGR6zLBq4oyuWanYYzRzkzI/CdE3+13ytS6gPJrb6
OiUmgwe21BNxk3YGnjFEnXWwiflFc5WFaD7zGM3DST/WjF7m8uplA7c2UlpIniPf
zkfzF3GhrRrhunXxlqBSLpbV3oDWULMfrVFnENlxPqC2uZ+ZBtjM4UPGxIBYVidt
2AOay0IuPgvW63dJOc45QJ34Y1ws1FHdEn9yI8eBilNkedI3XcPfduj9TrFuAlKT
1sqUjEPdqqthMiUGVGv1
=/IFI
-----END PGP SIGNATURE-----

--=-YMTteI3J99k6Lx2Q8XLN--


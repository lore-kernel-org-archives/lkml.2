Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1JYHUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:20:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37835 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1JYHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:20:37 -0400
Date: Tue, 25 Oct 2011 18:20:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the pm tree with the s390 tree
Message-Id: <20111025182025.d57f82a57ceaa8fae7cc5127@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_18_20_25_+1100_cB=aTz9L.FX0qeeG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_18_20_25_+1100_cB=aTz9L.FX0qeeG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/s390/kernel/suspend.c between commit 4de2166b1804 ("[S390] sparse:
fix sparse warnings about missing prototypes") from the s390 tree and
commit 85055dd805f0 ("PM / Hibernate: Include storage keys in hibernation
image on s390") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/kernel/suspend.c
index 4f0fd55,b6f9afe..0000000
--- a/arch/s390/kernel/suspend.c
+++ b/arch/s390/kernel/suspend.c
@@@ -7,7 -7,7 +7,8 @@@
   */
 =20
  #include <linux/pfn.h>
 +#include <linux/suspend.h>
+ #include <linux/mm.h>
  #include <asm/system.h>
 =20
  /*

--Signature=_Tue__25_Oct_2011_18_20_25_+1100_cB=aTz9L.FX0qeeG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpmM5AAoJEECxmPOUX5FE7EkP/1bAqr7RHBeDASbIyCTMXKsC
9tpgxFb2EkWmptV2DoH2hJqAcSVhr6au/0UjmVlciI2IYJfZOJ0JPhaZ5EZDixd6
pxpEUcXv0VnVDlrsGniGo+eYj5EcselyC0EhMT/VY/eKj+5hiBjEqYOIQElimv2H
dYGcd1okCRhUNBv7Dwo7Gqt1mJISQrkJjfyFLPvZqP+9q0MRc5ccOoGUj90fbBaL
0bh0yplFtnrCLuk8ecERJnIrI9lp4epnSYchDExQfMA1WX1uZihlAh7xOVaeoFBd
DJRZ6WPDbRGt7yaHtPopatTOtD32OJTakSm0o/X94h02VCHW1KvG6y1E0QcFdaKi
gvqzKDr2Q5rCW7lqgOK0lf39w1WMI+8ghVIaS/h2Y0M3ZCe9UppMQAEbVkdzVQi1
8WQZ0umEHcUpDzKha1e/dOAObXNWuI++Am+cMTBBEL1aTWEzEXgzhbQ8Dl2O/46F
w8eLRjNGArnaxni2nc+RSH4VNolQyj80LGWAu4HWBSzahPl+Jroqs6/TxmGSD5e9
w+3u0SKSIOUy05gMM0LHS7L4cdWQvq7bZEIMolQsIbdda63Yqt8wc0rmsYHBTWOv
GcihXo4bhJdaB6uXkWrImlo5nBmxFmedeNo58gUsc5E4hwqGfutxKho/DkAP+Seb
+fx2ReUpCrkz0d/0mUtA
=0+jJ
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_18_20_25_+1100_cB=aTz9L.FX0qeeG--

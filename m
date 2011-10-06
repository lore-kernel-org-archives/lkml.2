Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab1JFDsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 23:48:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47380 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1JFDsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 23:48:36 -0400
Date: Thu, 6 Oct 2011 14:48:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: linux-next: build failure after merge of the gpio tree
Message-Id: <20111006144826.a69a5ea59d4ca94f8f7414cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_14_48_26_+1100_7TJTgztXCFKYvzA/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_14_48_26_+1100_7TJTgztXCFKYvzA/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the gpio tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!

Presumably caused by commits 54be566317b6 ("gpio-ml-ioh: Support
interrupt function") and 38eb18a6f92d ("gpio-pch: Support interrupt
function").

I have used the gpio tree from next-20111005 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Oct_2011_14_48_26_+1100_7TJTgztXCFKYvzA/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjSUKAAoJEECxmPOUX5FE/GMQAIfUtWCtDBhS3GGa+HUyx2Zj
YYtVbE9GXvFllj/6C81F7n4G/t9iW0F7HRU4m1SdPcWwiP/4+B/jtjrn5Uy4J2tV
vr8TuZ1Z1mf+luGh8wRwUzw1BgE9hjaLL0tI092dVbsPkKEZ2aZktiaOugyJyrbV
WdO3Fmcki2RXVx9N+YjpGUV7vojRoKmzmzbJV2fT0JW88mcqB6RGksXjpaxlVCu0
amC4T7ARGtshF8xsiEV1W0GUq5ntSYyucE+xemFzaIXXYSMMopAjREIvLow/dBov
yOBKvXuJBY7qXaHJhE2Q9WLqOt2VOgqtbEHDSlSya0rLeXTcSuJUf0XfTDRwrlNF
r8irJ8v7BDOLwMS0CN5RyiZtSxUm6Vbhl1K7mSEyMCPRto76+SjbgxdrM6yYwAwI
+HaYBnj8wpflwRIS0qRD6nWw7cnReEMyALSeOAQSoiDDwmnf8nadfxYdKmyaRlva
qT+WGBqCdPMVVMQ5PuBZy6bT3pUHydLXuSZCnfSHe+PPvb7464bl7ux2li1ub2YW
WnAHrTgIxRfhVvrTJ8dt44Nq12EhEk7G070PHFVX3jH5pFUlE+KKVGs7Cs+GDj2n
NHhb9OoPA5DM5CmXGt9snGB6twGXNSUiDZuxPv8tgOSGB6u/eWIZ6Ou8QWAVw11Q
TDMIYS8aMjJhS7Z4uSg2
=hDjz
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_14_48_26_+1100_7TJTgztXCFKYvzA/--

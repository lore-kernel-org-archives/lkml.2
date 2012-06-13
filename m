Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab2FMEKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:10:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36977 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2FMEKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:10:49 -0400
Date: Wed, 13 Jun 2012 14:10:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: linux-next: build failure after merge of the leds tree
Message-Id: <20120613141041.199421c4b922655cbcfbe14d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Jun_2012_14_10_41_+1000_IWT_TDRgs9oyqlQH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Jun_2012_14_10_41_+1000_IWT_TDRgs9oyqlQH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bryan,

After merging the leds tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/leds/led-core.c: In function 'led_set_software_blink':
drivers/leds/led-core.c:44:2: error: implicit declaration of function 'led_=
stop_software_blink' [-Werror=3Dimplicit-function-declaration]

Caused by commit eb91300a9786 ("leds: fix led_brightness_set when
soft-blinking").

This is exactly the problem I reported on June 8 and was fixed in
next-20120612 ...

I have used the leds tree from next-20120612 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__13_Jun_2012_14_10_41_+1000_IWT_TDRgs9oyqlQH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP2BLBAAoJEECxmPOUX5FEPG8P/20RLffNi3lDs7RgDh67ra6X
jTPY/EQdnEJwd8SY6LdlLUm8r6FovTYUBqJsu3GyYGZ37IE8Y7rJei7OEGrZWMPR
2Zase5DHSBsiwy5ukkErBiwXDYxrdqcMuykQccsQI3UbZiRr/8M3HdpSLUNefwbF
z/BR0roRNoQ8XlbxPC47H5jj7cN0YnahTlA7paSenH9teZZ0TFqGM/YJe3bjFHeh
A3WXDWlRZ3U3RqxW5thti3izKm6agi/S0uZbAF6+adWp/cx521vN7T13fCXPE2Cc
ELmwQwuePn+u9/wiqEuDGFMchp3Hlt7dRMWeJe29GULkEW246M16bzGwfE2tfUxc
Z9YDmpoITnCeGhDJ/Myi0J9z5JD+qYfjPFzi4fKn4ctNKDhL9XTh6krsrayOvqcO
3ExVkVJTiu2CWL4SSxMwopTO2xo3hyozNnAQnELnbTc46OJLdjceUmzJXoOzeTER
kTZndamCNbRjembZ0nKpkb0J/4QuiarUv73B5sFfghFU6BHIetn4IpI1jRYvSPZT
JxujpMyRjS94rlqJWCf7WkRi8JKp2Lxd5sg7WvdJ9W3aCS5hjR0pmHULtUtUQ8y9
AY2EJFn7+JbGDWYPSEQUhMrA/0XM6RD+DKPODRxX+aLgx2ige9xtgZk3mc8QZVxa
CVtrCCBXCpQK3RpKyzJy
=ztVb
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Jun_2012_14_10_41_+1000_IWT_TDRgs9oyqlQH--

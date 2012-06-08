Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532Ab2FHCo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:44:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58576 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2FHCo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:44:56 -0400
Date: Fri, 8 Jun 2012 12:44:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: linux-next: build failure after merge of the leds tree
Message-Id: <20120608124448.2ff862098d474dc6a567dc46@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Jun_2012_12_44_48_+1000_wc/ZWM+f2zydsD=9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jun_2012_12_44_48_+1000_wc/ZWM+f2zydsD=9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bryan,

After merging the leds tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/leds/led-core.c: In function 'led_set_software_blink':
drivers/leds/led-core.c:44:2: error: implicit declaration of function 'led_=
stop_software_blink' [-Werror=3Dimplicit-function-declaration]

Caused by commit 12b204f41034 ("leds: fix led_brightness_set when
soft-blinking").  Please build test this stuff.

I have used the leds tree from next-20120607 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Jun_2012_12_44_48_+1000_wc/ZWM+f2zydsD=9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP0WcgAAoJEECxmPOUX5FExVUP/2jeOETwoE6N0Oouy7umX/YB
frWB7+08y8x+CvOgx7PA1UoQe9+4jSNFqKJsFJwO64zLdVFp/Nrqeo2d7RDoknti
wiO5r1WW39svvXeMD0MnW3bgh49b7rPgyWyTDR+/gZjIAyBwh3ZaFnS4KA8PZddH
RwHOcc1oZdctu3vKtAVPcw9jDMzNv2azSEhZpxuu8sbktSa/ItO2D1jjSC8QO7u0
Jp8OMLCBTp4n5bXS9vh7fgO2u2LU9pqtwm87A6s6Xh8lLMW51BdYahv5QKP5yuH9
rIway9u6016T5Lq7mrq1g5s5jl8EAWcHsqWSIszzEZEjoBgcO1V1TzDatY0+fO4/
0ZqGj6hQeYspOPpWbBzdz8kKzYc6AwkblpamzuFFG7KfgeRlABWILn+G/jxnT/g7
LEYSjT+0CPg9W6T7PORaG1r7pv+AuWIa4MmrD/3WsjNAziKWAgqsulPtXGl7cMqT
aI8MNgw8oMu+slPHbomRu5UYSLnwwRQCZl8mZbVv51ClaAGAPRpH7jW4FdFEk8N/
gD0y8kVBHsN7MzEh4JTxZHnO7hCFQYdKEQf9rSt8U45PgzSFVIt5F2yJ368M4WVG
2f7YBe99upzKTkk3719XmH55Q+OgT/1WRQ/7gmpkim+3V5iNT+f49CpGgIaRnRU9
gv8/wuvtihGTLlNh2K/E
=c1Uh
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jun_2012_12_44_48_+1000_wc/ZWM+f2zydsD=9--

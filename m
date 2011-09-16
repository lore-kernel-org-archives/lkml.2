Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1IPDzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 23:55:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54765 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1IPDze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 23:55:34 -0400
Date: Fri, 16 Sep 2011 13:55:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20110916135523.01ec57f699192230272e99e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Sep_2011_13_55_23_+1000_+GhZUq.W250F8fv7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Sep_2011_13_55_23_+1000_+GhZUq.W250F8fv7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/leds/leds-mc13783.c: In function 'mc13783_leds_prepare':
drivers/leds/leds-mc13783.c:193:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:196:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:203:14: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:206:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:213:14: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:216:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:223:14: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:226:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:233:14: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:236:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:244:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:246:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:248:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:250:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:253:15: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:255:15: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c: In function 'mc13783_led_probe':
drivers/leds/leds-mc13783.c:278:11: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:278:34: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:279:54: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:283:36: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:295:23: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:297:19: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:299:14: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:299:47: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:300:50: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:305:31: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:307:13: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:312:27: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:313:31: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:314:42: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:317:24: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c:329:43: error: dereferencing pointer to incompl=
ete type
drivers/leds/leds-mc13783.c: In function 'mc13783_led_remove':
drivers/leds/leds-mc13783.c:359:23: error: dereferencing pointer to incompl=
ete type

Presumably caused by commit 747c98a3660d ("leds: Convert mc13783 driver
to mc13xxx MFD").

I have used the mfd tree from next-20110915 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Sep_2011_13_55_23_+1000_+GhZUq.W250F8fv7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcsirAAoJEDMEi1NhKgbs+bwH/04tKgwKXzdQpk3jMjF9D0gg
EACSTHlnDkpcAK+qcjevlASbB5mhM5GyvIMwNOBcb8HY4dQH+3TrX4UfTuCQA9xN
DH3eycw3TINGfhej+/5cbNEJNORKEBkJcILCq0n6toBBzcPtXHQFdrjiZxBc0BEO
UqH/tjb9GKeeOKPuRShBZQrIXSd5MLWUs0vYjNQYRiPNNI37SFOBJTHRIGf3Lqqw
9j5y9BaJDvDKd7b5z15KtGscxFgOQW3NjdSZCkYJvQWCU0jQQ9zxfIUUBInO0EFH
iosJUYW5S0MNwBFPyrmTXwfFBCHELVBbL+Fy9Ei7FaWdysBJn9I/M1xl8EChzX0=
=1VzZ
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Sep_2011_13_55_23_+1000_+GhZUq.W250F8fv7--

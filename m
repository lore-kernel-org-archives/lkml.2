Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0GMA1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 20:27:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34107 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab0GMA1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 20:27:43 -0400
Date: Tue, 13 Jul 2010 10:27:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed import of the i2c quilt series
Message-Id: <20100713102736.b66c2c2f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Jul_2010_10_27_36_+1000_5tgK+stZwwF2YN0p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Jul_2010_10_27_36_+1000_5tgK+stZwwF2YN0p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Importing of the i2c quilt tree this morning produced this error:

i2c-drop-preliminary-probability-checks.patch
error: patch failed: drivers/i2c/i2c-core.c:1456
error: drivers/i2c/i2c-core.c: patch does not apply

I will use the i2c tree from next-20100712 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Jul_2010_10_27_36_+1000_5tgK+stZwwF2YN0p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMO7L4AAoJEDMEi1NhKgbst/YH+wecMyuT4BwzmpLz6OU2+I9o
DH2amDWf4cY+JlsgJFIdVpQ3rsWcMUwUyTHBT0YMaRCi8dzyUjq959zJgc4EvEBY
G5L5lmg4/d8kUi09yhCMEIxMxLmUHAxx4/KHuYQiFvljiagZuNpBp2SVYPxVkCLB
d9OupVMJ5DwFAhIqy0SwFtXEI+2c3NBkKHJxYuUG7ZylVTkRDZ1j0J1xdXaaRy/Z
yCVxHQykVwQDB/6ndWIt4knWXLeZsEnQKick3t8B/O/tgtlTJjbObXVIUtTKG0NR
yCs0XgQNvhrFy+dfTrvys5Tp7PD2/WeiHCUTiRj+U3UokJ3Jo2SUZrPPb7B9wdE=
=cB23
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Jul_2010_10_27_36_+1000_5tgK+stZwwF2YN0p--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2IJDVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:21:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41639 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2IJDVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:21:08 -0400
Date: Mon, 10 Sep 2012 13:20:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the regulator tree
Message-Id: <20120910132058.81db87c7fb4b524072207220@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Sep_2012_13_20_58_+1000_ceROa31n=bz_1Qiw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Sep_2012_13_20_58_+1000_ceROa31n=bz_1Qiw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "regulator_allow_bypass" [drivers/extcon/extcon-arizona.ko] undefine=
d!

Caused by commit e6647c416e4f ("extcon: arizona: Use bypass mode for MICVDD=
").

I have used the regulator tree from next-20120907 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Sep_2012_13_20_58_+1000_ceROa31n=bz_1Qiw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTVyaAAoJEECxmPOUX5FECOAP/ApTVfwx1QMAWwATytbiIzsh
3MvYxc3LPIAVy0Rwl1nwm2Hi1JT6Nhq13f5RFXtZWCWuPHA1GkG2o441jNhyLiPn
HAFvnztvbClGuBdTbQvP7JKXOKfevVZEPbl067enV/vH+rSJfbFn+5Yy13rL607Q
cUMLqkqTlUTsRMxvmWfWuNEXVuIl9U7JJOt9hhHNpe7pMu6j55B6IZFhPNwkBh5o
QiI6CFtn44durtSvXVqEH6F3kl5xxAI6kOqLjwYdzY8UJ2CNiF6oXgPe6qAvB9ax
ExG/xpq3MMadZNQI30msaa3jz2+gC4LokHZ0xdMyxM6pYaC0jfXg8hwegYTS+GQG
TmsEBMdgdn3MCdIX9PTL6qr+wyot0yHNH773fXKeW6v65hhtUgX3Il7xqjSHTVI9
kvTR1/kaK0XNIreL329xXtyPmzLaIJXS59Mrstzoz+KzLjba/lm9MC8caNUNp/m1
3B1lovi0FJtonJEAGwnqbcGNWXcBfJy3oOAHHkUlWlPEQh4usEqRnvsmfrOwYkdx
7O/aYjeQMycZJbHYCbEuBdGl6a4S1zHUejVhPIMPahLl47X7zm21GlnOW6pKzUkt
a6CIuUyHz7jONP6FAyh2rs+VS5ryKoclmwJ7pmKZnF2ZOVGE58QFavgqqousOVjK
p2IqmCrG8lpC/31wgPPe
=iXNn
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Sep_2012_13_20_58_+1000_ceROa31n=bz_1Qiw--

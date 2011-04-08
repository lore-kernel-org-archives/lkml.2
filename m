Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1DHEKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:10:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52847 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1DHEKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:10:49 -0400
Date: Fri, 8 Apr 2011 14:10:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Christian Lamparter <chunkeey@googlemail.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110408141043.80673558.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_14_10_43_+1000_tB9ETZir.SKAsL0+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_14_10_43_+1000_tB9ETZir.SKAsL0+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/ath/ar9170/main.c and
drivers/net/wireless/ath/ar9170/phy.c between commit 25985edcedea ("Fix
common misspellings") from Linus' tree and commit b0006e696158
("ar9170usb: purge obsolete driver") from the wireless tree.

The latter just removed the files, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_14_10_43_+1000_tB9ETZir.SKAsL0+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnorDAAoJEDMEi1NhKgbscPwH/1U0QC5iWFJTPqEbHzKDKgRh
uM6uMQ3S+92sL952BkBG0ntzsvp8YhzR5dGRyqyWsyEGvkjizU+IHFzmDooMcRL8
7odBjI0ao0yqORVHT4Z/YiAs1xKfc4wHMVqIOJpmRj3PAPANsgJkJbGItl7olTkw
pMYDJ1ESCZXdWU0OR7rvItRzAORH9FaW2qzbNpUKXvhh1FSOl3pFwzSySYAwARhl
8lRzMT6u5oVbBmxd2vlYc4i6cl8Ns8nhS1tNaOSUFeUSWr8TWkiyDWQW5xxXRz3g
Y753zvng1aaIKgO0WdhQ2RK2lkxXM6yeHDGBtyHsmJiRCnemmEH+8XhYZh3ZrM0=
=CIe9
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_14_10_43_+1000_tB9ETZir.SKAsL0+--

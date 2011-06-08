Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1FHDDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:03:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56497 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1FHDDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:03:45 -0400
Date: Wed, 8 Jun 2011 13:03:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Kriwanek <mail@stefankriwanek.de>
Subject: linux-next: build failure after merge of the hid tree
Message-Id: <20110608130334.58c62a7d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2011_13_03_34_+1000_K/dG5G_HYnbBdsP0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jun_2011_13_03_34_+1000_K/dG5G_HYnbBdsP0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

make[3]: *** No rule to make target `drivers/hid/hid-speedlink.c', needed b=
y `drivers/hid/hid-speedlink.o'.  Stop.

Caused by commit b5eb65d64f91 ("HID: Add driver to fix Speedlink VAD
Cezanne support").

I have used the hid tree from next-20110607 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jun_2011_13_03_34_+1000_K/dG5G_HYnbBdsP0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7uaGAAoJEDMEi1NhKgbsAQ0IAKEAZqkLSRUC6s4wc8m6DiTY
qyx5Hae5XkBLerGTiu6CgeMy8EEZdPwhPuflLHfle1EVBH5V8WgGT0yrEBv0z1Lg
UBgwYA+vmXoVnOJG00oTT4DVniuC+JwXEQYi97SIWjg1WotNv1HTO7l1wBBv+ORO
TLBVUTuaK2nUujVD/XJ0uEGohTNkuNN0kOgdhad+yTxgZ4OVnc4mKgssQ3JGHJyZ
7kY6nMxaWo6xN5tIlzRDHRkwm7mUcUUaZbZgiZEYEYa9K2CfOz97LJ1OKqIlhNzD
gwQw2JsivpGAWXjrWwSlcFmInzaYDLaT0zw8vmYBvEpTRIpHyTGJf1U7fLXkH8E=
=IMCC
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2011_13_03_34_+1000_K/dG5G_HYnbBdsP0--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0LMDd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:33:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52356 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab0LMDd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:33:28 -0500
Date: Mon, 13 Dec 2010 14:33:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: linux-next: build failure after merge of the swiotlb-xen tree
Message-Id: <20101213143322.90c45f81.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Dec_2010_14_33_22_+1100_W.AiBGWP2H0RHynC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Dec_2010_14_33_22_+1100_W.AiBGWP2H0RHynC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the swiotlb-xen tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "xenbus_dev_is_online" [drivers/xen/pciback/xen-pciback.ko] undefine=
d!
ERROR: "__xenbus_register_backend" [drivers/xen/pciback/xen-pciback.ko] und=
efined!

Caused by commit 443b2aafbdb509f218fcb8f4665f063e3a5e1a92 ("xen-pciback:
Initial copy from linux-2.6.18.hg off pciback driver").

I have used the swiotlb-xen tree from next-20101210 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Dec_2010_14_33_22_+1100_W.AiBGWP2H0RHynC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBZQCAAoJEDMEi1NhKgbsTnYH/3kwWg1ecz0Vva4GMd3nAxrG
qU891SouvmqVP8pZjyQcYKGaKsN9QXalU+kvpS3OZWyhozcIdqBjjF8MNILoVuaO
7jH2kaZQe0EKmiqBjWTbocFRPSWTgNDW7wvBTrQhq0D5mPw+cbmTEhR14rWMElWX
HNwb9IDldblEOa1pPOt6V7ixLwjs3muPdeVNuTLOK18u4UdiEl+q6dLSg1HOCXwP
Wuw1dP2Wercc0+GxLGiEFb7XxaM+UjWW4Wl+vDI2BC2dqdCWH0sK/x9cDJGpm8IX
7ceU5uA+O67ptLxmXQz4ZyuV90CbRmuuFu40ZY/pe9iGktVc0j2q50KjkqQVceo=
=7suH
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Dec_2010_14_33_22_+1100_W.AiBGWP2H0RHynC--

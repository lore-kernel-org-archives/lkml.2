Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0DZXaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:30:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51829 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab0DZXaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:30:23 -0400
Date: Tue, 27 Apr 2010 09:30:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Manoussakis <alex@juniper.net>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20100427093019.ae1b8c48.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_09_30_19_+1000_bl+rwALJRV1Efz=."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_09_30_19_+1000_bl+rwALJRV1Efz=.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/usb/serial/ti_usb_3410_5052.c: In function 'ti_download_firmware':
drivers/usb/serial/ti_usb_3410_5052.c:1738: warning: format '%d' expects ty=
pe 'int', but argument 5 has type 'size_t'

Introduced by commit cdc04834ce70343aa6f87c5332ec66c35d968967 ("USB:
ti_usb_3410_5052: adding multitech dialup fax/modem devices").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_09_30_19_+1000_bl+rwALJRV1Efz=.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWIgsACgkQjjKRsyhoI8zMjQCeKVUHgKXH5Mm+4fdp4OxwgpBf
XKwAoLKY6u6C6NMHNlB1wvlQ9Dw/tTDy
=1oCk
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_09_30_19_+1000_bl+rwALJRV1Efz=.--

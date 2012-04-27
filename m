Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2D0GAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:00:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39290 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2D0F7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:59:18 -0400
Date: Fri, 27 Apr 2012 14:12:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20120427141234.242d7f7abb4b5453255d7544@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_14_12_34_+1000_YM1ULneld6caNbzp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_14_12_34_+1000_YM1ULneld6caNbzp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from drivers/usb/host/ohci-hcd.c:1079:0:
drivers/usb/host/ohci-ps3.c: In function 'ps3_ohci_hc_start':
drivers/usb/host/ohci-ps3.c:48:3: error: implicit declaration of function '=
err' [-Werror=3Dimplicit-function-declaration]

Caused by commit af4e1ee04026 ("USB: remove err() macro").

I have used the usb tree from next-20120424 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Apr_2012_14_12_34_+1000_YM1ULneld6caNbzp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmhyyAAoJEECxmPOUX5FEfskP/1qm7f02mfYMsKyWTKEcE9F7
rPlo4uhr8d2JQPNOLd3eK5hZ20tridtDLLRR5I+D+I5+YZ1G5LiMbaP0iaEYx0FR
v8Tr0tXPA9Mr6t0BwvMG+j2Jo9Vl6E4uGHdjJVCoQccokr0ePIrJ07EBVGIXyu0F
Lm5d/v6lPzQsuMVcoJx06RiFPYSNZ+VUkkjolRh/8IoestOoOOPvALvv9HqNGwVV
YvbRYwNjjHrjN7RxBv46mQuywCnBY/J9WSqdxoik08pCY+8WY0ydKAIiR1LcfERW
qtMd1nZ8HRbPQF8Vke9IIwZN9xy7Qv6h4t0jn9zCgGLx/0YOwLoxzZ4FCuKTep+j
TsNixdJuO3r3J+BS7VjxsBvzal8wLkS3OiGLxNWEo5+ujQgnZ7HFp4m5wcltxIs3
Ul9ujHfsXfBnZmbzIOpRXkcOtXk7g5EDeMp3qD6uLUC/1bBEtjtrB3lG8PnWvS2x
5J4AJgIs7i06h0Z3pog37k/32RrXTiDyEvjagb0y3RtEMvBblLXYh6t+KyvPL2ee
7Lzzc7RN+s+1rLBQQMG+BMRmUdS92liuYynE6SjHF3pf0IdWGQD70uXYvO6bllzW
LQGfy3qH8FQKZP1BZw6XPxOWLzUfHPnwiYqmqr0cG7DrVP4dGvx8/9lKqxPpoBtz
kR7XXSZTM3Eji+xrU9JC
=TFZ+
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_14_12_34_+1000_YM1ULneld6caNbzp--

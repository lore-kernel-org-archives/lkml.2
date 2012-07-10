Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2GJFvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:51:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32829 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2GJFv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:51:29 -0400
Date: Tue, 10 Jul 2012 15:51:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russ Dill <Russ.Dill@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: manual merge of the usb tree with the mfd tree
Message-Id: <20120710155116.3dd45f8c86d8dc540e2091a8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jul_2012_15_51_16_+1000_tUiWke12ige6WmwC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2012_15_51_16_+1000_tUiWke12ige6WmwC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-omap.c between commit 2761a6394516 ("mfd: USB: Fix
the omap-usb EHCI ULPI PHY reset fix issues") from the mfd tree and
commit 1a49e2ac9651 ("EHCI: centralize controller initialization") from
the usb tree.

I am not sure how to fix this up, I have just effectively reverted the
effect of the former commit on this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Jul_2012_15_51_16_+1000_tUiWke12ige6WmwC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+8LUAAoJEECxmPOUX5FEKJ8QAITQE/lvrNFdiTmNAh1g/vM8
WODBcAVKbEwYxJtA6YoHdmuJAX6IqrXsavXI6NvRELOPejYrIK7vMZxsaNNzXg8O
f6/VBq3gD8QQSxYoASFmZvzoItX1BSxnXKwPtxj9cDYIgkjmpJHZQVMyA9ELhLu0
vK85BjV/1EHrjoG3m4t/OQPdETK9eO4XIpFJlXQydFXgi2wOmaTOi+0y1KiBresC
jfMJb729c5RHyy2+8iktSHFqOMxCrG/NC/zcldgFlFE9onFGRCxMY5YoyeHwZ+sF
VpUImTLDMyRO8KaSWDEHnXhBatFcP9k4jam1V2xi6uck1XJBv4tT0i14GXbk9lPu
jAzk34zNIdVYPLXeRkCHXB8R3JFIAQLYjUxDnw1YdWSz/GqjgJ0KS7ZOuJOl1Xvo
hMUxwW49fGfWbHGC1PdhZR3USUIvl8aZZTLD3lgCDuO8MekSoZrM7EUFZve1g03M
5Xf6UqUVr6wU1aEFcgty654G7EzodpQpgf32+HEt4WX+iDuckD2k0yuCfacTJwvC
/yotuh5oGfkAymda4t+3zN7Cij84d1H7CLaP3+tEatzVieAyeltG45ylt7yKNtsb
Nj9T4N6ixGQSZoRKeciZZnbDTqRJUBj6pN+GgUp5c+7BD3vUR8Im+rqbzswG9V20
mQKL5qRcA3fQSFCvD4uf
=/fPj
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2012_15_51_16_+1000_tUiWke12ige6WmwC--

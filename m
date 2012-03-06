Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2CFFvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:51:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59869 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2CFFvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:51:05 -0500
Date: Tue, 6 Mar 2012 16:50:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the usb tree
Message-Id: <20120306165053.c42cdb7ff8e6772a0a8ebbd5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Mar_2012_16_50_53_+1100_bVMR93QPV.7OSj/7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Mar_2012_16_50_53_+1100_bVMR93QPV.7OSj/7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/usb/dwc3/dwc3-omap.c between commit 45b3cd4ad79b ("usb: dwc3:
omap: convert pdata to of property") from the usb tree and commit
13ae246db4a0 ("includecheck: delete any duplicate instances of module.h")
from the moduleh tree.

Just context changes.  I fixed it up and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Mar_2012_16_50_53_+1100_bVMR93QPV.7OSj/7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVaW9AAoJEECxmPOUX5FEBoUQAJrAQ3BH/Iop3nmyO4VubOWw
ErkDGQe82FzEd8hn/a5Nb/Bi3jZ4zcipsy2hw4UrC/L5EVzSvifD+P20FCBUTQgF
/Tghm3Z34F402kucz/5Rsapy6VIoJjp46O7Sp8MTafV8ejda3M18qnIte8xloYyu
VG4EK2u6DXVg5x/7nAvlzJVijhaaRw1V7Pwy/POoroiiWlm7rwSEYKkSIWEZUm8G
XzpZ65dzFAELD6UIGNWSCVEJq0euLRbda/YSnkZfqR4amP6CU4I/B/KTX2oOXiB4
ecOyxoJ2GuxonwlebedF39VSA+i1OK+niGSPZUvJGrlNd7tgdRjxhrYwueDsk3yb
kYZdzP2E83x/mkKOUKCvLMxDzpthPsTDttUR23hnI4/tOlIQ8bb0II6u9+VvyEFC
A5s/929AHaPjIa3SQQocKwP2qo0ovCii5zwF8JfBPINzlCT6xdEReKMJgy4uDx7v
Wxgi982goDFkdQlz38x4AuMxx+MjlBYezXnPf3Y6DSmZqC7te25tx4GYNG+pqmE5
vMSWbWdpYVI7FT8oKMltPAw9aE/ATpXsdWWZ5h9UI4/hsIW9M0t/9QQHNeF4XDti
o6DicaJCTE+W1sRwpGXv6/33QpeDIuxSSs4b85QyDxWahrVkzB0i/X3zXF0UzYZD
bKAqttNGncURfbwkq5/B
=zBbn
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Mar_2012_16_50_53_+1100_bVMR93QPV.7OSj/7--

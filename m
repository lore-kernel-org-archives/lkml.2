Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2EAFE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:04:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36755 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2EAFEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:04:25 -0400
Date: Tue, 1 May 2012 15:04:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the usb tree with the vfs tree
Message-Id: <20120501150416.3b900d70af5f5173908aca00@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_May_2012_15_04_16_+1000_Nag2g8LXr_ORqG1R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_May_2012_15_04_16_+1000_Nag2g8LXr_ORqG1R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/core/inode.c between commit eaf5fb5977e0 ("switch usbfs to
use of simple_{unlink,rmdir}") from the  tree and commit fb28d58b72aa
("USB: remove CONFIG_USB_DEVICEFS") from the usb tree.

The latter removes the file modified by the former, so I just removed the
file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__1_May_2012_15_04_16_+1000_Nag2g8LXr_ORqG1R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPn27QAAoJEECxmPOUX5FEqAoP/2hqTxn0RKKyWwOwXIzEepPR
36vxRv5wa38AWQQ64fYYGK5mWgA06C/+7n5k0EZg6cXm0SUN2Xb1XIUuk4ANodsy
p+MlV+sXFr9lelaqQX66nFzXyvXu6Oj4RvSup2MOV1sVBfrIzw0UjlUi4Nwb0/22
/haKsqcfP/3W3k8NG8AbZWPQtczLffPxzyc3ET6EOZm4Y+ccYXJ/0aBSviiyVj2O
/p6/jDfAnR3ubc9ZcddCvlZ4wJoBwbZsYMVN0ewM23/2VboIkqihK5DBJSvvq7UB
0JJ4ZnZJQEf70px4mVo89FBd7HkIuMPK4p3dEOGj+BxKCWZ67mrmb4O3XhDK2iVu
ldnlfaTMbCc9fBQqri698CXat/hX7yfVMn0hCEroBNxb4znSLwLOBzsxE6Mfxjxd
x0eeVma5vrx8vghB159Fx/qUbYPrxTyAL27qzsAdgQQq1/V4uvMUHRbmjxZN9V6u
dmTQDlKBO2Ln8w9d6kLR5cRAux3WUeMhGLfhVfubZ9+ZrvYMgQAX14McOal+ELwU
BO3ScPaq/NN90Lg7lC1Gd88GjSnREcIp3jKI6SurwIoCRnOji02Y5uPj3Bc8xvZ1
0z6fAzumDFbYlEBo+f6moJHa1N6zTZ9OwtM2rgtE084NAPtVMgPI2zwtukWQcG2Y
gfVBMj5JPsHxORsb5Hds
=B2hR
-----END PGP SIGNATURE-----

--Signature=_Tue__1_May_2012_15_04_16_+1000_Nag2g8LXr_ORqG1R--

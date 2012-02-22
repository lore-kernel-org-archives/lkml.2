Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2BVBV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:21:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57476 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2BVBVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:21:25 -0500
Date: Wed, 22 Feb 2012 12:21:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: linux-next: build failure after merge of the bluetooth tree
Message-Id: <20120222122109.7aef5c672df3bab843214606@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Feb_2012_12_21_09_+1100_1ZIOTFP_vI53eugP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Feb_2012_12_21_09_+1100_1ZIOTFP_vI53eugP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

After merging the bluetooth tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

net/bluetooth/hci_sock.c: In function 'hci_sock_cmsg':
net/bluetooth/hci_sock.c:738:8: error: 'COMPAT_USE_64BIT_TIME' undeclared (=
first use in this function)

Caused by commit aebb77ca6ad1 ("compat: Use COMPAT_USE_64BIT_TIME in the
Bluetooth subsystem").  That symbol doesn't exist anywhere in linux-next ...

I have used the bluetooth from next-20120221 for today.

P.S. that commit is supposedly authored by H. J. Lu but does not contain
a Signed-off-by from him.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_Feb_2012_12_21_09_+1100_1ZIOTFP_vI53eugP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPREMFAAoJEECxmPOUX5FELwgP+wRcpY4n10je5LFlym02HqsC
WhELue+U5i3vwZPC4VQmKEVaWqrQqTfZp3fLx4965+4ky1jblApl0eyMpkt5Jc8F
9/FeO+nBaeNE/SGHSG0bPQAKqXIP61zX9RSvgVylcgyxAmAcNcMHIMY0T/ME6fS8
qKAoML9O6ULhr4C7iQzqL0pfVhqmGVXLL+GWiqTwWJ8XtBOa9vDp1yjhGexpriQT
XB7LaBBgIWJh8YqTz3xHI9zlgnaU/+fr36Vp5uk7UnXIRj1HkQ7MC38X+k8ul2i7
rMTskrG7woUe4C2H9etgUtsHOkvpfE9r6G6p9TBpC8XYd/iFYCcCtkeluGcCuX/Z
t8+bDQU4wXGxNMjDEgKRB9fM4ji0TUGsE+NclfXs+RcLFEANHb9wgP85edNRtshE
6Bpe+zvGMJBax2DDNMNA0XSQhbXP5wzX3yuOU+XU1HVjvQBMHP2b6tt7JhJcT41z
oQTaKsSLV/vHRYDM1Z6EhXF500e1R5NVSgfiIzQtRKfU7j46uW+RMbfAymZ4huCq
ZxqpfWTYe/TimHkjGf3XuPVrXRZo/BDEDGuXMGVnjhIYVVrpxvAHGWLWGlTArhyg
egx14MffKSEEz7Y/rBb1VLw+xrwr3vCvfaSUGxl0MnHVFu7tp/j6iSR16do04AJ8
4ti3KIijjsnnGupyChCk
=Xt0B
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Feb_2012_12_21_09_+1100_1ZIOTFP_vI53eugP--

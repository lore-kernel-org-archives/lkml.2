Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab1D1Bl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:41:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1D1Bl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:41:26 -0400
Date: Thu, 28 Apr 2011 11:41:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the bluetooth tree
Message-Id: <20110428114118.dd5a74e0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Apr_2011_11_41_18_+1000_NdJWcJkB_W7kIV1k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Apr_2011_11_41_18_+1000_NdJWcJkB_W7kIV1k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

After merging the bluetooth tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/bluetooth/cmtp/core.c: In function 'cmtp_add_connection':
net/bluetooth/cmtp/core.c:349: error: 'struct l2cap_pinfo' has no member na=
med 'omtu'
net/bluetooth/cmtp/core.c:349: error: 'struct l2cap_pinfo' has no member na=
med 'imtu'
net/bluetooth/hidp/core.c: In function 'hidp_add_connection':
net/bluetooth/hidp/core.c:982: error: 'struct l2cap_pinfo' has no member na=
med 'omtu'
net/bluetooth/hidp/core.c:982: error: 'struct l2cap_pinfo' has no member na=
med 'imtu'
net/bluetooth/hidp/core.c:983: error: 'struct l2cap_pinfo' has no member na=
med 'omtu'
net/bluetooth/hidp/core.c:983: error: 'struct l2cap_pinfo' has no member na=
med 'imtu'

Caused by commit 6657e8f0cc05 ("Bluetooth: Move more channel info to
struct l2cap_chan").

I have used the bluetooth tree from next-20110427 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Apr_2011_11_41_18_+1000_NdJWcJkB_W7kIV1k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuMW+AAoJEDMEi1NhKgbseQkH/jbYsoJp0crUHjBfNIV4Gpj/
qOCU5XUG1Wxjvw0tFHnjasmAUM5VCWB/MnxrPj7ods80p6n/txJrUKi8BWjghZUQ
sLx3M/bmTIUYawm8tmJYwxTyeBj+6M0NUIG/1KFNdKBU3Bjbo2VUkEFGbo5ANuHa
lY83CzTvchabA7HW3JPSA77IHqiVA0ii7QdU5b3hiBCnGv+i/TJUhlHrVAoJ4qH9
sjX5BT+qayjT/nvr74NwMUtfGC1qi0filNt8gDK8kAp+UbPYDyom+V67HreLw31e
oFsSCiSOABOKVGayayXUF026FSFI3IJoRwqZPAoP7zVFjQKBXwki7gjMm26IpaA=
=r5Mn
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Apr_2011_11_41_18_+1000_NdJWcJkB_W7kIV1k--

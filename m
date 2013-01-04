Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3ADBIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 20:08:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43586 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3ADBIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 20:08:35 -0500
Date: Fri, 4 Jan 2013 12:08:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pekey tree
Message-Id: <20130104120823.6ac07043cfdaad89d9e5b006@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_Jan_2013_12_08_23_+1100_+_F=ednUEy/_nwVP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jan_2013_12_08_23_+1100_+_F=ednUEy/_nwVP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

After merging the pekey tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "modsign_keyring" [crypto/asymmetric_keys/pefile_key_parser.ko] unde=
fined!
ERROR: "x509_key_preparse" [crypto/asymmetric_keys/pefile_key_parser.ko] un=
defined!

I have dropped the pekey tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__4_Jan_2013_12_08_23_+1100_+_F=ednUEy/_nwVP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5iuHAAoJEECxmPOUX5FEW4UP/0EWDOREoarIBgqHc4jGQJPv
9gaJ+ltkGD6jRUGWzn9k/verscBryupmFV+LtCT6EsoRTHN7TyVABtUxGpNUGo7F
WJvIW5RUgspkoMkcf18HPAWhEbS10ghoHJ0r2vieMsChezynD1n27rAPnvziL8pS
g2YBslx81LB+8zv1imvqWjv/ImA8XQFKNA/2AdKwdjdmRkkQIBkAplUf8ek1EqDr
IxQSBsiwZEwAYj4c+bOCwg8XyB37kzmh/TDNYlNErYwT3Kud5m47r3dErBIj3meQ
4VgN+m8TZMF304QH3bdziUvYl7Rwu2++pk5+07eYf2e3nJuHSTDhyH/jzRllOivu
911SjOrceJG5xNS+cQathS0BrKAqgmzwt/LtNNptMBvL3mLie3Pk0NiXHGeZGMj1
ZNQDWmo2nv+3+tSn3UDxR9VxJXFzHVPfqEOW7cY0xq7aOURoBpm90vAeWk/grX4R
VGLgTuKiv9JLC2YacHMfwJQVxGL53SmFah+WM0ZbZ6iv7R/8/tm5eReo2hMWRvLy
HwHoOlMYEc0JJMlBc1JJwTrW3jTdE1ik80JyDEKLd8eaWESfb3B1nzJG0t1HAoJR
1dG2aF3UtubGa/kiWp2V5fwIC10jcCln6TFPZdoFnc1qZcydHhxkTSgkIbJiemBS
R9zaezBK29giHGB1GKs5
=Wd3M
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2013_12_08_23_+1100_+_F=ednUEy/_nwVP--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2DXEsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 00:48:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55472 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2DXEs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 00:48:29 -0400
Date: Tue, 24 Apr 2012 14:48:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the staging tree with the usb tree
Message-Id: <20120424144820.326e86452826927b86aaf0f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Apr_2012_14_48_20_+1000_ybw9=jnn63HMg1CB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Apr_2012_14_48_20_+1000_ybw9=jnn63HMg1CB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/line6/driver.c between commit 2b8dec323d34 ("USB:
driver.c: remove err() usage") from the usb tree and commit c46b8a6567fb
("Staging: line6: only allocate a buffer if it is needed") (and later)
from the staging tree.

The latter supercedes the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__24_Apr_2012_14_48_20_+1000_ybw9=jnn63HMg1CB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPljCUAAoJEECxmPOUX5FEMMUQAIopPbNg9vAn5EZM+YYR260o
0p6Wrym6WKdI3Ck5m7BLcUm2quyP5ePblpTIuo+HPc2F/kv8jts84VOQ4xk1WoI5
VQZvA/fqDrcxp3ZTl9KhPOoOu8K37HQH7F41scChL49YNIQJFHlQsJDN8JKLkBDk
lH8c3xUlgeyX5jlOB2B1jw/cXvXfRET5NxAlYAGKi13jtTwCq+tcLc8/Md3SEEMM
ic0qV3XDr1g7aT79pURYtz0z8WHubmvUtqH1NSNgPVyW/kx7o13/h61PnwXl4nql
qKg9keH+pLdSgGuEH4lbe9JXPYIrobeurIeBLeD+lV5//QTE3zWonatuo/6SSK2y
r35N6oGGiRYltPRun5YSuhpazFoeKSljlTJpDX+Zk8rBbM/84h58F/8dJQJ9eWDV
q9mPZyx0sQDkgdI09SeqjqXmsIfrphrFeRqeSrOU9Mu5YCf6/tIfeZabA6JZJMUm
EWEo87yuMimafzd4pEPgRZ3w3AAf8P1/UBfTdFPDd6YUqa0+boA60f02OC0ISFM/
e4j7vbPFqSDALqOpmSjWHodXsaOf+WKON29qqaY7+NQ5i0lyvRLD+48fi7RTU3rv
oBJw3fahyE+qCbQD9jRk9EgH9TnnNB7ThuqbWdGfMJRl8EdkYpdAn9tOO3Nfx1aQ
wIbRMtuRlrh1adIu0nFQ
=Gmu5
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Apr_2012_14_48_20_+1000_ybw9=jnn63HMg1CB--

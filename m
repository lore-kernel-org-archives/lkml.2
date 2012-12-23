Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2LWWwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 17:52:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45444 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2LWWwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 17:52:23 -0500
Date: Mon, 24 Dec 2012 09:52:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: linux-next: manual merge of the driver-core.current tree with
 Linus' tree
Message-Id: <20121224095200.a94a61d18925f30909964dfb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Dec_2012_09_52_00_+1100_VK2anV_==tqPlPnn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2012_09_52_00_+1100_VK2anV_==tqPlPnn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core.current tree got conflicts
in 21 files in drivers/i2c between commit 0b255e927d47 ("i2c: remove
__dev* attributes from subsystem") from Linus' tree and commit
eeb30d064414 ("Drivers: i2c: remove __dev* attributes") from the
driver-core.current tree.

I fixed it up (taking a mixture of both commits) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Dec_2012_09_52_00_+1100_VK2anV_==tqPlPnn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ14sQAAoJEECxmPOUX5FEGRkQAJ4Noc6ZnwjoopDchpnd8IjS
CeuQDMvvOxRnPNcGJUtdeNoOX+U3619pTX9rZW54bKCNM6XHAwIDXq82ZAw/Mb6Q
qbwvejrbj3x28LA1N3TILE2DIsC9HBcEXjtSc3b1BlzqFTo+gjEUZ5nJiZNiLxdU
qBmhY1RMFfmLDPw1kqsimd7JllCO19M6jev2kWgitH/nihlrimRPMKP9LfwMUXmB
UBNCW9fwEcTWNvBPcAJjjjyBudBmS6DadC5f4MX5f6SjVOb7DzdIr+qQy8860NcL
rl2xwFMWcXJmeh/Wr4FUYCJv32n8Ckqtvy/YhNvwRUw0a9QCCL7vo8nwJFuomlo5
STqPbnNuNab9IpejAUw05TyxOwB3kxDr08NZAtAubJMF6ibBFMehyRhlG5JlNOzu
o2UghrbSY/XTGGY5BMe2asac554WL6N84tJGmyxcJBZnUdZrrXORtPfvVE1tOU+d
jRJwyjWqpha1fJt5a31ppUUTICAsm2H+wcwSG8oJSaKLl0GA6b56qvd/5kiweVme
XXzt4BkThITR31eFCY8JJtIjBJGJn57K6bQWYuQIM7rMdxhhd4gHWNefexIzhrN/
zCenji4VD7sT1GfAleGEX9Ie6XsxkmhIVLda6ScRZO35B24otZcKi0BIw2hvQ9Hc
KdmZjmKT/3GPDLEkP5kD
=+/fd
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2012_09_52_00_+1100_VK2anV_==tqPlPnn--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2CEAp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:45:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46315 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2CEAp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:45:26 -0500
Date: Mon, 5 Mar 2012 11:45:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20120305114513.547822059ca10e329c1bccb0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Mar_2012_11_45_13_+1100_J7THJLyrDdTTkD.D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Mar_2012_11_45_13_+1100_J7THJLyrDdTTkD.D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build
(powerpc_ppc64_defconfig) failed like this:

fs/nfs/callback_xdr.c: In function 'decode_stateid':
fs/nfs/callback_xdr.c:144:16: error: 'nfs4_stateid' has no member named 'da=
ta'

Caused by commit 4af2db6d9480 ("NFSv4: Simplify the struct nfs4_stateid").

I have used the nfs tree from next-20120302 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_Mar_2012_11_45_13_+1100_J7THJLyrDdTTkD.D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVAyZAAoJEECxmPOUX5FEJ08P/RUOHX6v+ZbK4aemqs/TYLjc
GjdJ5BpotRUbaAoYkT+mu77QklYd6imlUF0XI9p40RQRW6MApZSLEcTbCPHhYVfq
AlK+aX4hAy/r1Y9RgkTsxTnPflDEh9AwjdzI75Tc1xsuQsAuotTUKarFD+YWETxm
tYYGTRAGXPWDmh+/Zp/7Le4dHe9qqX0V8D1rAzD29bgXbIb7BQEcEV6NorIBSj2o
6g1QMp5KBA2q1ip9o/B3jT1Yz7CXELlLApb5vNuLUporwg8lsQ6VQ7L+FrEhGGn7
keKv4+eqC7jiX3OgXgYqWkpGkJU5ipqtYY1vAAEPzpHifTg0CfzxIiWaBJ6bdr7K
MbYbABUuCgznj66ljnnpx6TkyDOVImGXkfw9QoZtoqvk5C3XwD5jY0Ag6TmeGku4
N+TcrEmasCR5vno/OnnAZU9dB6PUCwpoOag8iEnwFndSLijXbO+4zHgG8E0HQEbf
x7FH1jEWVNgbWfr6wgKmh3/UUjjxr0NHx5hdjBecG0x9+TUOyaqZHDRI69gzma/c
XyzECiqi53YEfj7a54dUoFNjYHmozwMNTrUnJEXu7COwiA2TH3gOy/qOZUXedJMo
kejd5cuCpFQcDpYEaL4qF3Lwa/jgLx5rl6Sdp11/V+0Hx+bg4szHriLNGpJF+0NN
OkGKK8PuPyFHn49YNjoL
=q9pW
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Mar_2012_11_45_13_+1100_J7THJLyrDdTTkD.D--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2HAWmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:42:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43921 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2HAWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:42:04 -0400
Date: Thu, 2 Aug 2012 08:41:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: linux-next: removal of some trees
Message-Id: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_Aug_2012_08_41_54_+1000_S6wVwb8Ag.PY_P/G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Aug_2012_08_41_54_+1000_S6wVwb8Ag.PY_P/G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Since I haven't been able to fetch these trees for quite some time and I
haven't heard from you about them, I am removing the following trees from
linux-next.  If/When you have time to maintain these trees again, we can
add them back without problems.

samsung	 	git://git.fluff.org/bjdooks/linux.git#next-samsung
bjdooks-i2c	git://git.fluff.org/bjdooks/linux.git#next-i2c

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__2_Aug_2012_08_41_54_+1000_S6wVwb8Ag.PY_P/G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGbCyAAoJEECxmPOUX5FEh6EP/j/Axli6VGXC63GA1YVd0wBU
FJ1WPqEefn9ceC9bq6Ypadh0avG8k2pYdJxinwfufH97BTOOV/htKIvwarhHH4c5
13MV0xG+PmS+7FFU/TXAibDw993uIFIIOliKxzoyGtj8NtYCAizlt/8+NsQZ1isL
eaj2WAB942O0NuK2EmF3RXxoXJm+Pd80IkJWMuy/Y8VvmrEbEJDyYbxE6Rmt7wkY
DQj6+YEw5Gj3rq66lTQG53dVjWKM54ahlLH3LxVuFLp0soluUICqkr7P2CXDbwU6
37ghkvkQ7u0+tS4FMMmV7SRtzwT5V99bZrN+MSPjSJtjQCKke5Ogag3qmM9oH9bU
RNcZUQ54QOxNshXHTqSfssjhz1z8/3N1cHUn+T/9RCF7vz/TWDkNisRM4YdYW8mY
JjZfNEC6iMyufIXqxVMdOA21Re6kRXhCKOJwdpRWslaP1qzWXaKd2IzEb3muf+8I
FOLhuFKpGp4WAzON5pYT8CQpHSEuce2lyhB9sA0aLpmo/H1oBSdZF5V1d9jT0MI9
AZwVeV+6IpzVbbkgCvqQA99Pb7vUoTRMo/j+RQdXfcpIY8GXYgNqeD6qMrjVP9or
Y1awY3xEmvZGqS5qdDu3q9IQ49WJwrZiWZZ/Szh+lOh8to58wOD0u33DZu3yrPBW
5NZBqIhR75XQeGjdh/AI
=WbNY
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Aug_2012_08_41_54_+1000_S6wVwb8Ag.PY_P/G--

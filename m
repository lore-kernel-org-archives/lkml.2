Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1HaApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 20:45:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37404 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1HaApO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 20:45:14 -0400
Date: Wed, 31 Aug 2011 10:45:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error trying to fetch the squashfs tree
Message-Id: <20110831104506.c459b8677f13541fad300b58@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Aug_2011_10_45_06_+1000_o3BYbcu2fGXfKa18"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Aug_2011_10_45_06_+1000_o3BYbcu2fGXfKa18
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Phillip,

While trying to fetch the squashfs tree today, I get this error:

fatal: '/pub/scm/linux/kernel/git/pkl/squashfs-linus.git' does not appear t=
o be a git repository

I will use the version of the tree that I last fetched for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Aug_2011_10_45_06_+1000_o3BYbcu2fGXfKa18
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOXYQSAAoJEDMEi1NhKgbs5LsH/3MkPvDEWYqtwhDdhaeYGRvZ
oBC9BqBiLkYqM2g/EnmVXebu+Nl5OwMcA9fRoespW086IGUgYbpaSGPtuiHeapf0
hVf8jhxCAfPprUO3ln/U10S9uqPPXPs4mdJiZ/ccLIaC0f6PRjgz2idMfspcJzzD
4be/8DoL0r3YTcaPK+kQBEtyAxY0bqiaQ9rppME3sG/5EwstC/wJo0TMeuNv1xmA
/4qvisZO0THaAql3ss63UEP6A86cyQtNurfhB2O+ZMJ7vmyGQexh5pKETEedsiFm
ZYkZOCxMQKwfy8eFYZwmhvG9C+vtEBGuHrCKXHRD2/Gf5ZTqaLgbUs9JqLE8F08=
=2LWN
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Aug_2011_10_45_06_+1000_o3BYbcu2fGXfKa18--

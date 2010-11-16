Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0KPXnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:43:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36367 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab0KPXnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:43:23 -0500
Date: Wed, 17 Nov 2010 10:43:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ceph tree
Message-Id: <20101117104314.56aeb069.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Nov_2010_10_43_14_+1100_eu.VsVV0voP8xvzA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Nov_2010_10_43_14_+1100_eu.VsVV0voP8xvzA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

After merging the ceph tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "ceph_str_hash" [fs/ceph/ceph.ko] undefined!

Caused by commit 5f69106b3f68be20015d1d8a43192bc2f14c7046 ("ceph: add
dir_layout to inode").

I have used the ceph tree from next-20101116 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Nov_2010_10_43_14_+1100_eu.VsVV0voP8xvzA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4xcSAAoJEDMEi1NhKgbsdg0H/0EhDNBzdnsrKdfzoSa7xoLH
a/oYTMmEKbHOa1kllt/VR2+Tfg+5MokGuVSIKtXXhHQLuOE6qsohQJWIL5bnLPgw
GqhZJPwIHGv/FdE9MumxZlkywe0oa8zIemmfVEOhJch2gv2q5a+7bFLd4aoIcX7I
sJQ04YuTNzu4rHnZwSfKWUOuDcifUchQGRxF6Srcn9jDoVZA/IRCL0y+rR/Nm//S
4CjuN6lKBJAlkHTcICDc//+h6RN8A73ZxIDLizD3IXpcw0twfHmfJ7Y4UvS/NZxQ
YLHTTZCRkkR9r0bV6S7VsUR1G8l1OsO9ez/jepCSp1K4FtUToDsaG+RJEcwPcCs=
=MS7v
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Nov_2010_10_43_14_+1100_eu.VsVV0voP8xvzA--

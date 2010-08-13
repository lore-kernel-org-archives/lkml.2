Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222Ab0HMAd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:33:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45424 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0HMAd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:33:58 -0400
Date: Fri, 13 Aug 2010 10:33:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Ma <tao.ma@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the ocfs2 tree with Linus' tree
Message-Id: <20100813103351.cc54cb8b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_Aug_2010_10_33_51_+1000_NmU/nUAJhwK7p4YI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Aug_2010_10_33_51_+1000_NmU/nUAJhwK7p4YI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joel,

Today's linux-next merge of the ocfs2 tree got a conflict in
fs/ocfs2/file.c between commit 2c27c65ed0696f0b5df2dad2cf6462d72164d547
("check ATTR_SIZE contraints in inode_change_ok") from Linus' tree and
commit 7b2beb150acfe03445fc61c1302c4225c633776c ("ocfs2: Remove obscure
error handling in direct_write") from the ocfs2 tree.

The latter just removes that code that the former is modifying, so I did
that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_Aug_2010_10_33_51_+1000_NmU/nUAJhwK7p4YI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMZJLvAAoJEDMEi1NhKgbs6LgIAJbfMv0z50ZN6YEpkUg2vpUC
PYgheL7LmVh+e5YLhhAB2JuISfqUUKt6U7mpCTkCzCWBoXomP7CKM2zvlivSNT3G
QA2z09CLIBkJg4n5QQLxOAn/Vre5+eRnZwjwiTGIVtfsnLrJ29niYaaBzRrBD7CD
QsxSo8onuU5M/CdfSsw1Vso8l5vlAWbGug6Is0PbcLWBOFOmzKOhYQRuBVgm7ErD
gWamzP7JaRY2pa4Y+uqT3nvi/xd5ySfAb3WIvSPWveIYjB9Vgbqh7XZpCvQNk7Fk
QphsZHpxp9vugUuUTnw6nUtQDfVPlnHt+wcpzunryRpyp9TxAXMcTg2N8z8Qppw=
=lZcL
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Aug_2010_10_33_51_+1000_NmU/nUAJhwK7p4YI--

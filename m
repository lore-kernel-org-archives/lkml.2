Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0FNB63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 21:58:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59884 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0FNB61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 21:58:27 -0400
Date: Mon, 14 Jun 2010 11:58:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the ubi tree
Message-Id: <20100614115822.728c3199.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Jun_2010_11_58_22_+1000_ietD4KRNIf3EpKVQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jun_2010_11_58_22_+1000_ietD4KRNIf3EpKVQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the ubi tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/mtd/ubi/io.c: In function 'ubi_io_read':
drivers/mtd/ubi/io.c:153: warning: initialization makes integer from pointe=
r without a cast
drivers/mtd/ubi/io.c:170: warning: format '%s' expects type 'char *', but a=
rgument 5 has type 'int'
drivers/mtd/ubi/io.c:177: warning: format '%zd' expects type 'signed size_t=
', but argument 7 has type 'int'
drivers/mtd/ubi/io.c:177: warning: too many arguments for format

Introduced by commit 1a49af2ca019dcb4614c32f832bbcb814b61409c ("UBI:
improve ECC error message").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Jun_2010_11_58_22_+1000_ietD4KRNIf3EpKVQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwVjL4ACgkQjjKRsyhoI8z3mQCggLNMOfLoLNlhOJKgnOpwGM7X
RMAAoIvAUNjUYGJl6agGnem21anP+f18
=45gA
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jun_2010_11_58_22_+1000_ietD4KRNIf3EpKVQ--

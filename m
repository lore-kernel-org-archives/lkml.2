Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1FGBNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:13:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50069 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab1FGBNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:13:31 -0400
Date: Tue, 7 Jun 2011 11:13:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Connor Hansen <cmdkhh@gmail.com>, Peter Jones <pjones@redhat.com>
Subject: linux-next: build warning after merge of the ibft tree
Message-Id: <20110607111311.dad07c01.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jun_2011_11_13_11_+1000_gB2ZUd3gBf/8tGq+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jun_2011_11_13_11_+1000_gB2ZUd3gBf/8tGq+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the ibft tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/firmware/iscsi_ibft_find.c: In function 'find_ibft_region':
drivers/firmware/iscsi_ibft_find.c:114:2: warning: ISO C90 forbids mixed de=
clarations and code

Introduced by commit e632a78d3a93 ("iscsi_ibft: iscsi_ibft_find unused
variable i").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Jun_2011_11_13_11_+1000_gB2ZUd3gBf/8tGq+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7XsnAAoJEDMEi1NhKgbsMsMH/29HRvr2HlCy1c7totj5CZwb
ube/Ofk8GU6uicb3vTiNvkIhV6+zHLIy0rHJM7jZn3DTiZv7s9tONvsh8qyIMqw+
CXkEY4oxMNJBy5D46OimCHf7oCx0aN2uMHQ9o/gkdRvzRQ9XvF2CjfNbx8nxMJ5b
erMFsdUZWXF3Aga/Xy5vJHop+W+Du3NtbNNdNoUo9U6XNio7ZpJD/eo9JZHStdrz
7dEx7BxXIFRhtnllze28XiWUwKvRN0oRTyOzlp09UVa7mYTT7X5CNvoSr+lM0MpC
kSYXy5HH43zTJuboU4/pP9vVMAjCOAHS2H9AVFocrNgUG2daKzg6JqFTLUfM5N0=
=RY7I
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jun_2011_11_13_11_+1000_gB2ZUd3gBf/8tGq+--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0JYCai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:30:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54188 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0JYCag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:30:36 -0400
Date: Mon, 25 Oct 2010 13:30:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: build failure after merge of the xen tree
Message-Id: <20101025133021.53649fd1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_13_30_21_+1100_f1HEnyY1WvIhS6W6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_13_30_21_+1100_f1HEnyY1WvIhS6W6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xen tree, today's linux-next build (s86_64 allmodconfig)
failed like this:

arch/x86/xen/setup.c: In function 'xen_memory_setup':
arch/x86/xen/setup.c:161: error: implicit declaration of function 'xen_init=
ial_domain'

Caused by commit 9e9a5fcb04e3af077d1be32710298b852210d93f ("xen: use host
E820 map for dom0").  See Rule 1 from Documentation/SubmitChecklist.

I have used the xen tree from next-20101021 for today (due to the complex
conflict in Friday's tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_13_30_21_+1100_f1HEnyY1WvIhS6W6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxOu9AAoJEDMEi1NhKgbs6e4IAJezidwXn2mzLDBIvJFAAHKg
qEREqatuYeZXbk3rLfNTwEbiJUGivDbZ5ItnTKJkY7LNVMseNIAYge+FrvSDdjK3
dkLjq3JDLAzgT2j761ajNLs2+WnTQvEGxR4yFT0Xq38rnZCrON1hj2jtLQtUprM9
ErhRMT3kB5hGOXYnD5PkOf2FlXmjj3XAQR9zRnGesLR472yy12wlLbNpJLbOkDT5
O0V6BaRaKtJr+OkYEePtDTHoEJ+2AnaAZNZwdV/ydglce4xLz3hxY30oWOKimPzm
7FWXdi+xn1Wg3FdR3wC2WadKzg4iJm2XVYYuA6+MsHuUifO9RctehO0JSlPXbVE=
=tIgA
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_13_30_21_+1100_f1HEnyY1WvIhS6W6--

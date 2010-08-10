Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0HJCLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 22:11:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36636 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0HJCLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 22:11:25 -0400
Date: Tue, 10 Aug 2010 12:11:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Christoph Egger <siccegge@cs.fau.de>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20100810121117.8710aa26.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Aug_2010_12_11_17_+1000_u=CHSRkJrpHDAeg_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Aug_2010_12_11_17_+1000_u=CHSRkJrpHDAeg_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-omap1/board-nokia770.c between commit
ab6f7751905e5cf713d081dbb3b97b8f6909ab34 ("Removing dead OMAP_DSP") from
Linus' tree and commit 426d31071ac476ea62c62656b242930c17b58c00 ("fix
printk typo 'faild'") from the trivial tree.

The former removes the code that the latter is updating.  So I just
removed it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Aug_2010_12_11_17_+1000_u=CHSRkJrpHDAeg_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYLVFAAoJEDMEi1NhKgbshuAH/2aLvvsnn1ub2QA9IgT1TUwb
hIVbGzSQAzWNRhH3tI29loWd0p+65m9OZaImmBWblBzwhFGbRjpMzY45w7GCMpkW
9tnI2kHwypkGeV83h5Q6FDYXq1jYt6KruLjAa3q0e9qoIJA/HZbBt7UzE+H/8VG5
VtlPUZ+nL/sgv1agWC+ovOf+D4KKgCNr3XaerqNzobtjRYGrKHkENI7g+p/TBkHy
OC0FmrvDVI6ao4ist9hXYsCNCAor/N2lFdghIxSTkWFYK73iDNQamRVJdCr0NHlt
+NiGEl6QeE46PahhpcnZfQLRJgtAGa9udya0m0ftQW4X9RDN0b1HFk3n9l8rtAA=
=cGsp
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Aug_2010_12_11_17_+1000_u=CHSRkJrpHDAeg_--

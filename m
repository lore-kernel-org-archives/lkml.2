Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab1FVBNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:13:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49308 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab1FVBNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:13:08 -0400
Date: Wed, 22 Jun 2011 11:12:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the m68knommu tree with the m68k tree
Message-Id: <20110622111256.3857df1e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Jun_2011_11_12_56_+1000_PUpRYI5jolSR1UkJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jun_2011_11_12_56_+1000_PUpRYI5jolSR1UkJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/include/asm/bitops_mm.h between commit 17c74432b88e
("m68k/bitops: Make bitmap data pointer of atomic ops volatile") from the
m68k tree and commit 2cb0d89e66b1 ("m68k: merge mmu and non-mmu
bitops.h") from the m68knommu tree.

The latter effectively deletes in the file and in doing the merge,
removes the funtions that were modified by the former commit.  So I just
removed the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Jun_2011_11_12_56_+1000_PUpRYI5jolSR1UkJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOAUGYAAoJEDMEi1NhKgbs5FAH/2yLZz1SckjQDHmnOuOMF4hU
R084Vd1K6opccXAmQL9SzDa1k6gQ4T4CHO+rydrINRn2XE2QQij7AHeyCXH+VFKb
mydIXocq50FGTuLgE6VvOrS8ixVryMw5o77ikimFN65vBTJAtSp6ebi5waVNA/gV
eHj2LHa6ajt/oIgr2CMLgUJ3rgolRVj+3fCQScae64qvzM6kq7fQ3bIMoUTKSYgq
1ea5DyjdGSWVnQ2BMj/8Ac9xXfcJRGH/UOdBi3vTFm+hF17YojfSRLMRsMh+rRY1
Ae7NFGOfe35OP5XyHc62g08DYmi0BabEGesFWJLXuqkImztcnQ9bCod879nIBn4=
=FIYc
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jun_2011_11_12_56_+1000_PUpRYI5jolSR1UkJ--

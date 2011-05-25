Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1EYBEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 21:04:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37223 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab1EYBEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 21:04:34 -0400
Date: Wed, 25 May 2011 11:04:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Subject: linux-next: manual merge of the m68knommu tree with Linus' tree
Message-Id: <20110525110424.0f3dbe85.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_May_2011_11_04_24_+1000_cJEMcJGzsIat0I=l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_May_2011_11_04_24_+1000_cJEMcJGzsIat0I=l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/kernel/m68k_ksyms.c between commit a697dc934f52 ("m68k: merge
non-mmu and mmu versions of m68k_ksyms.c") from Linus' tree and commit
e05f64c1bac9 ("m68k: merge non-mmu and mmu versions of m68k_ksyms.c")
from the m68knommu tree.

Two (slightly different) versions of the same change  I used the version
from the m68knommu tree as that was comitted later.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

P.S. Greg, do I need to change your contact address?

--Signature=_Wed__25_May_2011_11_04_24_+1000_cJEMcJGzsIat0I=l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3FWYAAoJEDMEi1NhKgbsTFwH/j6tKDf5dxO0AiFc7aHUuWY1
pJaXJhDCYSL0udtb5W6f6+qZNbzNRor7oAI2UgjtlodgHow0cQAjrR0mClphASAE
FJy+nuu63ebejI5Fm3hSNPcYsI5HwH2YGKfy0EIPyNUFhyKqAKyAk7Zf6RBQJPk6
Nno3FpWmwJq7TWcjXWF3JRjOlkdlZHjmyNODBrQdv8P9KvneiQRrqZyYi3yiB+tV
laYNRmTvjoPQWElukIob2mjM+g1F+UU6C5umuVUins+z4BRcUe9rHJ9+3OIyZpom
W4sS7UzF74E+quox92CxgIS0clTpW9hfj1U07dzNJOtLc3dzvrfn3XrPjNQlhjw=
=N7b9
-----END PGP SIGNATURE-----

--Signature=_Wed__25_May_2011_11_04_24_+1000_cJEMcJGzsIat0I=l--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1JKDuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:50:01 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49832 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1JKDt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:49:59 -0400
Date: Tue, 11 Oct 2011 14:49:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Faisal Latif <faisal.latif@intel.com>,
        Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Subject: linux-next: build failure after merge of the infiniband tree
Message-Id: <20111011144952.22ef7175eb5c4588448f8856@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_14_49_52_+1100_yb/vExX+/OmMM2.Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_14_49_52_+1100_yb/vExX+/OmMM2.Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/infiniband/hw/nes/nes_mgt.c: In function 'get_fpdu_info':
drivers/infiniband/hw/nes/nes_mgt.c:328:3: error: 'NES_DBG_PAU' undeclared =
(first use in this function)
drivers/infiniband/hw/nes/nes_mgt.c:328:3: note: each undeclared identifier=
 is reported only once for each function it appears in
drivers/infiniband/hw/nes/nes_mgt.c: In function 'nes_chg_qh_handler':
drivers/infiniband/hw/nes/nes_mgt.c:664:4: error: 'NES_DBG_PAU' undeclared =
(first use in this function)
drivers/infiniband/hw/nes/nes_mgt.c: In function 'nes_change_quad_hash':
drivers/infiniband/hw/nes/nes_mgt.c:728:3: error: 'NES_DBG_PAU' undeclared =
(first use in this function)

Caused by commit cf3fbdf123bf ("RDMA/nes: Support for Packed And
Unaligned fpdus").  Please build tes ...

I have used the version of the infiniband tree from next-20111007 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_14_49_52_+1100_yb/vExX+/OmMM2.Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk7zgAAoJEECxmPOUX5FELikQAJf6mGhQV7fpQM2uiFIIDvaS
wBlCc210MWztKnNqvV0ckv+T+yhDkAsyqNwJCy/Beq9qexJPGD7MPm0XHRIBZPRJ
CBTopZR026kSm3t/6GNRLGDbFMgMWRngNePAjphMMs8aSQcJG9iWtKA+KP/ZipVu
iaIvxwgbJELKObWKxPlj/U7nIHkNbdUWNI7aSmTzo9SwEbn5D75v5NbKCRCZaP1L
9sLbGehBzyFh1k9uOHGOlJQDClpMLxBntVJmd23rZ/GwAXgfAFV6ZSA78b1mKh0K
rnXu3gUo+19CGPxVBlD+ufjScbkju2dm94kzUPgK7dfvyjKlOT0CiwjUyJqNGDCp
P7lgS5UyaxRNcmq9vW7rg6tkwMBdiYzDyehRBPe7vgSW4Rh0RteVduMBxMngFWqN
VNQfYCHkqPtg5bnjZpfMRC13wyV8TMsaV8urT0uTzXegCHMtw9RoBVxDu8Jlh6I1
SoWwx+nRjDpc0w6B/L3H4HtUHaw5jtTHPkWIKiKs35jXOfR/45mZexPZNAvcpcni
A19+0OVPU+08+5i7hEsOxNprE5RB19JAcnt+cDb5MxHUbWBKDs7JkyYVij2qw8H8
sBehuJF+WRCUpQeSd8hn3k4daU9jcr9ExCpmgQWxitFD11aGF8YsAPtDE7hyDqVF
GkKbolDHcCYcwf7IQCpI
=1crY
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_14_49_52_+1100_yb/vExX+/OmMM2.Y--

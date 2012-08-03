Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2HCO1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:27:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2HCO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:27:08 -0400
Date: Fri, 3 Aug 2012 16:26:59 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: Include linux/notifier.h
Message-ID: <20120803142659.GB12268@avionic-0098.mockup.avionic-design.de>
References: <1343226290-32511-1-git-send-email-thierry.reding@avionic-design.de>
 <1343226290-32511-2-git-send-email-thierry.reding@avionic-design.de>
 <20120803140826.GF1996@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20120803140826.GF1996@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:YdsHiUclqjdRfXgCd7GoV+atqA1RCfs6CCwzSK+TOxo
 kmZr34irlts8p7GqSJLcAaw6XXQqZ87zp+nbhYc/jua+7ud9a/
 gJgdi+3R7d5bbyfU5vop7Vytl9YPm7RFhts24m0e4xbmNNfjN6
 Wnj+bIsaVbXYF1VEnQ+oBNkInyXkExT1Y6zaUUOYlSL33lecgH
 YjlWJw79zJ035uqwqa3Mhk+5lzISkGcdEqc4LZwZQPNUWYkZeF
 wUNTiJiBxa+JwbEJkloW06B8MJueHd1gUKy+CXzmA+TXsF7vJa
 QPd9oxT5/CdomNEb48pyD8QK9gkYavvEVOfBxfJfTdlQa0ONLY
 5M9sOTupLkJORV6Zo1jhUfLGLOMYNApmET3R5fWH2HOlCNFuxt
 AXI90Hh9AYmlma9yG+g0SAL0CG6ap98xB3VmYkVDA31FD3G+UI
 qtAjz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03, 2012 at 04:08:26PM +0200, Joerg Roedel wrote:
> On Wed, Jul 25, 2012 at 04:24:50PM +0200, Thierry Reding wrote:
> > The linux/iommu.h header uses types defined in linux/notifier.h but
> > doesn't include it.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Better than adding the header-file is to add a forward declaration for
> struct notifier_block. I added a patch to iommu/fixes for this.

Yes, that would also work.

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQG9+zAAoJEN0jrNd/PrOhmVkP/1lDXxoFJvg97e4yBpc/P7j1
BfmGWa2bUciZ/pQfipPzg4wbSwX/Q/ca1eWfVI0k7Rh5GXohA8/Cm1pe/bQ84h3Q
XiPzm4gXweQteQZ56R52NbjHK0MLIgevcsh1ES+HEToIsZ05ZbwkZxQfUbPmDGkt
tN8n0VIgUkCnlKjucMxD6GoXuPtL3N0/uQrjVEy6fuXN8gt7t6JOpzzvLLNU+mXh
KD1TdWoSWw0mxlXJF0F2N6XJDaeLUgylOixl5PkPbCwpyf15A7tMtevfuPiQ1ObC
5OAxbxSmv5Ixe+l2BTTP6YP7MmomSE2Iz5lhIr9UGZUivie0KapiRdbl8sJCq+us
3SkO6veL4lVpnnwKltsZIIJlRvbeb6qR0FeNCaTB88x6ZqTAANKLda7YBT4jwjfp
+OGSh7gR9Y7agf0sgBgUrixu/nO0Lp4jYbPmbGMtKMUSZORimJDZvJpi27rwzprO
t3ivLSVn+3sRHzNMgx5ZSH3QNYXbcl2F8ifZlPv5E3KsyQlPbhfq030C2R9XfdRc
6HdJ3VrjLdGmWkKDmMBa9ySoJGRu9+OOI284tMEj2db+rspMwRsswZM6gzGlmstx
Nypv3NfAXc6u0JF2ZecqkJjCajGOoTLu3uGWRMbWi4kJZXb7nSiigdTxB7UPgZjx
DvwbmTEQnvRRDjwZTX3+
=phih
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--

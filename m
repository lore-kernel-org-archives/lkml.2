Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab2BJEsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 23:48:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50457 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2BJEsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 23:48:04 -0500
Date: Fri, 10 Feb 2012 15:47:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20120210154753.54d5620ba268f2d1e8717838@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_15_47_53_+1100_E_.qCC7NNbJ+_40H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_15_47_53_+1100_E_.qCC7NNbJ+_40H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/zcache/zcache-main.c between commit 2a4830110b90
("staging: zcache: fix serialization bug in zv stats") from Linus' tree
(and also in the staging tree) and commit a49aeb1de585 ("staging: zcache:
replace xvmalloc with zsmalloc") from the staging tree.

I used the staging tree version (since these were just further changes to
the same bits of code).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Feb_2012_15_47_53_+1100_E_.qCC7NNbJ+_40H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNKF5AAoJEECxmPOUX5FE9LQP/081Nn8SrInphXJIYQUwfeCH
mOL8VlujjTYRGTX5TXuy+nuN+/G2OqMQ13a68c+6XxK0nbqaFDkYaF4caz0+iJQH
iXdIJ3FWuuHbj42h4kjOH0LDo6Fpmwkr6L+g9zPlY/osumFm4CDjKKPtw93DCwN8
x2uqhYDsYmRN/WRSXgrJ2LrCw023wFHHDV5xt7rWYtdml5OqhKBWSAqBCno81jwP
/G6wB30qMqTBDEgtAwCPriu2OztDjoZC5ws19zQEmRyAg/dyraHMw8542hS03lyR
fnci6BBezdEt2zYcHgVx2DoWdfSvyleSLa8x7ietns7w5w436S5psK1AJR14KEXC
nFr18sEvOXFcLZuHwgAjYBwy/8IeT737HkbC14Ui2155rb5wzZ0g2st1ILUNlKtq
FXIB4AdzLFFxD4IxDtVthEKPMOueE5fZ5pv/nin2x99JVtDbCy2h6HOEZm4fhXc6
F+4oDrPYq14lIkBJL/BiTOs9cHwGjYLpccMmLizPnWlBSeODujUPG0JLUF7IIyyT
sIMXtLok3toD+UOPY5SpvQSz9lmYySnm2SXVuOA9UhRxiKae0opA8iwlT6u59MxG
0zD2m5324aOZNm6n8i+BQANEOHcOxgK1S75luyPEnXrHU4rjL3AG0JsfIVmm3Obb
DPV1fNipxYsQWgF/HJkk
=tKqE
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_15_47_53_+1100_E_.qCC7NNbJ+_40H--

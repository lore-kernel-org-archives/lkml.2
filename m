Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0GWC0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:26:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49547 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0GWC0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:26:51 -0400
Date: Fri, 23 Jul 2010 12:26:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the kgdb tree with Linus' tree
Message-Id: <20100723122646.a788fc86.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_12_26_46_+1000_/2H4MAE/m_EmqTqh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_12_26_46_+1000_/2H4MAE/m_EmqTqh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the kgdb tree got a conflict in
kernel/debug/kdb/kdb_main.c between commit
edd63cb6b91024332d6983fc51058ac1ef0c081e ("sysrq,kdb: Use __handle_sysrq
() for kdb's sysrq function") from Linus' tree and commit
93c47fada46e034941106fb34b76a00a87108fc5 ("kdb: Restore previous sysrq
state") from the kgdb tree.

These are two fixes for the same problem.  I effectively reverted the one
from the kgdb tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Jul_2010_12_26_46_+1000_/2H4MAE/m_EmqTqh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSP3mAAoJEDMEi1NhKgbs9+wH/0TPWCUv3doJI2FzcG+ev0yd
eqs5PJTpoSeFpcBW+C4kJrWY/ls3R0+M8Nzx9DKQ1EWLBHZolodWBPnMUBCaHXL5
F7foe3PO7jR0RtOxxLvX1KOcp5rMOKtAB4NVnl5ZaRgSpEzanHMc7BjliwytkcIz
MEFao6sB9pXoWgzpuvWZcc1ybqu2TSyvWvzcYnoHlgd73xhcgAConABRBCRjnaUQ
uXTFnrd1WCQ+a7C7wVeXUJVLxPwBgjuCicdflqETUl17fHDiw/7AC0XcnFKg2otI
twlXLbVd+z1LEcza3c/FmzVAb9RCQMm+UF2/e+AT51jpXRm6qwaK01JuL68bdBU=
=T7RO
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_12_26_46_+1000_/2H4MAE/m_EmqTqh--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0EGFVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:21:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60269 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0EGFVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:21:17 -0400
Date: Fri, 7 May 2010 15:21:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: linux-next: manual merge of the staging-next tree with Linus' tree
Message-Id: <20100507152108.49975171.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_May_2010_15_21_08_+1000_RXWNxmHMeLjIcolx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_May_2010_15_21_08_+1000_RXWNxmHMeLjIcolx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/hv/hv.c between commit
fa8ad0257ea256381126ecf447694622216c600f ("Staging: hv: Fix up memory
leak on HvCleanup") from Linus' tree and commit
eda95eef15e86e100aaeeec4e8ed3eb1eced2967 ("Staging: hv: rename Hv.c to
hv.c") from the staging-next tree.

I used the staging-next version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_May_2010_15_21_08_+1000_RXWNxmHMeLjIcolx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvjo0QACgkQjjKRsyhoI8zajwCfXSADdHPCJxFju9drKo9axT2G
DYgAn2EVXJ067EUSkcRaNI38/Nm4htnw
=66ZM
-----END PGP SIGNATURE-----

--Signature=_Fri__7_May_2010_15_21_08_+1000_RXWNxmHMeLjIcolx--

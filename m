Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1FQCyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:54:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42860 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab1FQCy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:54:28 -0400
Date: Fri, 17 Jun 2011 12:54:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Mallon <rmallon@gmail.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the trivial tree with the slave-dma
 tree
Message-Id: <20110617125419.c196ca92.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jun_2011_12_54_19_+1000_3=mI8TaB_FoUgqqp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jun_2011_12_54_19_+1000_3=mI8TaB_FoUgqqp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-ep93xx/dma-m2p.c between commit 8e4a93008db7 ("ep93xx:
remove the old M2P DMA code") from the slave-dma tree and commit
1c5454eed85a ("Change Ryan Mallon's email address across the kernel")
from the trivial tree.

The former removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jun_2011_12_54_19_+1000_3=mI8TaB_FoUgqqp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+sHbAAoJEDMEi1NhKgbstQ4H/2RI+YEgkP7bgfQCULC1X9D1
AssMiuc20acKk/XjfG+YcXZDUezX5/dlC5LlIz+VkbvFCsxoEIHdGHEpL25GYeod
17XF4F97FQdFTrjw1DGXoXvjoYTDMZKCVue8QVb504JHblDN+94YaS/7z0yCKWBE
MBb1cOolq9IGybxSroao99Y6Lw2KfclEsUvFkcsp60aSNGn1mtynBY1jWorz/jSO
7oilbHR9QHUWUazfswiIAw2WRvW8c5koSyaYDQZHzUuhOuy16uRl35EMpbRpIduK
4UbBMaSVA9jSaZYbWfU/WTIE65Y+y5H6KEe+fVgW+poHiHvQzQn+h+GpRP5rj/c=
=EFNh
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jun_2011_12_54_19_+1000_3=mI8TaB_FoUgqqp--

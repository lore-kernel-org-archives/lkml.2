Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab1FADEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:04:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33237 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab1FADEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:04:43 -0400
Date: Wed, 1 Jun 2011 13:04:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: build failure after merge of the final tree (mmc tree
 related)
Message-Id: <20110601130431.59f4f0d4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jun_2011_13_04_31_+1000_fkVSDzs7jWb2MRU_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jun_2011_13_04_31_+1000_fkVSDzs7jWb2MRU_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_pltfm_register':
(.opd+0xd8): multiple definition of `sdhci_pltfm_register'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0xd8): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_pltfm_init':
(.text+0x568): multiple definition of `.sdhci_pltfm_init'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x568): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_get_of_property':
(.text+0x34c): multiple definition of `.sdhci_get_of_property'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x34c): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_be32bs_writel':
(.text+0x13c): multiple definition of `.sdhci_be32bs_writel'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x13c): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_pltfm_resume':
(.opd+0x120): multiple definition of `sdhci_pltfm_resume'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x120): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_be32bs_readl':
(.opd+0x0): multiple definition of `sdhci_be32bs_readl'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_be32bs_readw':
(.text+0x64): multiple definition of `.sdhci_be32bs_readw'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x64): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_pltfm_free':
(.text+0x8d0): multiple definition of `.sdhci_pltfm_free'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x8d0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_pltfm_free':
(.opd+0xc0): multiple definition of `sdhci_pltfm_free'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0xc0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_be32bs_readw':
(.opd+0x18): multiple definition of `sdhci_be32bs_readw'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x18): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_pltfm_unregister':
(.text+0xa94): multiple definition of `.sdhci_pltfm_unregister'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0xa94): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_be32bs_readb':
(.text+0xd0): multiple definition of `.sdhci_be32bs_readb'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0xd0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_be32bs_writew':
(.text+0x1a0): multiple definition of `.sdhci_be32bs_writew'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x1a0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_be32bs_writel':
(.opd+0x48): multiple definition of `sdhci_be32bs_writel'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x48): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_pltfm_unregister':
(.opd+0xf0): multiple definition of `sdhci_pltfm_unregister'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0xf0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_be32bs_writew':
(.opd+0x60): multiple definition of `sdhci_be32bs_writew'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x60): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_pltfm_resume':
(.text+0xc70): multiple definition of `.sdhci_pltfm_resume'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0xc70): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_be32bs_writeb':
(.text+0x2ac): multiple definition of `.sdhci_be32bs_writeb'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x2ac): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_pltfm_suspend':
(.text+0xc04): multiple definition of `.sdhci_pltfm_suspend'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0xc04): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_pltfm_register':
(.text+0x9c0): multiple definition of `.sdhci_pltfm_register'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x9c0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `.sdhci_be32bs_readl':
(.text+0x0): multiple definition of `.sdhci_be32bs_readl'
drivers/mmc/host/sdhci-of-esdhc.o:(.text+0x0): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_be32bs_writeb':
(.opd+0x78): multiple definition of `sdhci_be32bs_writeb'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x78): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_pltfm_suspend':
(.opd+0x108): multiple definition of `sdhci_pltfm_suspend'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x108): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_get_of_property':
(.opd+0x90): multiple definition of `sdhci_get_of_property'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x90): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_pltfm_init':
(.opd+0xa8): multiple definition of `sdhci_pltfm_init'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0xa8): first defined here
drivers/mmc/host/sdhci-of-hlwd.o: In function `sdhci_be32bs_readb':
(.opd+0x30): multiple definition of `sdhci_be32bs_readb'
drivers/mmc/host/sdhci-of-esdhc.o:(.opd+0x30): first defined here

Presumably caused by commit e2d0d7dc5542 ("mmc: sdhci: make sdhci-of
device drivers self registered").

I have reverted the merge of the mmc tree for today.

P.S. Chris, some commits in your tree have no SoB from you despite the
fact that you committed them.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jun_2011_13_04_31_+1000_fkVSDzs7jWb2MRU_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5aw/AAoJEDMEi1NhKgbsJyMH/3e/ova0aZ/6nMvO/kutmlLN
dawcTWDhunxUmzU90Eg4hmLeKsQeyQMOplYBNaD6gEIYU28umbH+JSrfpv2dJJJM
dsZXzYsN0R7BSpvfi4OQeSKGtrp38kQH7es3y3UcL8te312RMe6Of5hKjgE9RBpA
9e5fw0g8KcBjuYqgatkhoTu77C//A9roNiOMSPo/Xg0AYAGb/uhA3kAYQEMA9tk2
4zmeVIjxv/YVwCJKPDhRDmjuqYBb0WZv4RqHOSDTQNwk5PGveUvy+i7JEualjXAC
ltFmKQ4x8xpFs9rhhyKmAjWU87H0ZDN/9QCXwF8rH9f5aV/Uvd9dOPGRnbGGyh0=
=Ht79
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jun_2011_13_04_31_+1000_fkVSDzs7jWb2MRU_--

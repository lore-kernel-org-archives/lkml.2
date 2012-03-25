Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2CYRJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:09:32 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:60705 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756621Ab2CYRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:09:31 -0400
Date: Sun, 25 Mar 2012 19:05:13 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 3.4
Message-ID: <20120325170512.GA31282@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

a few PCMCIA updates for 3.4 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik

Axel Lin (3):
      pcmcia: convert drivers/pcmcia/* to use module_platform_driver()
      pcmcia: Convert to DEFINE_PCI_DEVICE_TABLE
      ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe

Joachim Eastwood (1):
      pcmcia at91_cf: fix raw gpio number usage

Yong Zhang (1):
      pcmcia: irq: Remove IRQF_DISABLED

 drivers/pcmcia/at91_cf.c        |   52 +++++++++++++++++++-------------------
 drivers/pcmcia/bcm63xx_pcmcia.c |    2 +-
 drivers/pcmcia/bfin_cf_pcmcia.c |   13 +---------
 drivers/pcmcia/db1xxx_ss.c      |   17 ++----------
 drivers/pcmcia/electra_cf.c     |   12 +--------
 drivers/pcmcia/i82092.c         |   11 ++------
 drivers/pcmcia/m8xx_pcmcia.c    |   13 +---------
 drivers/pcmcia/pd6729.c         |    9 +-----
 drivers/pcmcia/pxa2xx_base.c    |   12 ++------
 drivers/pcmcia/pxa2xx_viper.c   |   13 +---------
 drivers/pcmcia/soc_common.c     |    2 +-
 drivers/pcmcia/vrc4173_cardu.c  |    7 +---
 drivers/pcmcia/xxs1500_ss.c     |   13 +---------
 drivers/pcmcia/yenta_socket.c   |    2 +-
 14 files changed, 47 insertions(+), 131 deletions(-)

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPb1BIAAoJEJqXYIlMjaMNgIcP/0l25Nkx0jbMhJ05aUar6r0H
OgJyyolL3VgmGSqQ/FnKRxW5vWCrN32ukP2Mn0ivP921Upd0Vg7d7+GMJAd3FVya
6ijEpRMHdccPLLbUHAjp54p5wpANrdOSL0f1mdOGJVdlaKRpWDgISXeF9mknJZ6f
5X9aUK10GmrB/BuhEMCaM3wqt1+afqxcuMJMf5L/w7do+v/ZFfJBnvfZNRgfFvu0
+MyZcpMeGw2vp+1c9ubwu+XBYTc1jQ9ynOH+g2NkoUgKB99aP+WBIz+7kRX+UJ/B
/brnsPsinoe9H8/nwvld5iuJyaDgzqZ8K7f+2rbPtkJ5hTi1HmCIFRgQ1bmprhto
ku2wlKtFA1c9qDcPRNLU4hXQkkI5961Zh9YFmWoD5D/pwR73o91a5YhdDAa4Gsjl
HlGoVOOeGU7rvOPYqDEOoMu1ECa9RhQh1f3yEnerXgmt3GRSxaJIJnbZQrq0GXiO
qNh0fSFzXkKhgaApKc2+iflOZIBEfpzbSvcykje1MNunXh8strHVJrWlTMxuKpW8
/jpHCQczz6GIW+qABIUtRxg1AnELv3Ochj4znYCbugkCLhWSlzKSZVlK88R4SoD8
iUnAiZVLY8v2F9jqTF1oVa2xYAoiSAiFpRE57GM47Un7GAgRfYnjYnz2OPUiSfIo
nXOPljJlpwtslHuX6+pR
=9P/I
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--

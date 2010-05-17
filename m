Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0EQCgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:36:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35626 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0EQCgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:36:19 -0400
Date: Mon, 17 May 2010 12:36:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Kurz <linux@blala.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: build warning after merge of the mtd tree
Message-Id: <20100517123603.f3bf24a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_May_2010_12_36_03_+1000_cKz_IH9ucnWv2TGJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_May_2010_12_36_03_+1000_cKz_IH9ucnWv2TGJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

After merging the mtd tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/mtd/maps/pcmciamtd.c: In function 'pcmcia_copy_from_remap':
drivers/mtd/maps/pcmciamtd.c:164: warning: format '%u' expects type 'unsign=
ed int', but argument 5 has type 'ssize_t'
drivers/mtd/maps/pcmciamtd.c: In function 'pcmcia_copy_to_remap':
drivers/mtd/maps/pcmciamtd.c:213: warning: format '%u' expects type 'unsign=
ed int', but argument 5 has type 'ssize_t'
drivers/mtd/maps/pcmciamtd.c: In function 'pcmcia_copy_from':
drivers/mtd/maps/pcmciamtd.c:275: warning: format '%u' expects type 'unsign=
ed int', but argument 5 has type 'ssize_t'
drivers/mtd/maps/pcmciamtd.c: In function 'pcmcia_copy_to':
drivers/mtd/maps/pcmciamtd.c:313: warning: format '%u' expects type 'unsign=
ed int', but argument 5 has type 'ssize_t'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_May_2010_12_36_03_+1000_cKz_IH9ucnWv2TGJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvwq5MACgkQjjKRsyhoI8wMrACgpUukeW6AfEnr5vampIXC3rek
czgAoIdJK3j+4nDCQ/KWR2OeHMT8y8fG
=vgwP
-----END PGP SIGNATURE-----

--Signature=_Mon__17_May_2010_12_36_03_+1000_cKz_IH9ucnWv2TGJ--

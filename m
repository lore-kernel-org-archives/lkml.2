Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab0EZBXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:23:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58324 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142Ab0EZBXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:23:38 -0400
Date: Wed, 26 May 2010 11:23:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@opensource.se>
Subject: linux-next: manual merge of the genesis tree with the sh tree
Message-Id: <20100526112331.cbd37c4b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_11_23_31_+1000_olKh3Wswr4x4rBs."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_11_23_31_+1000_olKh3Wswr4x4rBs.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the genesis tree got a conflict in
include/linux/serial_sci.h between commit
14baf9d7f275f0bbf42c1216ff1eef1109ca42ba ("serial: sh-sci: fix up serial
DMA build") from the sh tree and commit
927a7c9c1793def3a55d60c926d3945528e6bf1b ("dmaengine: shdma: Enable on
SH-Mobile ARM") from the genesis tree.

I used the version from the sh tree (i.e. no "#ifdef
CONFIG_SERIAL_SH_SCI_DMA" around the include of linux/sh_dma.h).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_11_23_31_+1000_olKh3Wswr4x4rBs.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8eBMACgkQjjKRsyhoI8x3uwCfWqfY94/jJHXZZXFMsGOl+As+
pvEAoIk9Cu1imowPHGFVqpMGjxJ/MaEZ
=rUcG
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_11_23_31_+1000_olKh3Wswr4x4rBs.--

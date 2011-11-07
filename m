Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1KGAEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:04:16 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59062 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KGAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:04:15 -0500
Date: Mon, 7 Nov 2011 11:04:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <david.daney@cavium.com>
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-Id: <20111107110403.9fb12ceed80d07d9765031bb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_11_04_03_+1100_fzeLT_Ki1qN8hI3M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_11_04_03_+1100_fzeLT_Ki1qN8hI3M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
arch/mips/kernel/perf_event.c between commit e5dcb58aa510 ("MIPS: perf:
Reorganize contents of perf support files") from Linus' tree and commit
6e8722f887b2 ("MIPS: irq: Remove IRQF_DISABLED") from the mips tree.

The former moved the code that the latter modified and it appeasr to have
been fixed up in its new position.  So I just used the version of this
file that is in Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_11_04_03_+1100_fzeLT_Ki1qN8hI3M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOtyBzAAoJEECxmPOUX5FEqP8QAI3ladGVyEjxTgUElG37T2Z7
yWFY/+pzwNd+eUB1gd+UGZS0Vb4jGLnW3MTPKUzYOvwP5FCFTO59VJ3mWLXUFHBP
pamahxl85/PriExWT4Dks/2yYM3dwcM5SchH5dGbACABf8o3W82zZY2l3lxEK9nd
1GFabiP4Vt8bkL9boe6/NKwCCVPW5AIG9bF2gtAAjna/pvECuUwii5FQHDgEtx63
NnsqlWGoJrihe6+KoF5MObsTckXfltb10HbOVdFrKpAp96aglRM0Tm5854/75qWC
hCdeW/iFQRSKoH+nFk75NkGszcNJ0lq+rrmVxjQIMFvE8IhISPb09XB9g+hOYkno
QFK/A7SA53dHoJaofEsRv5tjR1HoX5Fd4r+jZZG/NC1JaRtB84oyVXKCll16dnZ5
+wlimTC6n5hTKV7+Xsm0ECchYxgY9Pkf/DNF9mLzGZuwhrST0xQ2xvVD7+2OrD0f
HlX/mNGkTw1cMa7HSjqP202j6PKHifXpYaReFVvwrYV+o/zqq03SUxuFfxPZaTly
5fDEyYQ1P8nf6LxIcVv1BcUROdV4WLN+lu+ej6Dn3ZTWdrn9EtqYBUAzTsx98VcY
5/F26sLwH8RFrU4blkxSY0CD5xRRht9cbhYdWI57xWCMHwr9Li8CCEebyMbgGhpl
c1l43GkTG8BpfVoFFPzg
=y0an
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_11_04_03_+1100_fzeLT_Ki1qN8hI3M--

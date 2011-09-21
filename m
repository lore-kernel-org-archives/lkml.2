Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1IUDCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 23:02:30 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48589 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1IUDC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 23:02:29 -0400
Date: Wed, 21 Sep 2011 13:02:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the omap_dss2 tree with the arm tree
Message-Id: <20110921130222.58e566a354feef69f3064d04@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_Sep_2011_13_02_22_+1000_7N5cCMFZUSvQzcqW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Sep_2011_13_02_22_+1000_7N5cCMFZUSvQzcqW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/omap/lcd_apollon.c drivers/video/omap/lcd_ldp.c
drivers/video/omap/lcd_overo.c between commit 1bc857f700fb ("ARM: gpio:
omap: convert drivers to use asm/gpio.h rather than mach/gpio.h") from
the arm tree and commits db3136b14a2b ("OMAPFB: Remove unused lcd
drivers") and 0cde58449424 ("OMAPDSS: Port the Apollon display driver to
DSS2") from the omap_dss2 tree.

The latter two commist removed these files, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Sep_2011_13_02_22_+1000_7N5cCMFZUSvQzcqW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeVO+AAoJEDMEi1NhKgbsIgIH/jb/ZSYtJgXdQgFC0hh9ozzo
iuL/AWSgILcmjOZDMeMK/zH6YWgtCpJPaBf6+xmZtR8hCIumP38kz7+x7Eu1NAwL
9/O7z8Fdrm/f/iWJDBsnWPrPFsS2DV5KIIOx8YewpCs6ReTzag305ceMx/vkENoJ
JPlbSB8syCcbOwzdJmlIgGcVLBmhbVAoFSAThERLgyEnwtaFNpk1ejCmCOieqles
vZr0C9AAakPSlzbXAC+9mhkE/AIhpKyERyaWq8vb7iurGOT23P6GTWSIIvISGsHs
7J51gPeLBUFe6CzH1Lul2ctNYl+7BwcbCURi2OadxTlkgrFjf/KKCdeWlwW4BU8=
=A82p
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Sep_2011_13_02_22_+1000_7N5cCMFZUSvQzcqW--

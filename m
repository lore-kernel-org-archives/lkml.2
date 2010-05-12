Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0ELBVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:21:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56330 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0ELBVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:21:23 -0400
Date: Wed, 12 May 2010 11:21:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@canonical.com>
Subject: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20100512112117.8492aa72.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_May_2010_11_21_17_+1000_dhWjP6=zhUphHH94"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_May_2010_11_21_17_+1000_dhWjP6=zhUphHH94
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
drivers/acpi/sleep.c between commit
7d6fb7bd1919517937ec390f6ca2d7bcf4f89fb6 ("ACPI: sleep: eliminate
duplicate entries in acpisleep_dmi_table[]") from Linus' tree and commit
7e962fbadef538365228962b9dd869f95d745dd5 ("ACPI: delete DMI blacklist for
sci_en_on_resume") from the acpi tree.

I fixed it up and can carry the fix for a while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_May_2010_11_21_17_+1000_dhWjP6=zhUphHH94
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvqAo0ACgkQjjKRsyhoI8zEEQCgm9Cuw9smGtcq/xmAUQ00nwvt
aRUAnAsB7misYBS8WMPtxZ7BMJ9sbXpT
=6D8b
-----END PGP SIGNATURE-----

--Signature=_Wed__12_May_2010_11_21_17_+1000_dhWjP6=zhUphHH94--

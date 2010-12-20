Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0LTCIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:08:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36203 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab0LTCIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:08:21 -0500
Date: Mon, 20 Dec 2010 13:08:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20101220130812.1710c405.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Dec_2010_13_08_12_+1100_sev16BIE0Jg1xjH+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Dec_2010_13_08_12_+1100_sev16BIE0Jg1xjH+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next merge of the pci tree got a conflicts in
arch/x86/kernel/resource.c arch/x86/pci/i386.c kernel/resource.c between
various commits from Linus' tree and similar commits from the pci tree.

I just used the versions from Linus' tree and assume that the pci tree
needs to be resynced.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Dec_2010_13_08_12_+1100_sev16BIE0Jg1xjH+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNDrqMAAoJEDMEi1NhKgbsQ54H/01V4Gfl+NO1nbThVEhGAS8x
x+RlMhkkKapXuTku4WMDWeS/WfjNiCbOPofi4mw2kbEmBMt74DH0DQR9GRzagbwy
Y+EQiDN2XU833d52FfUC8u691kzeJF+cyZ5OLymP39MEzeFqEvSHR+Rog29dyfW0
TyiEDB/Nn5//9dUisvt6vcgsukTL54Jp8TWj48zKFvwjPAur4s/lH56kDLLckGMe
1TuP/+Exz57lqDPEJJ1KskuexaDKz6V8X61mIgvaaY1TOmxNqP2a0BtX78HWTjFa
DtNswevdSteglDhtyzZKnNCw1DO74+HNWCvq5XZ54sij32l/DUdwgPO9/Kn3nNo=
=UaYs
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Dec_2010_13_08_12_+1100_sev16BIE0Jg1xjH+--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0GMAzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 20:55:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0GMAzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 20:55:01 -0400
Date: Tue, 13 Jul 2010 10:54:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the s5p tree with Linus' tree
Message-Id: <20100713105455.e49afeb9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Jul_2010_10_54_55_+1000_lf8yi6Qod6KDRr+j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Jul_2010_10_54_55_+1000_lf8yi6Qod6KDRr+j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/configs/s5pc110_defconfig between commit
07a8c03f3e06129e847acd068b8b89c13357ee64 ("ARM: reduce defconfigs") from
Linus' tree and commit 2976beb1dd86974ae98a992ca23a626f8be7e7dd ("ARM:
s5pv210_defconfig: Update for removing s5pc110_defconfig") from the s5p
tree.

The latter just removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Jul_2010_10_54_55_+1000_lf8yi6Qod6KDRr+j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMO7lfAAoJEDMEi1NhKgbsc4EIAJEZEv6h6ZIWMcFtUbj50giz
A7J/HjTrfSqqzjCV2a5uQJM9nVgGF5KIqrGDT+zPlZyMAlafAfW8C6Ee5JHohOCs
vwE/GXj5OU1n4G0r90/aaGZNIQSbN125klLrIMGASN86bLJshjnWPNp9hYpgMByq
qHXPL3hsFXvAKI23p8BXs35Q1/ZDj6Z0TcUc3fuFr+AC47gDyKQ4G9/4PcPJtoeA
cTmuoP/qdYkoEqzJ/x3kENLaBMj/HoFp9io/3wd9i5f3DLx/N4jQhYUlqedh4SYQ
D97b3cotMTaUM1bu3v4Zhw1PDMV4Pv3je80nNXudgbYy1il5GcQ2rSG52AQAc3Q=
=cbaq
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Jul_2010_10_54_55_+1000_lf8yi6Qod6KDRr+j--

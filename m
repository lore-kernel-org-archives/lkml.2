Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2EKFMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:12:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53827 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2EKFMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:12:46 -0400
Date: Fri, 11 May 2012 15:12:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: linux-next: manual merge of the staging tree with the usb tree
Message-Id: <20120511151236.c554c07acc0f5809eaeb85b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_May_2012_15_12_36_+1000_TmHvJQvqdI+E9sMp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_May_2012_15_12_36_+1000_TmHvJQvqdI+E9sMp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/quatech_usb2/quatech_usb2.c between commit 38902cf9f6be
("USB: remove staging quatech_usb2 driver") from the usb tree and a
couple of commits from the staging tree.

The former removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_May_2012_15_12_36_+1000_TmHvJQvqdI+E9sMp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPrJ/EAAoJEECxmPOUX5FEeDAP/1i/cBGDbLSNrLutB7FtYRBR
t2R+kcoGRBSkWu1Su7iGg5kQVTO1pe1m2oJSzL1ikmykkCFLlj7ycucTkasGCO0+
AnjXMFZ4njKKsNOEm8b6yUbvl29nq1wAFTIMdjgBiKe31Ymink2IPoBHCfIekKDP
rpZ92GMhJzxAuwHswu8CGCyBwl+XjkXg40/VrB/W1XdBd2TFnliihdl1IYHm/II6
/TGod7q7IQDTSATbXwqM/x48LzwVkQCr8jAsB417wIn3kAvZumpsw5huz1SxZrcZ
PLR6XDJ+YqsSOg6gCFEQNiQMhm0gtdw4AbtOwqVVawEfpjNc75QC1Y7InscUiZLb
9OQxce/mXMTo4LnsJ73NJc9hlyJ3zfc3Dm3sESH7cxQSv1mwwoAbFsbgQjskRsdW
rTE9DNCterDjScWufuTqu9aKyHC70EEKRCBlfqEP4l9SvN/oGuQ67ID/6DL/Rp91
LD97OGGCLW2Hr39ZfCCC8bijQHCjtWswGonNqUyilHMXmDkWhkDFxlEjSZcgomjz
Ncu/Uom2G4wWnzl2X47H8ZSJPOPgvdq+Q/97IV6y3U4UTosnMCeULDiW4TktoEbk
hhd9d0tH/ZHkDFAVjOGATU2wpV1/xMUwn5QWaqc/rs2zlywty0JsCg61etd+Q7eS
kUu12ApFkUmXUL5LFK5q
=BDM1
-----END PGP SIGNATURE-----

--Signature=_Fri__11_May_2012_15_12_36_+1000_TmHvJQvqdI+E9sMp--

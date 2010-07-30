Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0G3EyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:54:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35550 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab0G3EyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:54:23 -0400
Date: Fri, 30 Jul 2010 14:54:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the devicetree tree
Message-Id: <20100730145415.8ed17b7e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Jul_2010_14_54_15_+1000_xENWtqD8Gt9xZUPw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Jul_2010_14_54_15_+1000_xENWtqD8Gt9xZUPw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the devicetree tree, today's linux-next build (powerpc64
allnoconfig) produced this warning:

drivers/of/irq.c: In function 'of_irq_map_raw':
drivers/of/irq.c:102: warning: cast from pointer to integer of different si=
ze

Introduced by commit 7d12c3ee9e1843b1d19d9c308988bb163fb9aa0b ("of/irq:
Fix endian issues in parsing interrupt specifiers").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Jul_2010_14_54_15_+1000_xENWtqD8Gt9xZUPw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMUlr3AAoJEDMEi1NhKgbs/ZgIAIf0hiVYA+l3pwOmtCBb/Qk4
hiA+ovDKB9FjfEWzWBpKJMklJMS4NqA2xU5bFa9YZDgeRie4E/HQz4xOx3RWzOee
tKeWCfD43Q/HlyM6CimlOzYt2DmVdfSXdGyU1uYr7wx1CTvoz8gU2SMoSq+0wC+c
aite7JHYFX/MFiQKhZyEYmVCVkaMTxBRvP3aAI1jqAmbwhL7TFuvKLm/sFbPaysC
y1fQ/oHzEQoNbGAS6CebmCRPI25COH5nacfFjno607vpPE48eLoEihQ69tqqJGBa
hR5E9Y0Qv2FPbn/yJ9qfTveJ2PHIsTBDIFkcpXLutKw6oybzYTlo2lTzE9AXD9s=
=4X3I
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Jul_2010_14_54_15_+1000_xENWtqD8Gt9xZUPw--

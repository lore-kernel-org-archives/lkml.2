Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1BRCTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:19:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37560 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1BRCTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:19:45 -0500
Date: Fri, 18 Feb 2011 13:19:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>, Mayuresh Janorkar <mayur@ti.com>,
        Senthilvadivu Guruswamy <svadivu@ti.com>,
        Sumit Semwal <sumit.semwal@ti.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the  tree
Message-Id: <20110218131938.d7b27a31.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Feb_2011_13_19_38_+1100_qEFMQ/_IEO8Fl5RJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Feb_2011_13_19_38_+1100_qEFMQ/_IEO8Fl5RJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/omap_hwmod_44xx_data.c between commit
d63bd74fbb5fb2161d9cb90cd7a93a2c5db47c63 ("OMAP4: hwmod data: Add DSS,
DISPC, DSI1&2, RFBI, HDMI and VENC") from the omap tree and commit
cb93d0b00acd5e5ada8ddd4c8719d4aa390515d2 ("OMAP4: hwmod data: add DSS
DISPC DSI1,2 RFBI HDMI VENC") from the omap_dss2 tree.

So these two commits with essentially the same commit messages and author
dates are quite different :-(.  I used the version from the omap tree.
Please sort this out.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Feb_2011_13_19_38_+1100_qEFMQ/_IEO8Fl5RJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNXdc6AAoJEDMEi1NhKgbsi1cH/jYN5STZSTgIF/RxKqSpRa0O
iKh3RkYHJkFUCIMKrBn4BcuVNCpFnNjNuPcxOAjQDpdhHtrVfHD9Bd3OfQq0GPZ4
UYegDNgQ0OrtbaCAY71Dg3IyVb8EHO4a4ZD3C5klCQ6EDDDbULuGNX2IF78y/py6
1Pk1gqyvzeO6RiDveBVaovj661pdOaDSHMMFafdO58ZZAlMZuWhrmdwgRuVUzFBj
tIZt/7kz2er8GgogF+flEC3NVCIaopNL+LymqRmeMuap+68sy+GobjOi/bvjBr1/
swGI9ryCc9uEejgrU40YJaVDbEMpG6YQaPTFFyNiKrUPPFuoOO62X/Yjk1p0ydk=
=Y3Vl
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Feb_2011_13_19_38_+1100_qEFMQ/_IEO8Fl5RJ--

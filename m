Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0JFDOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:14:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55983 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab0JFDO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:14:28 -0400
Date: Wed, 6 Oct 2010 14:14:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the usb tree with the trivial tree
Message-Id: <20101006141414.abf7431f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_14_14_14_+1100_ED+D5Umds_uXO/P0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Oct_2010_14_14_14_+1100_ED+D5Umds_uXO/P0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/musb/musb_gadget.c between commit
7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
unnecessary return's from void functions") from the trivial tree and
commit 82cccbf2458e50dabf8b9946b3f0ef0e8d31711f ("usb: musb: gadget: kill
unreachable code in musb_g_rx()") from the usb tree.

The latter also fixes the problem fixed in the former, so I just used the
latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Oct_2010_14_14_14_+1100_ED+D5Umds_uXO/P0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMq+mGAAoJEDMEi1NhKgbsETIH/iKAGcIQOOPuSfz9AIOG6Szz
QvIGSL/reKGhx3VXR4RyOyeuu5bLGncS3+6DC4Q2kdsgdzLJXEs3/bDSb0lJRbJg
nnjQSAyE0Kw4IZxRgqafeTC1berlPbM4r1Q3Sef5sNi1iB4/w7Q86jKmWO2aHMwn
Npsjlzgqgt3f3qDRanb1La892nTANMbHgJMpfFaa6zx8M6W5Vcn+01PN8UEVVFPH
pmD2NHuFn9bEste7GEUKc2jtnE9/9RNn7YucCHvKmPVD/1sPdPL7AURKrBWvSuVa
uVOEHTcXR/Q4Hqg4Ae+QK39PanYkujfBBpX3Nf5UxEmk/YUEhonVYEm3R4ht8fM=
=tkOz
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_14_14_14_+1100_ED+D5Umds_uXO/P0--

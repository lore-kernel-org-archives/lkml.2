Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0KJCYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:24:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab0KJCYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:24:19 -0500
Date: Wed, 10 Nov 2010 13:24:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Dan Carpenter <error27@gmail.com>
Subject: linux-next: manual merge of the staging tree with the  tree
Message-Id: <20101110132408.67f73665.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_13_24_08_+1100_0A7JdW_ynxr+nUwK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Nov_2010_13_24_08_+1100_0A7JdW_ynxr+nUwK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/intel_sst/intel_sst_app_interface.c between commits from
the staging.current tree and commit
d0f40c5041f9c48afbd8f7fbf8a5faa9e5dbd39a ("Staging: intel_sst: Use
pr_fmt, fix misspellings") from the staging tree.

I have just ignored the changes from the staging tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Nov_2010_13_24_08_+1100_0A7JdW_ynxr+nUwK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2gJIAAoJEDMEi1NhKgbsyw0H/2L/ZunLbDiHdjDXUipk/VR9
nO2y4XnrKqRskY2qGdNMeps57F1au6ghTMdqrRMuSM55cu8+Bjppx6kBshX8sMKb
idMLXoaWEaq9l8iXRGuT3Z4p46T+SyQWM7t0vDNQJDBU24TXSvIRYua/RVdYrVth
lQ8UhwOnU02NSC4k0qy90FansjQ+XEq9l1wtoIg16OO82tvdoFzWcoTXucNfjOom
hgp4jifyiQb8uZkvoqyUmM1f0NhEcv+lrX0NvCQ9hCoBO0o0NOa+qg+EeBD1nHE7
AQD37a4+745SkIPBPTbQh6HAr5MxHonweqle+pEe19zQymbf5yMkJlMvnrUj39o=
=GKuR
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_13_24_08_+1100_0A7JdW_ynxr+nUwK--

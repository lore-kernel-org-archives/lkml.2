Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1DHFwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:52:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49411 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1DHFv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:51:59 -0400
Date: Fri, 8 Apr 2011 15:51:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110408155153.de643a79.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_15_51_53_+1000_pKKVxxj.L6AlI_P8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_15_51_53_+1000_pKKVxxj.L6AlI_P8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c between commit
25985edcedea ("Fix common misspellings") from Linus' tree and commit
b3b97f5c23c0 ("staging/brcm80211: Fix common spelling mistakes") from the
staging tree.

The latter is a superset fo the former (for the conflicting line).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_15_51_53_+1000_pKKVxxj.L6AlI_P8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnqJ5AAoJEDMEi1NhKgbsIswH/2QNf3MvczXSbR9D+5Q+feJP
RkduM49mw7QQYt/KEeUz6im8ZFYGvwbsiHFj0jL87/i9eDTlavtqdyp8WFtKol/4
pKz5R1g23gplyfzgM1O71Vj9+VFn5PqjQOccLWASS+rUGO9gHdfo3HSrFJRBQlIr
ZXcGAJiw9bKYwtiH+wq3G8yHlRak1Ji5+HLiqvNTub2bZCoffl33mkFJQUfW5N2Z
ZpEADLL/AnxTHldwszu8nnZnIjVvBrwAkqHSfz09W19FIQ8F0rtXsmfcUMmZsJqs
GupahAGi37o4G+RHlpKHLKwBzaAxP0EwtDsiX31or7XOISnJUfHtchY/1X/KRxo=
=MB/u
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_15_51_53_+1000_pKKVxxj.L6AlI_P8--

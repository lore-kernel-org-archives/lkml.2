Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1DHGCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:02:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50114 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1DHGCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:02:12 -0400
Date: Fri, 8 Apr 2011 16:02:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110408160206.f9f0d8af.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_16_02_06_+1000_fkx/8n18apDDHx3+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_16_02_06_+1000_fkx/8n18apDDHx3+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/gma500/psb_ttm_fence_user.h between commit 25985edcedea
("Fix common misspellings") from Linus' tree and commit aea74b656799
("staging: gma500: kill off TTM") from the staging tree.

The latter removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_16_02_06_+1000_fkx/8n18apDDHx3+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnqTeAAoJEDMEi1NhKgbsKikH/j9ll2uWbENNfqXROMCb/Xps
5nVQursgc4+aDNin1+5TsG8FLBva2nswXSRF36cHHl8fGbXqj8ZHIKVA3PKkduCd
giv6cF99kz7HA/rvmcQWHNhjpP2KYB6L6ehK4mZmviX8pA248sbJinxNAly4+nu5
Oa5q8tgUVuInVF03YemfqrkUVH91Uq43SybOk6hJkXH4DiYME186UzZU67MO7A6i
hwNz9cXNiMgxcX62/xsIOmh+J4HLXVJXRJmCP4Uh2JpE8ygdlRNeMbbbqak9imBq
9L9BXxkDC3m1CbGTuvI+idcna5bcJqu7ZbrrD/RkE4ktc06wacxvWwy/qktplu0=
=4Ui1
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_16_02_06_+1000_fkx/8n18apDDHx3+--

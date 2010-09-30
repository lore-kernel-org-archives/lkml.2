Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab0I3Aug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:50:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37185 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0I3Auf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:50:35 -0400
Date: Thu, 30 Sep 2010 10:50:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: build warning after merge of the kbuild tree
Message-Id: <20100930105025.c46e2fe0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Sep_2010_10_50_25_+1000_ZIFz1/Ihpu/qgQnF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Sep_2010_10_50_25_+1000_ZIFz1/Ihpu/qgQnF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

scripts/kconfig/kxgettext.c: In function 'menu_build_message_list':
scripts/kconfig/kxgettext.c:175: warning: passing argument 3 of 'message__a=
dd' discards qualifiers from pointer target type
scripts/kconfig/kxgettext.c:148: note: expected 'char *' but argument is of=
 type 'const char * const'
scripts/kconfig/kxgettext.c:180: warning: passing argument 3 of 'message__a=
dd' discards qualifiers from pointer target type
scripts/kconfig/kxgettext.c:148: note: expected 'char *' but argument is of=
 type 'const char * const'

Probably caused by commit 2e7a091833f014cac8a6b92573ca6cd2edd2753c
("kconfig: constify file name").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Sep_2010_10_50_25_+1000_ZIFz1/Ihpu/qgQnF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMo97RAAoJEDMEi1NhKgbslj8H/0P3V/ne7ILuyCyCpDy3UTmh
PkM0wb87JuV5eioyV3Hpy2bCkXsmnD7b56wXWyzNAGfgs4c2JgJsjL+tqBeWjr20
UJyllal28zBBiXlZD68hUAJBI+f8YUdIyEHLebCiTxb68RN1HXQ0o3BAk4Z1TS69
DGW4G0qWirEuLyjoLthSk8NxKu3A4gsA2XugzdgWP8WoG9wK8iFe9+eCu8vaTQBb
kIO4xPz6TGwRSXXh9MTEr2AECrCjS2Jnh/fdUOzrMTtFC+w1+SCabBSjnaZrTumM
TIJDfU9/QAW6iGiaSUdf0iHP1tciprc/xYL6UHMorE31KHJWLhnzFYG04FJ3ixs=
=0lBA
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Sep_2010_10_50_25_+1000_ZIFz1/Ihpu/qgQnF--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1DLCFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:05:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60852 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1DLCFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:05:22 -0400
Date: Tue, 12 Apr 2011 12:05:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hsiang <cdefgab1288@gmail.com>
Subject: linux-next: build warnings after merge of the sound-asoc tree
Message-Id: <20110412120513.c07dcbab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Apr_2011_12_05_13_+1000_FQE=z2D9QWAZqtzG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Apr_2011_12_05_13_+1000_FQE=z2D9QWAZqtzG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

sound/soc/codecs/max98095.c:607: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:610: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:616: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:624: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:633: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:636: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:642: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:645: warning: initialization discards qualifier=
s from pointer target type
sound/soc/codecs/max98095.c:648: warning: initialization discards qualifier=
s from pointer target type

Introduced by commit 82a5a936f6de ("ASoC: Add max98095 CODEC driver").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Apr_2011_12_05_13_+1000_FQE=z2D9QWAZqtzG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNo7NZAAoJEDMEi1NhKgbs/soH/RIdrcJUurz/RQJNPbxm1BS3
LTTNUrK+Hs02apxLgavdzH6JdmL2bbC6gsPJ0WR0iLwIB839BHi6EPT24VajjghV
6kdnOIay2wB5+ce85jqb4Jy435eqxhYSounF3QfDtyqKP2PJNEGtgrGc/fWXBGzR
oDT1K3L7HpR/44XMzy+vgWWcP/ZlYGmBIF/SktzKPFcnGFbM8RSh4GloywDh6hML
QnedN2kqxH4cnkTNK4Tdxtj8ULoVh5w+oCo4avMh0CAHoMRssbWqoF1Q4e1JR3U7
JBoiKaba4ZusYkIi2Na7/16Md8XtkuKYqidSyzJTxNfJr5o/fed+40AvnixQ4Gw=
=sRR6
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Apr_2011_12_05_13_+1000_FQE=z2D9QWAZqtzG--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab1D1Bxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:53:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60257 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1D1Bxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:53:36 -0400
Date: Thu, 28 Apr 2011 11:53:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110428115327.6727e04f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Apr_2011_11_53_27_+1000_tHwCZhghe8nU+InU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Apr_2011_11_53_27_+1000_tHwCZhghe8nU+InU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/soc-utils.o: In function `cleanup_module':
(.exit.text+0x0): multiple definition of `cleanup_module'
sound/soc/soc-core.o:(.exit.text+0x0): first defined here
sound/soc/soc-utils.o: In function `init_module':
(.init.text+0x0): multiple definition of `init_module'
sound/soc/soc-core.o:(.init.text+0x0): first defined here

Probably caused by commit 848dd8beef44 ("ASoC: Add more natural support
for no-DMA DAIs")?

I have used the sound-asoc tree from next-20110427 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Apr_2011_11_53_27_+1000_tHwCZhghe8nU+InU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuMiXAAoJEDMEi1NhKgbsxTAIAIO65ozzCLQLtoCkJNrQK+ED
2VP/DgZf0P7ab7kQUdw+rAKknvW50GiGrkTNJig4wliy+m8Ks5n8TQ4evwCXuy+P
V3tnPOFrf6u5bX6laeTSTrcpAND7YZLOxtIHddnN4MEhe1AUaonyBbgkrC2dI1MP
bQM9oznBMzs3QoaNQW77jhsUMFeXWc66g7ThTi8TrCLEawWRpouiRg1gxM7DAW4e
WxFFXASk6jY/GMR4De60q2wDWBo7iASiubWx+G68S5IReIwZUBqfKxLI6FcaBioa
vzBFu0CIZ/m7Pjelx2hjRDobpd5Sr/aDDWCV7fVJlPdv0jTFfpEBZv60+MK3nxs=
=5bQ/
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Apr_2011_11_53_27_+1000_tHwCZhghe8nU+InU--

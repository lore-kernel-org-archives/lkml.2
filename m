Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1GABjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:39:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51531 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab1GABjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:39:51 -0400
Date: Fri, 1 Jul 2011 11:39:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the powerpc tree
Message-Id: <20110701113942.5cfed9a3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jul_2011_11_39_42_+1000_ew7+5yst42mNdnGK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jul_2011_11_39_42_+1000_ew7+5yst42mNdnGK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the powerpc tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/include/asm/setup.h: Assembler messages:
arch/powerpc/include/asm/setup.h:6: Error: Unrecognized opcode: `extern'
make[2]: *** [arch/powerpc/kernel/head_64.o] Error 1

Caused by commit a9c0f41b3a64 ("powerpc: Add printk companion for
ppc_md.progress").  Clearly not build tested for 64 but powerpc :-(

I have used the version of the powerpc tree from next-20110630 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jul_2011_11_39_42_+1000_ew7+5yst42mNdnGK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODSVeAAoJEDMEi1NhKgbsweoIAJ2bnrJWPwtkzJjEzmTLlyZV
Yqqm2DBnGdEtx4Bqq1setmV/D2TNNEwslE0KTHcz48657TSHtjPBaCD3bctRDZau
YCyTMEX6uXOPFTN9KXEh95nm4+PSsVWDhLMQPqYnAEu0Bqtw1hmOc/B10yHwvLUb
ac68mXcnU89gG40GBZiSWZdpxLPvT0w0mDCKRc9POsVd25MNjQpW+qgEqx1i7fsC
SBjc9rDtZXbg7RsBZQW1LG/NW1rBN8VCTp4hU8dXyD++kNmdRjLsc9Bgg+hAMs9h
nL6edqrf83eE4wvl5xMEdhViFyXS4jxwvAks1p4oDb50bKdf1SuzoNJ7Q+3wc1s=
=dii8
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jul_2011_11_39_42_+1000_ew7+5yst42mNdnGK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab0G1EjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:39:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43025 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0G1EjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:39:02 -0400
Date: Wed, 28 Jul 2010 14:38:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>
Subject: linux-next: manual merge of the tip tree with the powerpc tree
Message-Id: <20100728143856.45d20338.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_14_38_56_+1000_mh0ZEnXr9=ALDoEP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_14_38_56_+1000_mh0ZEnXr9=ALDoEP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got some complex a conflicts in
arch/powerpc/kernel/time.c between a couple of commits from the powerpc
tree and a set of commits from the tip tree.

Since John has posted a new revision of the patches that are in the tip
tree that will resolve these conflicts. I just used the tip tree from
next-20100727 for today (and hope this will be better tomorrow).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_14_38_56_+1000_mh0ZEnXr9=ALDoEP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT7RgAAoJEDMEi1NhKgbsaOMH/2lwkDyMJY/v4wgtriBQZ3VI
UYm//7LKwFbw6VuLZWC90PPjCeru78Ct7JR1he1M6yFh53Kc1pMXKzyF1DWGicrY
MFqyGmRpuv9kA2npkZ696oqVzSgm7fkRVy6aKPC5LoADPST4c85HLJHjZDB/5m4u
2C2EJn8M0oq8WgltNaujOStM1S2SwWMWAnXN7RC2mOPMW3BWx6EhOrF+Xk7zA0SI
0yonuLPYsjZp4FYohstrT137tkVdHLepBBkNCdF4vVpe56BXr8rUd/94jtBVNvg7
kx8wVD3j8NUWio9pzopAFGCjpkA64j1FHvRh4GkCZf33JIrZXX+TNH2dA9keihE=
=iB99
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_14_38_56_+1000_mh0ZEnXr9=ALDoEP--

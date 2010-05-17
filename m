Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0EQF61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:58:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52097 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0EQF6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:58:25 -0400
Date: Mon, 17 May 2010 15:58:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Breeds <tony@bakeyournoodle.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20100517155802.5f82a85c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_May_2010_15_58_02_+1000__GCW4Hf6WIGDaCyv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_May_2010_15_58_02_+1000__GCW4Hf6WIGDaCyv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the staging-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/mutex.c: In function '__mutex_lock_common':
kernel/mutex.c:148: warning: unused variable 'timeout'

Introduced by commit 227945799cc10d77c6ef812f3eb8a61a78689454 ("mutex:
Fix optimistic spinning vs. BKL") for a build with
CONFIG_MUTEX_SPIN_ON_OWNER not set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_May_2010_15_58_02_+1000__GCW4Hf6WIGDaCyv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvw2uoACgkQjjKRsyhoI8xedACfbcDygqdoPEZC1kqUQjGYjrQ4
PAMAn3y8FpxAzvdoXmRUCVubmDC/ijFw
=WSTo
-----END PGP SIGNATURE-----

--Signature=_Mon__17_May_2010_15_58_02_+1000__GCW4Hf6WIGDaCyv--

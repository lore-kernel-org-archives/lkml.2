Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0C1Xyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 19:54:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52831 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0C1Xyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 19:54:46 -0400
Date: Mon, 29 Mar 2010 10:54:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build warning after merge of the i2c tree
Message-Id: <20100329105439.1e474095.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Mar_2010_10_54_39_+1100_.kA/a6J1MLt3zJwM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Mar_2010_10_54_39_+1100_.kA/a6J1MLt3zJwM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

After merging the ii2c tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/i2c/i2c-core.c:159: warning: 'i2c_legacy_suspend' defined but not u=
sed
drivers/i2c/i2c-core.c:172: warning: 'i2c_legacy_resume' defined but not us=
ed

Introduced by commit 592b0bd0324728fe0aca823951eba06a9494c2f9 ("i2c: Fix
bus-level power management callbacks").  These routines are only called
if CONFIG_PM_SLEEP is defined.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Mar_2010_10_54_39_+1100_.kA/a6J1MLt3zJwM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuv7D8ACgkQjjKRsyhoI8xXnACbB9GnhV0G9Ef5yOXsmwAIvlII
aJYAmwc4sa3UU2/KOyxvwYk8MUSvB6Gt
=iRhl
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Mar_2010_10_54_39_+1100_.kA/a6J1MLt3zJwM--

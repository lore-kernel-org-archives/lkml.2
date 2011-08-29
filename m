Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1H2FTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:19:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59723 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1H2FTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:19:17 -0400
Date: Mon, 29 Aug 2011 15:19:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: linux-next: manual merge of the scsi-post-merge tree with the akpm
 tree
Message-Id: <20110829151909.d5a9c3897af3830c70ae2d2a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Aug_2011_15_19_09_+1000_ZDnu.UZCaLt1Cnqb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Aug_2011_15_19_09_+1000_ZDnu.UZCaLt1Cnqb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/alpha/kernel/osf_sys.c between commit 2df7a7d1cd07 ("alpha: unbreak
osf_setsysinfo(SSI_NVPAIRS, [SSIN_UACPROC, UAC_SIGBUS])") from the  tree
and commit db52f8af5ea5 ("The bug was accidentally found by the following
program:") from the akpm tree.

The former appears to be a later version of the latter, so I have dropped
the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Aug_2011_15_19_09_+1000_ZDnu.UZCaLt1Cnqb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOWyFNAAoJEDMEi1NhKgbsDjYH/jc16IGHte12bE5flprrLHJY
WakqYl6vA+mv3ixSiUSasOLeubJFjyiUO2nyYs9f6ThB/pUZ2Qwkax6KAise7wKt
IdvFN/f5twI+A8j2xZfRMkDpaxGRLiTQEHkiqT0BBGfshFXr2L7bf28E75WYekay
Ds2kOYPMLVksDoSmdewpt5IcJO5ZRM/dMNYcB7dlGy+lNDOY5CHzpQj28gzv2g8G
43TuV7e08VhQprFramut0mLD9vaXf42wmLXqkP7kFMPTk9GRZrN+V0eBMrllTJyQ
psukJdiSAgVPx85dRZuwO6lvInSSomfxNu5CAu/OwOv59ojuKaFD1P40jUb/DHY=
=ECo+
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Aug_2011_15_19_09_+1000_ZDnu.UZCaLt1Cnqb--

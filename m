Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0L0Xcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:32:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37276 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab0L0Xcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:32:48 -0500
Date: Tue, 28 Dec 2010 10:32:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20101228103234.29e09106.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_10_32_34_+1100_UZm.mAUBLfDnpSgF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_10_32_34_+1100_UZm.mAUBLfDnpSgF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_add_controls':
sound/soc/codecs/tpa6130a2.c:342: warning: unused variable 'dapm'

Introduced by commit 39646871a47fd8808c08de0ce7d7ca8393af2805 ("ASoC:
tpa6130a2: Replace DAPM code with direct interface").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_10_32_34_+1100_UZm.mAUBLfDnpSgF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGSISAAoJEDMEi1NhKgbsM/YH/RUL+9ZY/c4VStBfKrdA0lju
OKKK7Nade7c/7r77ohOLsFsBa5leELoA9upfsTc1XYDIBPBWHAlMbP6prvkBD6ft
857PD1iZvSyjDZV3emnZQZ0Awu16r7uNoeE/uutjfEh0tojrBMUma8/H8zCGrLIn
zku4PSY/WBDlCEyNJXpb4mgAx+Jr+9hVGGVhsJ5YxI5gbjcdb2dHuc3mHrfnvc3i
11wEiVnBkbtctcUf9PF/bXSVgsVeINtLtbx5XAD4PJfrvnNIf1Mke0Xl1SLA+iHu
+NDU8oRG+ziVsKynEjELBlOstYO3eTjtqRId/FaOtfWgkF5CYpRgp3KQf9dfwC0=
=59yk
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_10_32_34_+1100_UZm.mAUBLfDnpSgF--

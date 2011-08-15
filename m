Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab1HOB5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 21:57:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54115 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1HOB5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 21:57:30 -0400
Date: Mon, 15 Aug 2011 11:57:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Bonesio <bones@secretlab.ca>
Subject: linux-next: build warnings in Linus' tree
Message-Id: <20110815115721.56a4a4186e0d39f042755a2c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Aug_2011_11_57_21_+1000_xtzfdrzPv5K.m/bI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Aug_2011_11_57_21_+1000_xtzfdrzPv5K.m/bI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the fixes tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

scripts/dtc/flattree.c: In function 'flat_read_mem_reserve':
scripts/dtc/flattree.c:700:14: warning: variable 'p' set but not used [-Wun=
used-but-set-variable]
scripts/dtc/dtc.c: In function 'main':
scripts/dtc/dtc.c:102:17: warning: variable 'check' set but not used [-Wunu=
sed-but-set-variable]

I am not sure why these have suddenly starting being reported.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Aug_2011_11_57_21_+1000_xtzfdrzPv5K.m/bI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSH0BAAoJEDMEi1NhKgbsG80H/jWy2crSTQhVIlk0tvNpp7yS
lZoks22Jj/3weqziLoZ6dHiw9RCDHpq37EWmDiAIK0AblhGaklAn9HH8Qceu3WlF
bZojFUnjk1Y5D3eZDSsFlBXYeLYOs3RJ/vCBzsMxbdU62NYq2ndAndFGf65FIkpN
GTCiXPTYDkGIaqMixWgXeM2wLl3r7VcsRNbNuZYt6r+k2uI89XeBkCdd94FP8cmh
oqpnVQKKHyd/u8V95g49xVOThNG+/Yg2HtORXNoKsOl9qfwAgFlpqv7rC4xx6HFu
Ou5FFXiSuF5p0c0YXU1Imxm2whDx4UpgKQLN66XHeYnCE6oChjWc5leRKZdVARQ=
=vC1D
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Aug_2011_11_57_21_+1000_xtzfdrzPv5K.m/bI--

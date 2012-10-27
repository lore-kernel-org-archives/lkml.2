Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab2J0VVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:21:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859Ab2J0VVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:21:34 -0400
Date: Sat, 27 Oct 2012 22:21:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant@secretlab.ca>, Marek Vasut <marex@denx.de>
Subject: [GIT PULL] MXS SPI fixes for v3.7
Message-ID: <20121027212125.GC4564@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/spi-mxs

for you to fetch changes up to 44968466cfb969f960dbe422bbc785117f497729:

  spi: mxs: Terminate DMA in case of DMA timeout (2012-10-17 16:11:09 +0900)

----------------------------------------------------------------
spi: Some minor MXS fixes

These fixes are both pretty minor ones and are driver local.

----------------------------------------------------------------
Marek Vasut (2):
      spi: mxs: Assign message status after transfer finished
      spi: mxs: Terminate DMA in case of DMA timeout

 drivers/spi/spi-mxs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFBLAAoJELSic+t+oim9lhkP/1gCoVKv9G8egWei0/Dmo0dV
n/bd3mE4aKNn3qw75eywOuGwFiH75/OKC3ca3RnSFjMdaqWklYwFJRbRDy9mEApN
UoTgaODwrMOG68wwaGvvj0fdqY36A32ynQ1gvPn5VbfQLewkOuU5ZhefiXlm4Ny4
4RfyKGbjImU32ceAKSaJ89unGCG/0B25tHbpgxzb8ujHvl5GCua1FrFdULiVmOAO
EPFw5h9opINZ52fUbC/7VgeWkU7Q9xmxC2DPQjZpVbjWtYcKImpsfSCIcC0sN+bk
mMvrnuxKx5Nj7SedkaP2IK6VIFRiNvMMduB8kxoKUlo57EkJ6oue3H0loYK/BNYN
AI8Y02GL4EdxBttPGCBOejWFl4TGD3OQ6MPk9y5NKUJ+mdaA91VIK3v1zNxEBKqb
WhfID5mO7E+IvCTpJ7Ihsz0X2OU5WVXOqcZnUngYB/hh12Xf3Hkk03f6/XtKsmrN
q8y7Y4jW43zL1ADehhtXlRTyRSnuZxyHIJKdn35ogmTHNiX6LDXHJI2/Qj3NFlHL
GdNExfPvuUdJCNJPFa39hgLxJnRyXZNiCVNaELFAlgsfQcTFdmY24wNHXgKCyWyF
N4ribfmeDXv/jd3LFdxETobDBIfpH9TQlGejhwnvl+v01YM/D/gnxW7nGiz+/Xfd
hCMDWkB6gD6J575DQcbt
=AwjM
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--

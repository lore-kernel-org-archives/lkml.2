Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2GIMlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:41:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38990 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab2GIMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:41:13 -0400
Date: Mon, 9 Jul 2012 13:41:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator for for 3.5
Message-ID: <20120709124110.GC3934@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.5

for you to fetch changes up to d92d95b6bf2722ffa0fefa7651c51bf336743dd7:

  regulator: Fix recursive mutex lockdep warning (2012-07-03 20:25:58 +0100)

----------------------------------------------------------------
regulator: Fix for 3.5

A smallish fix for a lock dependency issue which affects a bunch of
Qualcomm boards that do unusually complicated things with their
regulators, the API is unlikely to be called by any other system.

----------------------------------------------------------------
Stephen Boyd (1):
      regulator: Fix recursive mutex lockdep warning

 drivers/regulator/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+tFeAAoJEBus8iNuMP3dODoP/3lcEsgr30pnwxxKcryV3en/
X/93hcThxMgRVJJvHjTLOv3rtFvLTFNHBArSwvALa8rw7catLP7zxGO2WVK0Zc7l
nD4+JRzVgqejxrn45B+BJJwO7BZoIFlEjzSB8cK448gx+pveDsgXElQ/hz5O6Gfv
7xecg0GcAemgyFSaQaBI4Xn7Q6xrdVhu+WHrNRRap+uBBaq+ELZQfchyIiT27m7v
JhEdqx2LdKIwSJBIg2RO/AsysP2X+YgxdczqWdGD46tylAPLAHhLLllaHmy1l692
1DNEN/zZYAHffmgqVZ2z1QkPXXoHFPtIz8IAtaTuynVLsSfJ2t2UV2tu4podEzpJ
5u7ekt+wnXMbFV4v09cZC6AX08Vny9LIseCYw09y6iI0TVI3WEHE1mO0//nK6R4M
yE291uEHrj9z+MdC7nIagG/ax/LwaxHr7GTD5Mx/8mCJtAluNbN3IQAN2cg8P7Wh
z1745UAvS9SQoiPyFqPEipIGB27GMBujKubMXA9YtBpb8X7JeExqqrohY+k1hvXj
dQktEkvO+zauRdLlhEkgDTZZ34wc8nrFebl0QN6dLtk+ARwJVJxIyNfdQJ0ChKUO
J80iaGoyHm4pjkc9S3yYrsc0qT82riCwuKaJ8Zbhu672YaD+IaQTciODeQHYZa0l
NqAAcVARCV8163ZeEm5L
=w1kZ
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1IKIMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 04:12:19 -0400
Received: from mail.southpole.se ([193.12.106.18]:42545 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1IKIMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 04:12:17 -0400
Subject: [GIT PULL] OpenRISC fixes for 3.1
From: Jonas Bonn <jonas@southpole.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 11 Sep 2011 10:11:31 +0200
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uQFFrK2dHWAA4Sr7BA2D"
X-Mailer: Evolution 3.1.91- 
Message-ID: <1315728695.4656.8.camel@satguru>
Mime-Version: 1.0
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-uQFFrK2dHWAA4Sr7BA2D
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Could you please pull these two fixes that I'd like
to get into 3.1?

-- one missed patch to remove the usage of pt_regs in
   struct sigcontext... needed for uClibc to build
-- one to add some missed DMA ops... needed for some
   yet to be submitted drivers to build

Thanks,
Jonas

The following changes since commit
93ee7a9340d64f20295aacc3fb6a22b759323280:

  Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

are available in the git repository at:
  git://openrisc.net/~jonas/linux for-linus


Jonas Bonn (2):
      openrisc: don't use pt_regs in struct sigcontext
      Add missing DMA ops

 arch/openrisc/include/asm/dma-mapping.h |   59
+++++++++++++++++++++++++++++-
 arch/openrisc/include/asm/sigcontext.h  |    7 +---
 arch/openrisc/kernel/dma.c              |   28 ++++++++++++++-
 arch/openrisc/kernel/signal.c           |   29 ++++++---------
 4 files changed, 96 insertions(+), 27 deletions(-)


--=-uQFFrK2dHWAA4Sr7BA2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk5sbTMACgkQ70gcjN2673PV0gCfVQO0y7z/vneak0qBYviTfMKa
jIwAn25nSqFxPogzPrqUBvS0oo0hGX8W
=k67K
-----END PGP SIGNATURE-----

--=-uQFFrK2dHWAA4Sr7BA2D--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2CWNiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:38:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:36596 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2CWNh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:37:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="132404755"
Message-ID: <1332510021.18717.65.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for v3.4-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Date: Fri, 23 Mar 2012 15:40:21 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fZxxZobLAgTud4SoK1xf"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fZxxZobLAgTud4SoK1xf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95=
:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.4-rc1

for you to fetch changes up to 5a1f36c90c9b21a7aa31c29a1926b376dd6a11cf:

  UBIFS: improve error messages (2012-03-07 17:13:23 +0200)

----------------------------------------------------------------
- Improve error messages
- Clean-up i_nlink management
- Minor clean-ups

----------------------------------------------------------------
Artem Bityutskiy (6):
      UBIFS: amend recovery debugging message
      UBIFS: increase dumps loglevel
      UBIFS: make the dbg_lock spinlock static
      UBIFS: do not use inc_link when i_nlink is zero
      UBIFS: kill CUR_MAX_KEY_LEN macro
      UBIFS: improve error messages

 fs/ubifs/debug.c    |  410 +++++++++++++++++++++++++----------------------=
---
 fs/ubifs/debug.h    |    3 -
 fs/ubifs/dir.c      |   18 +-
 fs/ubifs/recovery.c |    3 +-
 fs/ubifs/sb.c       |   19 ++-
 fs/ubifs/ubifs.h    |   11 +-
 6 files changed, 234 insertions(+), 230 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-fZxxZobLAgTud4SoK1xf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPbH1FAAoJECmIfjd9wqK0rEcQAIPT4IYi2/+1nd0qW0rcoIZA
5nN8xAUUUtPJ2khzM/V6TyNrOerfwJL2Lz5MeUVmbnKGlG/BtblP7NYNgHEKlio5
lcsSk/01j4HOBPBNY4uo+L23uwgTSp6TkdHV1TSvECOV7o3AojWZGAWuihlgnsXO
1ow0EU05ssRc8ldgl0iCN7H6CdWa3B0Jopjf5IIzlHk8AFhUOYq0jGfAUWknNyq+
Nne/b9CoRscjIN/k1YXPlxwemUnOZ85LRHTXD5JMGrSLWkdx/L6P7fq5QlPu48qE
V+K7IdfP0aVCjA5YcUIE7vS5vAzoa2MWc/WjL1hSH/vpa4zJ14YLvL0ZPtRwCnyz
41n8YyDcV2M9cC9ytWXG6+IOtOs3xdH36dNxfzcax0xj0KevYqds/9PYCAV3WPJb
eFm60dy2y94VvtrJtw+Sr9zH27uFyC32kHzReR7FwbukV917+8I3TTqoUjHnCuZR
PoL15sMbsesHZ0Bb1zlDFsZNxlljmBwniuHzjRfEN7M34BNeuSju1/eWRIgqEW5D
jYGf4dU1Ll7oT60Z8NzbG3MxqpBHAqneeNhJ59mlm6C2gi54f2q5jhsXx4Nb8Oer
VfR66uKW2Tzc0RcUWwDA4UNFSn3IM5jXTRoBKc0n3ySac9ljNa/dlwvfKfSm8pxi
gJV2u4r09ZuskG3wovyA
=nTo9
-----END PGP SIGNATURE-----

--=-fZxxZobLAgTud4SoK1xf--


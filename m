Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2JBNfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:35:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:5974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab2JBNfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="asc'?scan'208";a="228996386"
Message-ID: <1349184946.2017.71.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.7-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Tue, 02 Oct 2012 16:35:46 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Eia6sPFkyci3KRll+Ido"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Eia6sPFkyci3KRll+Ido
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please, pull UBIFS changes.

The following changes since commit 69f9025894c391fec2f7c7ea9150203418454915=
:

  UBIFS: fix error messages spelling (2012-08-22 17:41:09 +0300)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.7-rc1

for you to fetch changes up to 3668b70fcf1fdc6799abf15f70fe3f50f407ec82:

  UBIFS: print less (2012-08-31 17:32:58 +0300)

----------------------------------------------------------------
No big changes for 3.7 in UBIFS:
* Error reporting and debug printing improvements
* Power cut emulation fixes
* Minor cleanups

----------------------------------------------------------------
Artem Bityutskiy (8):
      UBIFS: print PID in debug messages
      UBIFS: always print full error reports
      UBIFS: improve scanning debug output
      UBIFS: fix power cut emulation for mtdram
      UBIFS: use __aligned() attribute
      UBIFS: comply with coding style
      UBIFS: use pr_ helper instead of printk
      UBIFS: print less

Jiri Slaby (1):
      UBIFS: remove __DATE__ and __TIME__

 fs/ubifs/budget.c     |   5 +-
 fs/ubifs/commit.c     |   8 +--
 fs/ubifs/compress.c   |   7 +--
 fs/ubifs/debug.c      | 633 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++------------------------------------=
---------------------------------------------------------------------------=
--
 fs/ubifs/debug.h      |  15 ++---
 fs/ubifs/dir.c        |   4 +-
 fs/ubifs/file.c       |   4 +-
 fs/ubifs/gc.c         |   6 +-
 fs/ubifs/log.c        |  14 ++---
 fs/ubifs/lprops.c     |  66 ++++++++++-----------
 fs/ubifs/lpt.c        |   5 +-
 fs/ubifs/lpt_commit.c |  58 ++++++++-----------
 fs/ubifs/orphan.c     |   7 +--
 fs/ubifs/recovery.c   |  11 ++--
 fs/ubifs/replay.c     |  16 ++---
 fs/ubifs/sb.c         |  19 +++---
 fs/ubifs/scan.c       |  15 +++--
 fs/ubifs/super.c      | 119 ++++++++++++++++++--------------------
 fs/ubifs/tnc_misc.c   |   4 +-
 fs/ubifs/ubifs.h      |  13 ++---
 20 files changed, 451 insertions(+), 578 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-Eia6sPFkyci3KRll+Ido
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQau2yAAoJECmIfjd9wqK0Ur8QAIz5FY9BlzggN0dhNtJR3eeY
BjnYsrheW6oKj6x+1woH3fizXGbaTdQ6joYq08ePmVnGfQnUk+qN4MCBVb5YCeIG
ipZu109vxVH5hqmsQk5NcT6fCvN6TSeJ9xVaOdPaVS9KTR99RhFAwdXnYq1eTvo3
F0CUPk+qJJ1ElvEeCqqLWoaGCex/WiW7WuuGgzQCSSLzwZXBR63udvUeAM7rlhcC
F9UiUROjjZGd+xXcjtDXmlCZcVlSgJ67lhay75PW/KXQC9kgsf/5udtt0HPkpWu2
Q8MSKKI6Yv7QpgynLuNSNSHK44UD7vAvicHObYjljTBcdazyMxJNl322NIAsfq6W
H/sSOtXqnUl7jm9W6rIaZFgceKLvkjVdCiP8VW9KydJm5dPiSqCJwFRMKpd0bDdu
3KcjgbLPQZVbRBa44AXdV9M3oV6UpPdkXEvmxhbvRwkoPjZ592vkKA0ubXS35gsI
fPvB8zEmMmWSNE/XwK5pKXy2aXNyF3qxZKbTvrr32ZwlzAUosEq3TluwHbY3clT0
uUCy3cdT/2YI//a+3n94pFBWLciCkqfGE61jWWCB4F6RhWNdPNL0dqGCTmLVD0YM
fgGt6gaIF8RqaoQz9NvWRhnEMSE4v+mp8bKD8lnMA+qVRTkaAlLFikZ7EJW6FYio
SBLWKnBNtMjSg/fjyRTW
=RI3J
-----END PGP SIGNATURE-----

--=-Eia6sPFkyci3KRll+Ido--


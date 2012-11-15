Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768162Ab2KOPUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:20:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:11645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992479Ab2KOPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:20:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,258,1352102400"; 
   d="asc'?scan'208";a="242711037"
Message-ID: <1352992872.2221.62.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.7-rc6
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Thu, 15 Nov 2012 17:21:12 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1Ce7NDS2bKk+SmXErVh/"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Ce7NDS2bKk+SmXErVh/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please, pull UBIFS fixes.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556=
:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.7-rc6

for you to fetch changes up to a28ad42a4a0c6f302f488f26488b8b37c9b30024:

  UBIFS: fix mounting problems after power cuts (2012-10-26 16:26:44 +0300)

----------------------------------------------------------------
Two patches which fix a problem reported by several people in the past,
but only fixed now because no one gave enough material for debugging.

Anyway, these fix the problem that sometimes after a power cut the
file-system is not mountable with the following symptom:

        grab_empty_leb: could not find an empty LEB

The fixes make the file-system mountable again.

----------------------------------------------------------------
Artem Bityutskiy (2):
      UBIFS: introduce categorized lprops counter
      UBIFS: fix mounting problems after power cuts

 fs/ubifs/find.c   |   12 ++++++++++--
 fs/ubifs/lprops.c |    6 ++++++
 fs/ubifs/ubifs.h  |    3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)


--=20
Best Regards,
Artem Bityutskiy

--=-1Ce7NDS2bKk+SmXErVh/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQpQhoAAoJECmIfjd9wqK0UNAQAJLJ9tX7GMBYrSnp44QFqwSH
4EPGgPdZhg37wmDXZ7OsusSJb0KleGf6KO/jv4F7YM64EEOMKFPWvHEMUW4Ed0l5
WAifgTh46AchX/IptjHUSkcTMll4qrdzM+qY/NRlyeYloXtvpWZ/BkfPj8n1iNKY
usEA2U5yCWGqg+aqTXDehyzhB5VkduNZtteHOe/pI6dsosZrEO1zmdgI9KQ8mhKn
dLXv8EFmUO2onhm9zsgoOLiNlfs4yYL0br91ndNcg4UwTWZEvyrJ5MzriZXcgRzJ
/JsaB8QoNbSQZ7EuooFR8fm0t0lZFZkpEjtLBJ2o+IKT4DbN7olGLb4zPWU2Dpms
JwUQ9YcrKsAhffG99EulXAKkJUr6gBOkapxaOlhfCioZns8//fTeX6YYfjxPPZIK
2d5u9thiKPB1921wgUxJlSRyfO1UXE9Zo1HCi1QUREYQdrLkMIg2zD6ldbkzHea6
aJLz36EHq202StQEglCZZdrcQUVVTK9edKJAjMQPilduuvM4M4AuEpTsknBwne84
x7ZTujXNEos/2g7sfyuiqaEZ8vZePPrWEq1C8jHSWU3eqYP36v9o6cflpJ54Fjfz
YnNcGuTmHEl6wQw+NieCcqbabLv5QsxA0dfRAmI186lO0ZIC04v2iq7C64lU54GS
VtqpMd6UvPle8HqOTQyP
=wdE3
-----END PGP SIGNATURE-----

--=-1Ce7NDS2bKk+SmXErVh/--


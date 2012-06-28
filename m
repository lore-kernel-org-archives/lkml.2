Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2F1Pyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:54:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:53714 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2F1Py0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:54:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="161838151"
Message-ID: <1340899111.3070.126.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI/UBIFS changes for 3.5-rc5
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Thu, 28 Jun 2012 18:58:31 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PZKDkVvda3jWlDauxaQc"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PZKDkVvda3jWlDauxaQc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 485802a6c524e62b5924849dd727ddbb1497cc71=
:

  Linux 3.5-rc3 (2012-06-16 17:25:17 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.5-rc5

for you to fetch changes up to 903e0e4ef9120c3d7693599acb95e76e8263fb35:

  UBI: correct usage of IS_ENABLED() (2012-06-27 14:22:15 +0300)

----------------------------------------------------------------
Fix the debugfs regression - we never enable it because incorrect
'IS_ENABLED()' macro usage: should be 'IS_ENABLED(CONFIG_DEBUG_FS)',
but we had 'IS_ENABLED(DEBUG_FS)'. Also fix incorrect assertion.

----------------------------------------------------------------
Brian Norris (2):
      UBIFS: correct usage of IS_ENABLED()
      UBI: correct usage of IS_ENABLED()

Dan Carpenter (1):
      UBIFS: fix assertion

 drivers/mtd/ubi/debug.c |    8 ++++----
 fs/ubifs/debug.c        |    8 ++++----
 fs/ubifs/find.c         |    4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-PZKDkVvda3jWlDauxaQc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7H8nAAoJECmIfjd9wqK0RM8P/iWPdp+fCC0hF+dz1wCTNGq5
5gs0j7g1YtmDEKbs8yo0HYHISCca73MpE2tjWUIcWlFaXm+iXUzhC7bIaaoctVPp
xyuiKgsh+ux0BLpHz+TcMBeq43KGsooKcb0suBPIOJ6DBEmGeQ/nAfxVQNc9oII6
1eW9uwI/cIq7gXmMQGbcuZ7nKY7lLOf24BEK6dNVhIVWz6VVDaVl27O1vTYDsC8+
5VtX8eGJCC2KYonH6NZoq51IgQbwf1vZCS7n7gWbonz7HN0xDygmOwsqtFpQboQJ
oxOWaPMOEGa8yvXX/2WUboSt9WhJ63K8QBfhhaWUVGSevLfEfjL9StH6UWqUt6jC
ZfEKdKEPmKxL72r1rqf+GxDDV70YbxdwZ503HutkHRVEs7eS/g1QVK5HvmtiCduk
rClhWAmC42XSW4El4vfW20ccVHwJctWrVI3MP1DtA5t3WixjTCsvUoqL1uGwGVX0
Ga8mtZ01LbGk6yApgmk2QAQAtCAplbhj73DpYETSwvz5VHX6hwzhA6ogM1NdbaML
WDCcoznFEggbYeM3+bUrurxyMe2MTRwtlL1n2sQmlGToVxYGQT/mVc1t3J3yobRy
T/SDmKCLg7GcgF1nOLu8FHZQ/UtrhxQB3apdt8qbpHaE35KSCauxJbkrqGzHz+V0
pE8PDW+fdTrSYkCEh0VR
=zOS9
-----END PGP SIGNATURE-----

--=-PZKDkVvda3jWlDauxaQc--


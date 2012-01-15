Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2AONcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:32:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42181 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2AONcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:32:41 -0500
Subject: [PULL REQUEST] again UBI/UBIFS changes for 3.3
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 15 Jan 2012 15:32:28 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-oQMVqTSa82JuhhxWgcW1"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1326634357.2201.18.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oQMVqTSa82JuhhxWgcW1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I apologize for bombing you with pull requests this merge window, but
here is yet another one. It contains one build fix, one important fix
with stable@kernel.org in Cc, and one cosmetic change.

The following changes since commit 94b1984ab9ab61cc6047c07e074d766485299a9c=
:

  Merge branch 'linux-next' of git://git.infradead.org/ubifs-2.6 (2012-01-1=
3 10:31:33 -0800)

are available in the git repository at:

  git://git.infradead.org/ubifs-2.6 linux-next

Dominique Martinet (1):
      UBIFS: fix non-debug configuration build

Richard Weinberger (2):
      UBI: fix nameless volumes handling
      UBI: use own macros for the layout volume

 drivers/mtd/ubi/cdev.c |    3 +++
 drivers/mtd/ubi/vtbl.c |    4 ++--
 fs/ubifs/debug.h       |   31 +++++++++++++++++--------------
 3 files changed, 22 insertions(+), 16 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-oQMVqTSa82JuhhxWgcW1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPEtVsAAoJEJtuLFy+q7fe7WEIALAnr26nmSx3Edq7kDy9RQv1
Iv4MsXMcoqP8iTommPRAKwL325qzegMmUSKub/ZNc0geayD97e/07OBQNGM8upCn
AscdxZ783xmpMMpTw9VCX3S/iieaLVjFjlhKx1EssyODdJCoM76ha8YXReNYLO+w
yiR3j6WZDfJKzHoXKB5f8g5j5ZU0p14M3NXb45Z3rcD8oOp8MkG0K1nh6MsWVjFd
9uCl55XcwCx5p/OwxAfSiFDmlkB0xdvI3e6SbnQFF/daZMgUjcSXEmJy9itb89tK
skzIYjemTgwMHZgCQzjFmGS41dahGdVKggzkO/8fqMKQTH8c/olzOgCFAVQ2bMg=
=iDlP
-----END PGP SIGNATURE-----

--=-oQMVqTSa82JuhhxWgcW1--


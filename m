Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2ITHBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:01:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63137 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2ITHBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:01:34 -0400
Date: Thu, 20 Sep 2012 00:01:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.6-rc7
Message-ID: <20120920070129.GA8561@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a few driver updates
mostly dealing with recent regressions.

Changelog:
---------

Anisse Astier (1):
      Input: i8042 - disable mux on Toshiba C850D

Axel Lin (1):
      Input: edt-ft5x06 - return -EFAULT on copy_to_user() error

Dmitry Torokhov (1):
      Revert "input: ab8500-ponkey: Create AB8500 domain IRQ mapping"

Fabio Estevam (1):
      Input: imx_keypad - fix missing clk conversions

Forest Bond (1):
      Input: usbtouchscreen - initialize eGalax devices

Pawel Moll (1):
      Input: ambakmi - [un]prepare clocks when enabling amd disabling

Tai-hwa Liang (1):
      Input: sentelic - filter out erratic movement when lifting finger


Diffstat:
--------

 drivers/input/keyboard/imx_keypad.c        |  4 +--
 drivers/input/misc/ab8500-ponkey.c         |  4 +--
 drivers/input/mouse/sentelic.c             | 11 ++++++++
 drivers/input/serio/ambakmi.c              |  6 ++---
 drivers/input/serio/i8042-x86ia64io.h      |  6 +++++
 drivers/input/touchscreen/edt-ft5x06.c     |  9 ++++---
 drivers/input/touchscreen/usbtouchscreen.c | 40 ++++++++++++++++++++++++++=
++++
 7 files changed, 70 insertions(+), 10 deletions(-)

--=20
Dmitry


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWr9JAAoJEH70+W8r6ZYqAY8QALLvNQsCAPw6lkc0bPykMjKe
xeg0vCnhVTYEZu7RxQYKhKgFtSQ1uTd0CEUo3pNxQHiLuDsOOthU+hzhRZ9ytSB3
6F0qyl3QIfGqTPsCeWJZyDrYleIYZs8mUQjyW0xefqtJa/A8di4eFCS8s2x06N4u
qSpu+y2jQq4ghW+BXQbH5RfwuGMBDFTEZSJEQBSCLwvYvjCShOgPT5YIm6fsVwnq
Oc0X2WXmraYYvTKaDgalvpKWOtlfdYfLBhbRip1gMkWJUC39o6OETDqJ00E4bonn
YccUSzflDBcY/Th0lcZrK68evMH+kZ3HHfVvacYbBvXKL2TS5vmyFol6IfGoMsOz
r+UrJbfFtgPMdVff31ug8IN7f1X8M6+31K+ceKOkyV9BNH8ZS4jAKYGObb5a5jm9
Ht5GYAfvbqCt3ZeAniruI+HD7Sioj8yJzuGvFWKDmeq+XQbgFjL/nb2Xtp5f2Ydf
zljet8hjJbrUGD6NnsSG3lkKDv5th3rPUIBez4v8bfTf9dRoSDPJrYO1w/KE3FkG
MkAGJBK3+JvXC77+QJRSnQ4PtEcMB6oXnO0P2L4gqKHC6uEv65NV5QSc5F2wOIyH
ZQlLrNcnp+rRJ3ssTBMhDPPZjJxNFAcjE/v29HUoAfcX3AMn8xywgLYu9nQPX0al
P/kYZKuGTgmg8df7BhyR
=w/yx
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--

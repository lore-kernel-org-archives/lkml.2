Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2H3WxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:53:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2H3WxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:53:23 -0400
Date: Thu, 30 Aug 2012 15:53:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.6-rc4
Message-ID: <20120830225318.GA21501@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dmitry Torokhov (1):
      Input: i8042 - add Gigabyte T1005 series netbooks to noloop table

Guenter Roeck (1):
      Input: edt-ft5x06 - fix build error when compiling wthout CONFIG_DEBU=
G_FS

Jason Gerecke (1):
      Input: wacom - add support for EMR on Cintiq 24HD touch

Michael Grzeschik (1):
      Input: imx_keypad - reset the hardware before enabling


Diffstat:
--------

 drivers/input/keyboard/imx_keypad.c    |  3 +++
 drivers/input/serio/i8042-x86ia64io.h  | 14 ++++++++++++++
 drivers/input/tablet/wacom_wac.c       |  6 +++++-
 drivers/input/touchscreen/edt-ft5x06.c |  2 +-
 4 files changed, 23 insertions(+), 2 deletions(-)

--=20
Dmitry


--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQP+7eAAoJEH70+W8r6ZYqnQwQAIlqw8DYMpDaSP+rPuXHNkqk
wx1Ie5ceVQBFw4JtiHiSypIjhXUuPg8r+69ugu7adaPQu/2wCCyj6SZ+iXt3i2zb
uCon7KQr7bOHmec9JvSS5e5dL+ttC3t/7WYhRr6ZiMyJp6PUFAsEVqM8RVFdKKU5
7z5609m1NMVQrq1eakz6iIC9+psaRd9ZiNHbiOIZBIog9EEARFwRsC0Q4xFakGAc
FaIC6baIAyvRdVByb9rDJZkPK85ILDdBAtylvNeGohIKv3VHveFetG3hF++yhKhc
QKWn/KJTPG3I6KB+UlqCYriGbO1/c8+9WLQOp+i7h72jXe6GLXRglTLrry/roLpc
d3gfneRt7VIjVOApJDEtOAwVbMrI7wiFhAiNKrBHRfwVL8DbC64fpVFoLOJjdGqt
mtVBFWdsE38q03YJ3JYZTnz0pbxckRnz2HlI0eNgXLbtyzIKQ+3RtGiE37vw504O
IWBSx4980G35V/PfmAiWnfMdW7uYvDXdleDk4ePYjdYNALpH+AHGhlUV5qdwOoAu
4w060XZ7iRPoUwEj9Dql0jIDBQLwIebFYWHuY58D43TqwJNoxGoZqrig5bOwhNgp
qDsLrA2bDCqH0v3Px2V88uJagDsudqktEltVpkfi9z5ZcrRLYu4l01RzsQ9iE0xQ
hPR8KenRCaSd8/+t7eFJ
=AWMy
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--

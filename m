Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2GMHqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:46:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59385 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2GMHqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:46:37 -0400
Date: Fri, 13 Jul 2012 00:46:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.5-rc6
Message-ID: <20120713074633.GA23271@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. The changes are limited to
adding new VID/PID combinations to drivers to enable support for new
versions of hardware, most notably hardware found in new MacBook Pro
Retina boxes.

Changelog:
---------

Henrik Rydberg (1):
      Input: bcm5974 - Add support for 2012 MacBook Pro Retina

Ilia Katsnelson (1):
      Input: xpad - add signature for Razer Onza Tournament Edition

Ryan Bourgeois (1):
      HID: add support for 2012 MacBook Pro Retina

Yuri Khan (2):
      Input: xpad - handle all variations of Mad Catz Beat Pad
      Input: xpad - add Andamiro Pump It Up pad


Diffstat:
--------

 drivers/hid/hid-apple.c       |    6 ++++++
 drivers/hid/hid-core.c        |    7 +++++++
 drivers/hid/hid-ids.h         |    6 ++++++
 drivers/input/joystick/xpad.c |    6 +++++-
 drivers/input/mouse/bcm5974.c |   20 ++++++++++++++++++++
 5 files changed, 44 insertions(+), 1 deletion(-)

--=20
Dmitry

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/9JYAAoJEH70+W8r6ZYq7VgP/jtuXcZTznjW3ZgVVRb6Spnt
Dd48Kast/RhKBPgShF4m+/5m0ZPAXNj0g1E0MXw3p2SJz7DRzkhKZs7MzgwfRyjm
SJ7NRU1EgxJ7WteaL4JQYOkgJZshrfUBH29+wdm8suR5NES3/OyoTMHqD4A3F7Ed
vgT+RZitE3wJj9eAs55Xdu4W4mgpcGj720pMz9ZyjAPcilQJBSiZEJP4FXev28oV
dgk4y9x6R4NChbcZwwl73q19wY6XxmPo83oK0upIaI6mCyf7cRB5bTI42NnJ8AI9
l6zDhZlWT3oL0f63cU59YZUHtiKcWCgbbIkkh3w1ezjR/mt2VniHVwId+BpEleMh
glxGLyKjlIK5FBfu4kEgglZum+XjdfkvA+BBAXIZKAxvIRcjV6Y08REDOl9Ld3BD
mPucxH4naAX5f6YXlrq5fF6M01UTFQwnV4Vgwt4N65aohQyWX78GO5+nzc12TqEY
ANoYqksSFYDH7WFj4JuGF7Vhtr7Cw+3sKCCx/4m6W4V56jxlmrwHoi0p+Mkkgf7h
lUaKgLOgir91Vx5TsmvfCE5zcngWKY9l9+QeEJIo7ieubHGn824pLgMi5YRQRfcy
jicMVQYmfXrKiB8Y1D27GieZ9/IEY+FD3F6MY7B4TVrx4qAKB+fiqDd6+vC2Acew
4m96a89tU6MKQCjAUvJ2
=kA8s
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--

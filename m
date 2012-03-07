Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2CGJSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:18:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61199 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2CGJSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:18:20 -0500
Date: Wed, 7 Mar 2012 01:18:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.3-rc6
Message-ID: <20120307091816.GA28160@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a few driver fixups,
nothing exciting.

Thanks!

Changelog:
---------

Akio Idehara (1):
      Input: ALPS - fix touchpad detection when buttons are pressed

Chris Bagwell (1):
      Input: wacom - add missing LEDS_CLASS to Kconfig

Dmitry Torokhov (1):
      Input: twl4030-vibra - use proper guard for PM methods

Heiko St=FCbner (1):
      Input: evdev - fix variable initialisation

Jason Gerecke (1):
      Input: wacom - fix 3rd-gen Bamboo MT when 4+ fingers are in use


Diffstat:
--------

 Documentation/input/alps.txt       |    3 ++-
 drivers/input/evdev.c              |    2 +-
 drivers/input/misc/twl4030-vibra.c |    6 ++----
 drivers/input/mouse/alps.c         |    7 +++++--
 drivers/input/tablet/Kconfig       |    2 ++
 drivers/input/tablet/wacom_wac.c   |    2 +-
 6 files changed, 13 insertions(+), 9 deletions(-)

--=20
Dmitry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPVyfXAAoJEH70+W8r6ZYqH2AP/13PXkjlgX3/hy0bjY377Fiz
StF7n7pk3kdlpqhZMUTsgYQP1S63RiqoYhX87rpkAGJ83t0KwtgciIObXBLnC6LT
OKwbQCR87mf13iyN+U5Yig+0WEReForLMK5Vpx5O5EnO9RhQZWfGCI3/C2ex8RXe
CznkehXHVSFFM0MLAFdlAhUEpCTgcLaDMTW204taJYCXnTIdkop3uDOVdRDQxE5I
G2j2L8CxGTFjdMEneaxKQsVMp27DiFTcjFhyeeB5xoF9S+SBR3WfXyhEemIA2YiA
OG4oNQiZ4ylx3qLT0azv+6KED0/LK7tJkBnQoV7peDHTrJb7e51MxYIm4p1+Yk0V
FTNJUQq/iRQ72TB8efI1w4RYmNBmOXK+LRiAUTMOB7bnhKOGhLHsTWXot6UHWZkK
ntfJd68kEeNAGMsYSozGuY2LPwG3DES3AQpI3AP2oOXi35gAdOrFNi1rJf2PQ3tO
LNYiA0FyU+xeAg+AVrQVXNEx5OXl66ku4ILZmYVBx/i+iKUz4df5H5x7bMWga78x
mSY5PEgPBVJrytDq73N5L/lURFkPAr3A6UH5QwcedUAWPJC8pQ/Q4VLS6uwGKqXV
V8XOFiWj0Io1TRuzJrKomPPp/w6HlCzvvswLBA+MhbCXT90iRet4wbvZR1Gu84NF
yaNGG0KAGLjlD3MsQmpa
=XyFY
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--

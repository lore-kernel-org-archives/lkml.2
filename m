Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2BCIhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:37:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33199 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2BCIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:36:58 -0500
Date: Fri, 3 Feb 2012 00:36:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.3-rc2
Message-ID: <20120203083653.GA24226@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

You will get a fix for evdev that was recently broken with regard to
non-blocking reads, a few fixups to drivers, and input properties
documentation from Henrik.

Thanks!

Changelog:
---------

Che-Liang Chiou (1):
      Input: serio_raw - return proper result when serio_raw_read fails

Felipe Contreras (1):
      Input: twl4030_keypad - fix comment (trivial)

Heiko St=FCbner (2):
      Input: evdev - fix variable initialisation
      Input: gpio_keys - fix struct device declared inside parameter list

Henrik Rydberg (1):
      Input: document device properties

Igor Murzov (1):
      Input: i8042 - add Lenovo Ideapad U455 to 'reset' blacklist


Diffstat:
--------

 Documentation/input/event-codes.txt     |   72 +++++++++++++++++++++++++++=
---
 drivers/input/evdev.c                   |    2 +-
 drivers/input/keyboard/twl4030_keypad.c |    4 +-
 drivers/input/serio/i8042-x86ia64io.h   |    7 +++
 drivers/input/serio/serio_raw.c         |   15 ++++---
 include/linux/gpio_keys.h               |    2 +
 6 files changed, 84 insertions(+), 18 deletions(-)

--=20
Dmitry

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPK5ylAAoJEH70+W8r6ZYq2xoQAKntRzcJjdsNcNbYypmNbxAW
Y5kcNstYNs04jbeO05xUt7gSSR/dV2QylMg5IxIQDsFLKOsR8NCEqz47ftqYgjLX
5RyZbWvunadcjag4qTH1nYfn33tqAr0XcKaVNqsiIux2Ib+qasVAjHBPnV9iwpiB
dGkfRnWqd8ZiQ4dtn/dZ81xH6OBS7j2vOC4Hihq/SwJvBXR0M0k/oyuP9IAAtWNx
bMGwzNqbLhJw9oOMMLZq5DqW6zHfOIZMjx0mGSIhKIiWgTu8eUTMGQ1CGS1SQ8dk
ON548oGDM1eqivc6A7SJr0l/IR4res05TojC4C2/L/3ZU1VepISn+b+lFldAKxai
aNTZrmSEK0XQ/2LsBF/WDJfjZP1LjIc2t7g1xFEj1G1hJLO9WX7/p7BcBEkPhbXD
Ml/YchNw6H2SKDlTGm2ABEztq+ioszLUHMnk6kwboZ/6cO0Hb+mnUjb/vEQfUv7K
CacA3X1uUv+uStcl96T7TIQ9PKxpDHPk9hmJA4aZPfM9xTE3+ToOjM89C+H2V17X
AvIiAFmxUIxQw9eUPLG6+Fw8hQpSBzrvBJhdKxs/UrhOiBVjPCWAsUC+cglZE2UN
CesDk8t/x2IimxiYCbZCuKiBQTCc3cwDpkI1bYfBkXxKH+Aa7KHzwk+j+0mQSsI2
Qs7FqKS/AhpTbaaobxio
=4yyY
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2C3GH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 02:07:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49556 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2C3GHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 02:07:48 -0400
Date: Thu, 29 Mar 2012 23:07:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.4-rc0 (2nd round)
Message-ID: <20120330060742.GA13817@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem:

- update to Wacom driver to support wireless devices;
- update to Sentelci touchpad driver to support newer hardware;
- update to gpio-keys driver to support "interrupt-only" keys;
- fixups to earlier commits.

Thanks!

Changelog:
---------

Chris Bagwell (4):
      Input: wacom - isolate input registration
      Input: wacom - wireless monitor framework
      Input: wacom - create inputs when wireless connect
      Input: wacom - wireless battery status

Dan Carpenter (1):
      Input: wacom - check for allocation failure in probe()

David Jander (1):
      Input: revert "gpio_keys - switch to using threaded IRQs"

Dmitry Torokhov (2):
      Input: gpio_keys - constify platform data
      Input: gpio_keys - consolidate key destructor code

Geert Uytterhoeven (1):
      Input: amijoy - add missing platform check

Laxman Dewangan (1):
      Input: gpio_keys - add support for interrupt only keys

Oskari Saarenmaa (1):
      Input: sentelic - improve packet debugging information

Tai-hwa Liang (3):
      Input: sentelic - refactor code for upcoming new hardware support
      Input: sentelic - enabling absolute coordinates output for newer hard=
ware
      Input: sentelic - minor code cleanup

Viresh Kumar (2):
      Input: spear-keyboard - remove kbd_set_plat_data()
      Input: tegra-kbc - allocate pdata before using it


Diffstat:
--------

 arch/arm/plat-spear/include/plat/keyboard.h |    7 -
 drivers/input/joystick/amijoy.c             |    3 +
 drivers/input/keyboard/gpio_keys.c          |  259 +++++++++++++++--------
 drivers/input/keyboard/tegra-kbc.c          |    1 +
 drivers/input/mouse/sentelic.c              |  294 ++++++++++++++++++++---=
----
 drivers/input/mouse/sentelic.h              |   35 +++-
 drivers/input/tablet/Kconfig                |    1 +
 drivers/input/tablet/wacom.h                |    9 +
 drivers/input/tablet/wacom_sys.c            |  231 ++++++++++++++++++---
 drivers/input/tablet/wacom_wac.c            |   49 +++++-
 drivers/input/tablet/wacom_wac.h            |    6 +
 include/linux/gpio_keys.h                   |    3 +-
 12 files changed, 696 insertions(+), 202 deletions(-)

--=20
Dmitry


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPdU2uAAoJEH70+W8r6ZYqH4AP/0mQVQGeiQstzMcebmMjaa0v
wnAqBN+HIvNBOg6q873Swel4rtlHJnd9kEuupw7ZSJZR/kKeUQ8Vk6qDSL6yZIuv
2HM6R8vexjO6vNgFD4CNOMe5nLe1heEJauV/N/5zSvfz8R/BPmN6j4fnR69nC1ky
aYGPz+jOHRZ9nGONvqak+PUabO8dKNhSF3cWaQmKMRJgKbQcmm/iaomt1hyYaWYC
Kw0lEHe5l8RgdTPONvGaoDXrSzO6VPHdCyJsyJSQfg/uwtFeXTnFTJaUG6jrGmwP
CqKYN7yBmVz4CFJAM/UKvf85bOUKPnXZdElmvtdeaKX1XBY5l+tr4nThtk5Y66vk
86Etaegb42Ce3ZCWxUb1I1ElPxPqIT/KJec8em5K/wHO9AR526JdTSlhm172SZF/
zUkTyMNnjydME6EA5kySoR9L4UFfp3EwLBhRGPbFGjNNgRYEEB+RHBCsaRhoeQB9
IObrbL4yzP6cWwPOwnXR/FEtl6sU3igjjZRVjbyIFc5cnjCBJawfi8uJ37X0Aw/L
gjvSk+jck8ig66Sg8DWCG0+OvWDZBOel1Kk032HSL5uwFBgj2zcbX7JlWZAHvlai
pZjJPnSuB+bIkbKIKw84j0T0bYR1KR7a5ifYXFQ/LYeaY54dXY7tG9U7ioH+AUTv
YPNktLE267KGxHvPwrFa
=nIlZ
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

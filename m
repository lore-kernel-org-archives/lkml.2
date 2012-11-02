Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493Ab2KBWuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39436 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab2KBWuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:50:16 -0400
Date: Fri, 2 Nov 2012 15:49:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.7-rc0
Message-ID: <20121102224933.GA7179@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a few driver fixes.

Changelog:
---------

Hui Wang (1):
      Input: egalax_ts - get gpio from devicetree

Jason Gerecke (2):
      Input: wacom - add INPUT_PROP_DIRECT flag to Cintiq 24HD
      Input: wacom - correct bad Cintiq 24HD check

Roland Stigge (1):
      Input: lpc32xx-keys - select INPUT_MATRIXKMAP

Rolf Eike Beer (1):
      Input: tsc40 - remove wrong announcement of pressure support

Vasily Khoruzhick (1):
      Input: pxa27x_keypad - clear pending interrupts on keypad config


Diffstat:
--------

 .../bindings/input/touchscreen/egalax-ts.txt       | 19 ++++++++++++++++++
 drivers/input/keyboard/Kconfig                     |  1 +
 drivers/input/keyboard/pxa27x_keypad.c             |  3 +++
 drivers/input/tablet/wacom_sys.c                   |  2 +-
 drivers/input/tablet/wacom_wac.c                   |  3 +++
 drivers/input/touchscreen/Kconfig                  |  2 +-
 drivers/input/touchscreen/egalax_ts.c              | 23 ++++++++++++++++++=
++--
 drivers/input/touchscreen/tsc40.c                  |  1 -
 8 files changed, 49 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/ega=
lax-ts.txt

--=20
Dmitry


--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQlE39AAoJEH70+W8r6ZYqMioP/iyLNvR56pGBnE+FV6HSqVGk
h3D/nYKyJ68FyID5ZBRTh+CSoAzqgQq7KQK46EPsvvavQXikP43JnEx2U/B7ecrM
47ZOXuu4zk7FBOVRGx1JXkirzyKOIDnxv3AACeE8a+Wces/sofBPRrTxv4lknnIt
2vhdEN87evO07UsNZ9K7rhLo5ETI9RnjkiRAluH77qOeu7K7Ared9H4F0eg2DARy
0/S00fJvDDAVO3sujBuEFbbtbHeHVu3skiUk4891H6v4LOOCC8nqAOfk4gHKbftw
y3/lFSLLAl+msAyLSedXfRpGXvEf8OMDejwSeszC1gMgaCrWp4IiGU7TC+NiSxko
LGk7QudTUcyLhfc72A4MqhpYNmXXEPbHLxHi6iFbKIaFsl0OLjg8wUV8VpP5cdb2
aLeh0ab6mu/69ARmd1gbs86FV/rOy8MD0O1fapb85PQ1q6hQWXr/v2JrbU1k81B8
y73z2qB39fSHih5UMdfgHCSPpwRYaS8YqFdS5RwSRKyVxadSmpefzf3QR32P3SN8
qokqHd7AgqB0kxB1bvSqxeyNwywJmwCkt5NDN+8IkSqkDt4W2PQojiHKdS+Ra3V+
03xByUnwXzrid2fEQEkzXiqw8/Go1eRmRQRPohbjtiERW1W64uJcu2IzySh86nHe
SnYQj4cSdCiFaqmVDGLy
=Tv1B
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--

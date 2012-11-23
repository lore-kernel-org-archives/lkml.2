Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2KWGyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:54:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45520 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab2KWGyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:54:44 -0500
Date: Thu, 22 Nov 2012 22:54:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.7-rc6
Message-ID: <20121123065439.GA14428@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. This fixes recent regression
where /dev/input/mice got assigned wrong device node which messed up
setups with static /dev, and a regression in ads7846 GPIO debounce
setup.

Changelog:
---------

Dmitry Torokhov (1):
      Input: mousedev - move /dev/input/mice to the correct minor

Henrik Rydberg (1):
      Input: MT - document new 'flags' argument of input_mt_init_slots()

Igor Grinberg (2):
      Input: ads7846 - enable pendown GPIO debounce time setting
      ARM - OMAP: ads7846: fix pendown debounce setting


Diffstat:
--------

 arch/arm/mach-omap2/common-board-devices.c | 34 ++++++++++++++++++--------=
----
 drivers/input/input-mt.c                   |  4 ++++
 drivers/input/mousedev.c                   |  4 ++--
 drivers/input/touchscreen/ads7846.c        |  6 +++++-
 include/linux/spi/ads7846.h                |  5 +++--
 5 files changed, 34 insertions(+), 19 deletions(-)

Thanks!

--=20
Dmitry


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrx2vAAoJEH70+W8r6ZYqMDMP/jSisg+rE3X17XimJAbS5chK
avdLLFPoQ9VdRzLsaQo10M9BNUHcGAnxRH1xSU7Lm2IeQrPowYRFyjhVSyP7dQid
V3kxrVyi1BmkbeRKqEX0BidmjIgky9kf1VnroNqaHBQGvf91ZYz+aE/gnxBSBqxY
65PzQMqcUoHXGlbIUsgcRAhLVMxHvitBbGtDAJrOISHCIw1xJ2IYFWgM5nQIFqsn
XUT8QpSk6kLGj8tKbJk1+NYzeKM0P3vKs92ttr0RCo9tyS9B4kOpCAopJB8DgsZJ
WlGbId0QCRT2gHeurjWvKPjn1bDeh9p6zlOKsw16CVPO6loi/H00Cxw8VWHk7aIY
xPUJnHvAiMZ5ibdJEduBadh1N2b2i4U+/U8hTIu14y4nI/5Ub9MkF6BO5UNOgemX
UxN7iYBvS/wacLBQA5emKDBWVETae93Sn/Imok66X4UW+3oXJDB+Kiz1qH3H9354
+IM5X77a39JgjMfHpM8AJRLHX9ihiOSjyIVhGcSjlwD8GhJ2dhUWp8rklRLz0AIX
t3c56U8bCqHgKOlXsInKTYWUVQL9kW6lIMF86AfyM5uK4sSQQFFZcE8uEnrQ4rcI
Le0sbo8kZ5QFGQ9eLyiTeYzXl+2A41nm0Lo5MVwsS6oSQkX7ji1yjvXvSLPn0fh0
IP3uYvfHy05DKdeorBZe
=pN20
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

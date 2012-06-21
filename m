Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab2FUTXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:23:06 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59483 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760055Ab2FUTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:23:02 -0400
Message-ID: <1340306563.1631.280.camel@cumari.coelho.fi>
Subject: pull request: TI wireless drivers 2012-06-21 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        arik@wizery.com, assaf@ti.com
Date: Thu, 21 Jun 2012 22:22:43 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IU9bs+2JbZK1eyvnkjVe"
X-Mailer: Evolution 3.2.2-1+b1
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IU9bs+2JbZK1eyvnkjVe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is another pull request intended for 3.6.  A few new small
features, some cleaning up and bugfixes.  Nothing major really.

Please pull or let me know if there's any problem.


The following changes since commit f761b6947dde42890beea59b020e1be87491809e=
:

  rtlwifi: rtl8192se: Fix gcc 4.7.x warning (2012-06-20 15:14:57 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to da0b1baa94a9c11448e010a150280d0834b11c32:

  Merge branch 'wl12xx-next' into for-linville (2012-06-21 17:31:46 +0300)

----------------------------------------------------------------

Arik Nemtsov (8):
      wlcore: suppress error message on Rx BA session removal
      wlcore: allow setting sleep_auth before interface init
      wlcore: reconfigure sleep_auth when removing interfaces
      wl18xx: increase Rx descriptors for PG2
      wl18xx: set Tx align quirk for PG2
      wl18xx: explicitly remove the 5Ghz MIMO HT cap
      wl18xx: sane defaults for HT capabilities
      wl18xx: split siso40 HT cap between 2Ghz and 5Ghz

Eliad Peller (2):
      wlcore: update basic rates on channel switch
      wlcore: declare interface combinations

Eyal Shapira (2):
      wlcore: avoid using NET_IP_ALIGN for RX alignment
      wlcore: send EAPOLs with basic rate policy

Igal Chernobelsky (1):
      wlcore: read FW logs from FW memory on watchdog recovery

Luciano Coelho (3):
      wlcore: add a debugfs entry to allow changing the sleep mode by hand
      wl18xx: use %zu for size_t arguments in printk calls
      Merge branch 'wl12xx-next' into for-linville

Yair Shapira (2):
      wlcore/wl12xx: add support for HP and SKW FEM radio manufacturers
      wlcore: add print logs of radio_status in case of BIP calibration

Yoni Divinsky (1):
      wlcore: do not report noise level in get survey op

 drivers/net/wireless/ti/wl12xx/cmd.c      |   16 +++++----
 drivers/net/wireless/ti/wl12xx/main.c     |    7 ++--
 drivers/net/wireless/ti/wl18xx/main.c     |  105 +++++++++++++++++++++++++=
+++++++++--------------------------
 drivers/net/wireless/ti/wlcore/acx.c      |    8 ++++-
 drivers/net/wireless/ti/wlcore/acx.h      |    5 +++
 drivers/net/wireless/ti/wlcore/cmd.h      |   21 ++++++++++++
 drivers/net/wireless/ti/wlcore/conf.h     |    8 ++++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |   63 +++++++++++++++++++++++++=
+++++++++++
 drivers/net/wireless/ti/wlcore/ini.h      |   22 ++++++++++---
 drivers/net/wireless/ti/wlcore/init.c     |   43 ++++++++++++-------------
 drivers/net/wireless/ti/wlcore/main.c     |   97 +++++++++++++++++++++++++=
+++++++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/ps.c       |    2 +-
 drivers/net/wireless/ti/wlcore/rx.c       |    4 +--
 drivers/net/wireless/ti/wlcore/rx.h       |    6 ++++
 drivers/net/wireless/ti/wlcore/testmode.c |   14 ++++++++
 drivers/net/wireless/ti/wlcore/tx.c       |   10 ++++--
 drivers/net/wireless/ti/wlcore/wlcore.h   |   10 ++++++
 17 files changed, 332 insertions(+), 109 deletions(-)

--=20
Cheers,
Luca.

--=-IU9bs+2JbZK1eyvnkjVe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP43SDAAoJEKFHnKIaPMX6E1wP/2Sk+szJ+5j5Ffg5mf361sKm
ZRQrNrevQNnZL0bVF7i87Y9v3nxWafwuggxnJXAjs77CzAs3tu5teY52rBH+FaR6
IqaEYULqWQi2yXOksO1GDPbaK4A+AhGaAD97uE50CX98WyTSpnpDtkLEYjFGm2au
OGrDXF41B9N3U2afmUfMEyObt5RWOGEmsBjMmCvqkGY9eXFkg6NXgCra4GnINqVI
Cnb9/WQo+V/1F7O20P6R0//fQPjS0RycsV8WHb3z3m+e35CPCuUUr414dnbkQd/G
mNeoLKE2usEwz+n+BlP3dtGEnbsHTaXOEDQ4K7xvNFOdX7beiDW21vaGmegJHXI5
/jbMs0zuZuPKQ+1PNZpzOqODfRi82bo6kPhaN94WTSFQbuBQT6YY7wE1S9S9StvL
ufmR0HLwJy/ihJGYoCRu5NM/Krfuj73TKxVTGt/OTf2E/ZW2vXpZxB44fKplvRkX
QXoM9Qc542oZ4QTOvrR3nUQC+PP0Bmub+vdy+KhIAbHsPxIFLW1O2Z7bbj50JWbn
d+S1arrSGwarFlxip+0JQUKXOizuC8KaWzrbf8Yl/DSdu1ZLmtdXdCQpvH9zmU1v
K5WXn9Ii1JEhD/YZ/C9lsICa2ln+3ukhi1YJyurrlpOw5yEj1sOcRePXLRSTDQmw
ns1ZqNHy0guxin+D0EEI
=ma+O
-----END PGP SIGNATURE-----

--=-IU9bs+2JbZK1eyvnkjVe--


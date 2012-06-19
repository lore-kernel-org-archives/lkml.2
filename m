Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2FSDhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:37:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45806 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2FSDhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:37:12 -0400
Date: Tue, 19 Jun 2012 00:37:06 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-06-19
Message-ID: <20120619033706.GF1679@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,=20

Five fixed to 3.5. There 2 new usb devices id commits, one driver fix and t=
wo
other fixes for the core, one for L2CAP and other in MGMT interface.

Please pull, or let me know of any problems. Thanks :)

	Gustavo

---
The following changes since commit 1c2e004183178e1947882cd2e74f37826f45230e:

  Bluetooth: Add support for encryption key refresh (2012-06-08 21:00:40 -0=
300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-ups=
tream

for you to fetch changes up to ea1e76a3f92f8565d395c549b9ca836c7eaa44b9:

  Bluetooth: btmrvl: Do not send vendor events to bluetooth stack (2012-06-=
19 00:19:11 -0300)

----------------------------------------------------------------
Andrei Emeltchenko (1):
      Bluetooth: btmrvl: Do not send vendor events to bluetooth stack

Giancarlo Formicuccia (1):
      Bluetooth: add support for atheros 0930:0219

Marek Vasut (1):
      Bluetooth: Support AR3011 in Acer Iconia Tab W500

Szymon Janc (1):
      Bluetooth: Fix using uninitialized option in RFCMode

Vishal Agarwal (1):
      Bluetooth: Fix sending HCI_Disconnect only when connected

 drivers/bluetooth/ath3k.c       |    3 +++
 drivers/bluetooth/btmrvl_drv.h  |    2 +-
 drivers/bluetooth/btmrvl_main.c |   14 ++++++++++++--
 drivers/bluetooth/btmrvl_sdio.c |    8 +++++---
 drivers/bluetooth/btusb.c       |    2 ++
 net/bluetooth/l2cap_core.c      |   14 ++++++++------
 net/bluetooth/mgmt.c            |    2 +-
 7 files changed, 32 insertions(+), 13 deletions(-)


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3/PiAAoJEPs3PUX4s20oLNkQAJyLAnJ/C/I7SEuNLxzRTudi
xaG80sTMxGJuR22wqJ9heyClUh+ND1uQjL6Pn2tfIla7SccyCsihtQqMtiSlwvli
VgGY0i/qPquURdIbLDNQbEr519ddOfp5LpVFK4Rn2s+55RE23z5eF80b17Gn2Q1c
XlRSXDyn5WvX2xa86cXcvqbLPbVkgFxU+Q4/jUFIILL56geOOZxuM71quL4NHBw2
7GtzYZBB3cKElr9Y7L1kPrRhCUHMBHIa0Am1DfjoHC4mmtJfnvcBryaMWYBRQIMH
XOaL2luAysRbxXP2N31RjLQoYCK25z5W3m+ZcqbpZdxpvR8l2BDya8EGzAYl0+nP
QMGoMGdT35BR8mMSoJBlL3p480TDqH/AmM03qAAfIlDO2kxd6rF+heI+LZFJhSfW
oUzXfmAakUxaHGh5O2y1+4ABbxU3okTK2vpm4D1q7BVpkf56gUVFMgWSMxSmPu7i
OxifqGhIiwBKRURwPjb0N5eCxpql2KfdO9ztOfBd9HWv8YciX/WK3wYwEueEeVM1
OXFNDW3VFH6mJICwMy8jQoKHV8PQ9Ka3i+htruTBtMz5srT6BZcLYtvEYQWDdHQU
AAygNHOlr1sRq0nZBEh6TJcPGV9epnr513S/Oc7osJ4NfSxnh5jTU5C88wWv1jvV
OJbk33m3afJCEf/vLwsr
=2+u+
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

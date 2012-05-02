Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2EBWte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:49:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59166 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2EBWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:49:32 -0400
Date: Wed, 2 May 2012 19:49:25 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-05-02
Message-ID: <20120502222749.GD16030@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Another set of changes to the 3.5 kernel. The main changes here are in the =
LE
code, by Andre Guedes and in the L2CAP ERTM implementation by Mat Martineau.
The rest of the patches are just clean up and small fixes.

Please pull!=20

	Gustavo

---

The following changes since commit 11069ef318f92fb5960ebd7f9c01e5bc0dcb63fc:

  mac80211: don't transmit 40MHz frames to 20MHz peer (2012-04-27 16:07:24 =
-0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to 6bed2e71fa55572b6e1355594a119e54b20eb426:

  bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C (2012-05-02=
 18:13:29 -0300)

----------------------------------------------------------------
Amitkumar Karwar (1):
      Bluetooth: btmrvl: configure default host sleep parameters

Andre Guedes (9):
      Bluetooth: Remove useless code in hci_connect
      Bluetooth: Move address type macros to bluetooth.h
      Bluetooth: Rename link_to_mgmt to link_to_bdaddr
      Bluetooth: Rename mgmt_to_le to bdaddr_to_le
      Bluetooth: Add address type to struct sockaddr_l2
      Bluetooth: Move bdaddr_to_le to hci_core
      Bluetooth: Add dst_type parameter to hci_connect
      Bluetooth: Use address type info from user-space
      Bluetooth: Remove advertising cache

Gustavo Padovan (1):
      Bluetooth: Remove unneeded elements from size calculation

Johan Hedberg (1):
      Bluetooth: Fix Inquiry with RSSI event mask

Mat Martineau (8):
      Bluetooth: Improve ERTM sequence number offset calculation
      Bluetooth: Remove duplicate structure members from bt_skb_cb
      Bluetooth: Move recently-added ERTM header packing functions
      Bluetooth: Move recently-added ERTM header unpacking functions
      Bluetooth: Initialize new l2cap_chan structure members
      Bluetooth: Remove unused function
      Bluetooth: Make better use of l2cap_chan reference counting
      Bluetooth: Add Code Aurora Forum copyright

Michael Gruetzner (1):
      bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

Syam Sidhardhan (1):
      Bluetooth: Remove unused hci_le_ltk_reply()

Vishal Agarwal (1):
      Bluetooth: Fix EIR data generation for mgmt_device_found

 drivers/bluetooth/ath3k.c         |    6 +
 drivers/bluetooth/btmrvl_drv.h    |    1 +
 drivers/bluetooth/btmrvl_main.c   |   53 ++++---
 drivers/bluetooth/btmrvl_sdio.c   |    3 +
 drivers/bluetooth/btusb.c         |    3 +
 include/net/bluetooth/bluetooth.h |    8 +-
 include/net/bluetooth/hci_core.h  |   47 ++++---
 include/net/bluetooth/l2cap.h     |   14 +-
 net/bluetooth/hci_conn.c          |   30 +---
 net/bluetooth/hci_core.c          |   86 ++----------
 net/bluetooth/hci_event.c         |   13 +-
 net/bluetooth/l2cap_core.c        |  294 ++++++++++++++++++++-------------=
------
 net/bluetooth/l2cap_sock.c        |    5 +-
 net/bluetooth/mgmt.c              |   78 +++++------
 net/bluetooth/sco.c               |    3 +-
 15 files changed, 289 insertions(+), 355 deletions(-)

--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPobn1AAoJEPs3PUX4s20oD+EQAIKEdbkeQjl9tfv9mtynmE3O
NLqzeLswpGqOuMPuM4yaH4Lb5KdM+NLNyQUSMz1XCDGgGmd2rhixUCATsmKZXG6b
KpHPl77pdKO0wfhJGkk9N+S/wop5v+exUI7dC+rB+7TSNIX78zRrh+hFTDXEqwKz
8Rel3RH3tk9BlzhlPyinCFy443BxufKfPm562+1klfLfiOoWXwgFG1ryVyWTO3oZ
CpXmDGCSfEQvBDmF/8bKSO5chmiBen7gO824sqiWpqdpxvZTsiwuGO/aClikNJZN
dJeuTxaTxT1cyouvAcL2tMlOr2q/wtYMZGgkP5tZi1migu0A2dKSJI2wJSfaG5fN
14bR4gFKfqMTQLKQMUado4k1uVh+AhlwDLs4R66hrk4S7hJRyCZZmrjmRZX+WPQm
P2l3eXLSzrsGkZcE8JpKEWuA3awYC4+hERx4Hx5xBvh+9wBJZCgZu5nLIMWY+iZx
3ErDL8Nr1ddXfvHGAVyzc+ECYLsrQ1orTJHEw+wJxwOnbnF6SqvHYOW5SXMppOuN
8wdW8YNEI8sB5XG3oMYdQEOT3eFtDSdj9jsIq+E6w9NzR45lv6rzjTXsTPO4lHr5
9IH+h380yB2WA5AU3lEiXGwBL1yQnB/7FFM9Zr3TyB0yO7QY9cMlCfObWMxnxCEU
Q+HF+Bp5pXcnKHVHwZmV
=2AA6
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--

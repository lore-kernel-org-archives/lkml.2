Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2ISBbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:31:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47435 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2ISBbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:31:20 -0400
Date: Tue, 18 Sep 2012 22:31:13 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-09-18
Message-ID: <20120919013113.GG24689@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

My last pull request to 3.7. There is nothin really exciting here.
The biggest stuff is hci_connect() code re-write, the rest is just bugfixes,
clean up and small improvements.=20

Please pull!

	Gustavo

---
The following changes since commit 22c5649eef0fc37532e20c14d2656b28ca708a69:

  p54: fix powerpc gcc warnings (2012-08-13 15:28:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next ma=
ster

for you to fetch changes up to 3c860f3d3cd75f0e1a33ba6eb9f96bdb2194ec41:

  Bluetooth: Add support for BCM20702A0 [04ca, 2003] (2012-09-18 21:22:39 -=
0300)

----------------------------------------------------------------
Andrei Emeltchenko (7):
      Bluetooth: trivial: Shorten variable scope
      Bluetooth: trivial: Use preferred method for NULL check
      Bluetooth: Remove unneeded zero init
      Bluetooth: trivial: Make hci_chan_del return void
      Bluetooth: trivial: Remove empty line
      Bluetooth: debug: Print refcnt for hci_dev
      Bluetooth: AMP: Add Read Data Block Size to amp_init

Gustavo Padovan (1):
      Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn

Jaroslav Resler (1):
      Bluetooth: Add support for BCM20702A0 [04ca, 2003]

Johan Hedberg (2):
      Bluetooth: mgmt: Implement support for passkey notification
      Bluetooth: Update management interface revision

Mikel Astiz (3):
      Bluetooth: Add more HCI error codes
      Bluetooth: Fix minor coding style in hci_event.c
      Bluetooth: mgmt: Add device disconnect reason

Peter Senna Tschudin (5):
      drivers/bluetooth/bluecard_cs.c: removes unnecessary semicolon
      drivers/bluetooth/hci_ldisc.c: removes unnecessary semicolon
      drivers/bluetooth/hci_ll.c: removes unnecessary semicolon
      drivers/bluetooth/hci_vhci.c: removes unnecessary semicolon
      drivers/bluetooth/btuart_cs.c: removes unnecessary semicolon

Sachin Kamat (1):
      Bluetooth: Use module_platform_driver() in btwilink.c file

Syam Sidhardhan (2):
      Bluetooth: debug: Correct the PSM printing
      Bluetooth: Use kref for l2cap channel reference counting

Vinicius Costa Gomes (8):
      Bluetooth: Remove some functions from being exported
      Bluetooth: Rename LE and ACL connection functions
      Bluetooth: Refactor LE connection into its own function
      Bluetooth: Refactor ACL connection into its own function
      Bluetooth: Refactor SCO connection into its own function
      Bluetooth: Simplify a the connection type handling
      Bluetooth: Add type information to the hci_connect() debug statement
      Bluetooth: Fix establishing ESCO links

Wei Yongjun (1):
      Bluetooth: btmrvl: remove pointless conditional before kfree_skb()

 drivers/bluetooth/bluecard_cs.c  |   2 +-
 drivers/bluetooth/btmrvl_sdio.c  |   3 +-
 drivers/bluetooth/btuart_cs.c    |   2 +-
 drivers/bluetooth/btusb.c        |   3 +-
 drivers/bluetooth/btwilink.c     |  16 +------
 drivers/bluetooth/hci_ldisc.c    |   2 +-
 drivers/bluetooth/hci_ll.c       |   2 +-
 drivers/bluetooth/hci_vhci.c     |   2 +-
 include/net/bluetooth/hci.h      |  21 +++++++++
 include/net/bluetooth/hci_core.h |  26 +++++------
 include/net/bluetooth/l2cap.h    |   3 +-
 include/net/bluetooth/mgmt.h     |  16 +++++++
 net/bluetooth/af_bluetooth.c     |  10 ++---
 net/bluetooth/hci_conn.c         | 100 +++++++++++++++++++++++++----------=
------
 net/bluetooth/hci_core.c         |   6 ++-
 net/bluetooth/hci_event.c        |  99 +++++++++++++++++++++++++++++++++++=
++---
 net/bluetooth/l2cap_core.c       |  17 +++----
 net/bluetooth/mgmt.c             |  28 +++++++++---
 18 files changed, 255 insertions(+), 103 deletions(-)

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWSBgAAoJEPs3PUX4s20oSPQP/ipur+/nO52XNNwEg+JZZSE5
Oa05R2FX237TyqUHTJ58IESNdwfQBcW0xkjWT/EiwtLj1qRa8A2UsSYB22GYVfzN
vzv1gzlz9NDj9EFw1TXkq7gUVUGXt44EjV+2Wmr0GAYueEyNouR/HFIcNOQczlUn
TmAa5/EVrUCa7m9cPvjd2/N9TAPs37QR8bI0S7Lvs+dw741Q8TD8h2CPAlhPfH3x
M2Ue2iH+ZLcL3WBch+DAjdY3dmlQlMx7G0UEmz+ijZ6F2P8WQhAR7jTk2IP+95ns
2hJhWoONU1EycKPFPos0H1eXrLu8MJanxAaJw/c4dqp00VNrI3Q2Rf8c9TUk7tEK
xJst4oU0S81F81KZdpbxWN8MhU4j1ZIwXu+t1yoT2jpwB3InegueIFV5ng7Y+Vf8
BcDX7dFABvi4MjO3BByrdV7kJMP+/bMdt5lKkP1Y0ZLNylEVr+O8Z2SdXDpuzH+m
TDi1DE+bc56LydWsmjseVx5IKJvdwjS4cprll3rGG7lWmMZ8Ozvoevfce2tIDXGe
8QO+t0oEWWJw2Jh/sJrpsa3CvVVH2syaB+yVgbW6QDVfxZQV1NKgC8DUfYwt8lYN
cpw39tFlPGzCX9o9Qe7+JE8m6BOfdI1LlpIbxgpzKpnbd4pUCDlk+gNVsaqmNFWz
tMvMnTJa6ZkaED7zRBKe
=m+av
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--

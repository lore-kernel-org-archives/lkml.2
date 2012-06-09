Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2FIW03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 18:26:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61172 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2FIW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 18:26:27 -0400
Date: Sat, 9 Jun 2012 19:26:21 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-06-10
Message-ID: <20120609222621.GB1458@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Here goes the first Bluetooth pull request for 3.6, we have queued quite a
lot of work. Andrei Emeltchenko added the AMP Manager code, a lot of work is
needed, but the first bit are already there. This code is disabled by defau=
lt.
Mat Martineau changed the whole L2CAP ERTM state machine code, replacing the
old one with a new implementation. Besides that we had lot of coding style
fixes (to follow net rules), more l2cap core separation from socket and many
clean ups and fixed all over the tree.

Please pull, or let me know of any problems. Thanks.

	Gustavo

---

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream=20

for you to fetch changes up to 1d0c4da8f717937aeda47a72bc769d80f8776795:

  Bluetooth: Fix style in hidp code (2012-06-09 19:22:42 -0300)

----------------------------------------------------------------
Andre Guedes (4):
      Bluetooth: Change default MTU for L2CAP ATT channel
      Bluetooth: Check MTU value in l2cap_sock_setsockopt_old
      Bluetooth: Rename L2CAP_LE_DEFAULT_MTU
      Bluetooth: Filter duplicated reports in LE scan

Andrei Emeltchenko (35):
      Bluetooth: Silent sparse warnings
      Bluetooth: Use defined link key size
      Bluetooth: Preserve L2CAP flags values
      Bluetooth: trivial: Remove empty line
      Bluetooth: Define L2CAP conf continuation flag
      Bluetooth: Define and use PSM identifiers
      Bluetooth: Use __constant when dealing with constants
      Bluetooth: Use __constant modifier in HCI code
      Bluetooth: Define HCI AMP cmd struct
      Bluetooth: Move clean up code and set of SOCK_ZAPPED to l2cap_sock.c
      Bluetooth: Add l2cap_chan->ops->ready()
      Bluetooth: trivial: Use defined PSMLEN instead of magic
      Bluetooth: A2MP: Create A2MP channel
      Bluetooth: A2MP: AMP Manager basic functions
      Bluetooth: A2MP: Build and Send msg helpers
      Bluetooth: A2MP: Add chan callbacks
      Bluetooth: A2MP: Definitions for A2MP commands
      Bluetooth: A2MP: Define A2MP status codes
      Bluetooth: A2MP: Process A2MP messages
      Bluetooth: A2MP: Process A2MP Command Reject
      Bluetooth: A2MP: Process A2MP Discover Request
      Bluetooth: A2MP: Process A2MP Change Notify
      Bluetooth: A2MP: Process A2MP Get Info Request
      Bluetooth: A2MP: Process A2MP Get AMP Assoc Request
      Bluetooth: A2MP: Process A2MP Create Physlink Request
      Bluetooth: A2MP: Process A2MP Disc Physlink Request
      Bluetooth: A2MP: Process A2MP Command Responses
      Bluetooth: A2MP: Handling fixed channels
      Bluetooth: A2MP: Manage incoming connections
      Bluetooth: Do not check func ready existence
      Bluetooth: A2MP: Do not reference hci_conn
      Bluetooth: Make l2cap_data_channel return void
      Bluetooth: Make l2cap_conless_channel return void
      Bluetooth: Make l2cap_att_channel return void
      Bluetooth: Remove magic disconnect reason

Andrzej Kaczmarek (3):
      Bluetooth: Allow only one LE connection attempt
      Bluetooth: Return proper mgmt state when LE pairing connection failed
      Bluetooth: Fix not removing hci_conn for failed LE connection

Bing Zhao (1):
      Bluetooth: btmrvl: add SD8787 Bluetooth AMP device ID

Gustavo Padovan (29):
      Bluetooth: Fix coding style in mgmt.c
      Bluetooth: Fix coding style in sco.c
      Bluetooth: Fix coding style in hci_sock.c
      Bluetooth: Fix coding style in hci_sysfs.c
      Bluetooth: Fix coding style in hci_event.c
      Bluetooth: Fix coding style in hci_conn.c
      Bluetooth: Fix coding style in hci_core.c
      Bluetooth: Do not purge queue in Basic Mode
      Bluetooth: Remove double check for BT_CONNECTED
      Bluetooth: Remove dead int returns
      Bluetooth: Fix trailing whitespaces in license text
      Bluetooth: Remove most of the inline usage
      Bluetooth: Remove 'register' usage from the subsystem
      Bluetooth: Fix coding style in include/net/bluetooth
      Bluetooth: Fix coding style in the subsystem
      Bluetooth: Remove unnecessary headers include
      Bluetooth: Remove unneeded EXPORT_SYMBOL
      Bluetooth: Use lmp_ssp_capable() macro
      Bluetooth: Get a more accurate L2CAP PDU len
      Bluetooth: Remove extra l2cap_state_change(BT_CONNECTED)
      Bluetooth: Use l2cap_chan_ready() in LE path
      Bluetooth: Use chan as parameters for l2cap chan ops
      Bluetooth: Use chan->state instead of sk->sk_state
      Bluetooth: Move check for backlog size to l2cap_sock.c
      Bluetooth: check for already existent channel before create new one
      Bluetooth: Create function to return the ERTM header size
      Bluetooth: Remove unused err var from l2cap_segment_sdu()
      Bluetooth: Create empty l2cap ops function
      Bluetooth: Fix style in hidp code

Mat Martineau (28):
      Bluetooth: Free allocated ERTM SREJ list if init fails
      Bluetooth: Fix early return from l2cap_chan_del
      Bluetooth: Change default state of ERTM disable flag
      Bluetooth: Add a new L2CAP ERTM transmit state machine.
      Bluetooth: Refactor l2cap_streaming_send
      Bluetooth: Refactor l2cap_ertm_send
      Bluetooth: Refactor l2cap_send_sframe
      Bluetooth: Consolidate common receive code for ERTM and streaming mode
      Bluetooth: Add streaming mode receive and incoming packet classifier
      Bluetooth: Remove receive code that has been superceded
      Bluetooth: Refactor l2cap_send_ack
      Bluetooth: Use the transmit state machine for busy state changes
      Bluetooth: Update l2cap_send_i_or_rr_or_rnr to fit the spec better
      Bluetooth: Add the ERTM receive state machine
      Bluetooth: Add implementation for retransmitting all unacked frames
      Bluetooth: Send SREJ frames when packets go missing
      Bluetooth: Reassemble all available data when retransmissions succeed.
      Bluetooth: Handle SREJ requests to resend unacked frames
      Bluetooth: Handle incoming REJ frames
      Bluetooth: Use new header structures in l2cap_send_rr_or_rnr
      Bluetooth: Check rules when setting retransmit or monitor timers
      Bluetooth: Use the ERTM transmit state machine from timeout handlers
      Bluetooth: Simplify the ERTM ack timeout
      Bluetooth: Remove unneccesary inline
      Bluetooth: Set txwin values for streaming mode
      Bluetooth: Remove unused ERTM control field macros
      Bluetooth: Enable ERTM by default
      Bluetooth: Send a configuration request after security confirmation

Sasha Levin (1):
      Bluetooth: Really fix registering hci with duplicate name

Szymon Janc (2):
      Bluetooth: Rename HCI_QUIRK_NO_RESET to HCI_QUIRK_RESET_ON_CLOSE
      Bluetooth: Remove unused HCI timeouts definitions

Vinicius Costa Gomes (1):
      Bluetooth: Fix checking the wrong flag when accepting a socket

 drivers/bluetooth/bluecard_cs.c   |   10 +-
 drivers/bluetooth/bpa10x.c        |    2 +-
 drivers/bluetooth/bt3c_cs.c       |    4 +-
 drivers/bluetooth/btmrvl_sdio.c   |    3 +
 drivers/bluetooth/btuart_cs.c     |    4 +-
 drivers/bluetooth/btusb.c         |   14 +-
 drivers/bluetooth/dtl1_cs.c       |    4 +-
 drivers/bluetooth/hci_bcsp.c      |    2 +-
 drivers/bluetooth/hci_h4.c        |    2 +-
 drivers/bluetooth/hci_ldisc.c     |    2 +-
 drivers/bluetooth/hci_ll.c        |    6 +-
 include/net/bluetooth/a2mp.h      |  126 +++
 include/net/bluetooth/bluetooth.h |   39 +-
 include/net/bluetooth/hci.h       |   99 +-
 include/net/bluetooth/hci_core.h  |   29 +-
 include/net/bluetooth/l2cap.h     |  205 +---
 net/bluetooth/Makefile            |    3 +-
 net/bluetooth/a2mp.c              |  568 +++++++++++
 net/bluetooth/af_bluetooth.c      |   16 +-
 net/bluetooth/bnep/core.c         |   21 +-
 net/bluetooth/bnep/netdev.c       |   16 +-
 net/bluetooth/bnep/sock.c         |   18 +-
 net/bluetooth/hci_conn.c          |   98 +-
 net/bluetooth/hci_core.c          |  214 ++--
 net/bluetooth/hci_event.c         |  309 +++---
 net/bluetooth/hci_sock.c          |   59 +-
 net/bluetooth/hci_sysfs.c         |   99 +-
 net/bluetooth/hidp/core.c         |   26 +-
 net/bluetooth/hidp/sock.c         |   16 +-
 net/bluetooth/l2cap_core.c        | 2125 ++++++++++++++++++++++++---------=
------
 net/bluetooth/l2cap_sock.c        |  130 ++-
 net/bluetooth/lib.c               |    7 +-
 net/bluetooth/mgmt.c              |   71 +-
 net/bluetooth/rfcomm/core.c       |   32 +-
 net/bluetooth/rfcomm/sock.c       |   21 +-
 net/bluetooth/rfcomm/tty.c        |    9 +-
 net/bluetooth/sco.c               |   43 +-
 net/bluetooth/smp.c               |    7 +-
 38 files changed, 2775 insertions(+), 1684 deletions(-)
 create mode 100644 include/net/bluetooth/a2mp.h
 create mode 100644 net/bluetooth/a2mp.c



--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP082NAAoJEPs3PUX4s20ofkEQAJBl5gt6ffECIetNPzXvr16T
idjmFKXLg11FhbExIDEJ8d2iyfzV5C9TK22lGI+vSG7/o2qkykWiYDDZUK3AXCxQ
mGMjQajqkMuAfoxGawTFy7vvqti3Bif+Oz4H/gzlxBZC+9wiun0GksG4U1DeaIQ/
8r9LNoHFjxpRI2o7hU+LJNkNIXy/OYCurNelRJ/4YD9qxaGQd+zrDWmfcEKMxZpo
mhtxRGhK6Q/TrLz/MM5ZSmAZGQa/2ap5boQQAWdjYMXO6Hq4gaCkXRikNI3JL3tS
bo2ZR43CqNcOJbREMQMzUKQkuVBlMGoLO57yP3aTIdVWgq/gdnN9eUOlP7l9dpCw
SDWuaA//TwZQT6AI7sHd0w7AgodU92nLyKNaho9fpCmeh0k6XScNagCG+3JIQFbv
cDGaZ932yly5b8q5GoHjXf5EsH9GZE+4/QOOBG9j4MMTL4Z/MwLXf4VprzuQqHpD
O0RxF8RNrqTw5onLk3h1LgdnBLGu7aLEsqABlcE2PHfVTF9uIGyVgxpmUMzOXBPR
o/dg6jr9pJGnz3ZxrhPrTY88IpFUvbkuxCckeBJKO430UPxIJJMWOk4JuF9xu6bp
2xrAc7LBArIe6AVOTXyxQp4ujzf6alaah9UsKJfxlsb2LTh7irTGjC1Dk4NqVa4O
KpAr2Q+EI9HyW4Urs8rQ
=Nfwz
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--

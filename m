Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2JRWAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:00:23 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:50768 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2JRWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:00:20 -0400
Date: Thu, 18 Oct 2012 19:00:13 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-10-18
Message-ID: <20121018220013.GA7833@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

These are the Bluetooth bits for inclusion in 3.8, there is basically one big
thing here which is the High Speed patches from Andrei, he did a lot of work on
A2MP and management of AMP devices. The rest are mostly clean up and bug
fixes.

Please pull or let me know any concerns you have! Thanks.

	Gustavo
---

The following changes since commit 90e6274d2ecf3bcb44e3727a395e56b7ef467218:

  ath5k: disable HW crypto in management frame (2012-09-24 15:02:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next master

for you to fetch changes up to f706adfeade767d2194c9f39c0f75e944b0bdd23:

  Bluetooth: AMP: Get amp_mgr reference in HS hci_conn (2012-10-18 07:27:20 -0300)

----------------------------------------------------------------
Andrei Emeltchenko (50):
      Bluetooth: Add HCI logical link cmds definitions
      Bluetooth: A2MP: Create amp_mgr global list
      Bluetooth: AMP: Use HCI cmd to Read AMP Info
      Bluetooth: AMP: Use HCI cmd to Read Loc AMP Assoc
      Bluetooth: A2MP: Process Discover Response
      Bluetooth: AMP: Physical link struct and helpers
      Bluetooth: AMP: Remote AMP ctrl definitions
      Bluetooth: AMP: Handle create / disc phylink req
      Bluetooth: A2MP: Process A2MP Getinfo Rsp
      Bluetooth: A2MP: Process A2MP Get AMP Assoc Rsp
      Bluetooth: Choose connection based on capabilities
      Bluetooth: AMP: Add AMP key calculation
      Bluetooth: AMP: Create Physical Link
      Bluetooth: AMP: Write remote AMP Assoc
      Bluetooth: A2MP: Add fallback to normal l2cap init sequence
      Bluetooth: AMP: Process Chan Selected event
      Bluetooth: AMP: Accept Physical Link
      Bluetooth: AMP: Handle Accept phylink command status evt
      Bluetooth: Use %pMR in debug instead of batostr
      Bluetooth: Use %pMR in sprintf/seq_printf instead of batostr
      Bluetooth: Use %pMR instead of baswap in seq_show
      bluetooth: Remove unneeded batostr function
      Bluetooth: Factor out hci_queue_acl
      Bluetooth: Factor out Create Configuration Response
      Bluetooth: Use %zu print specifier for size_t type
      Bluetooth: A2MP: Correct assoc_len size
      Bluetooth: btmrvl: Correct num_block name
      Bluetooth: btmrvl: Use DIV_ROUND_UP macro
      Bluetooth: btmrvl: Fix skb buffer overflow
      Bluetooth: A2MP: Fix potential NULL dereference
      Bluetooth: AMP: Fix possible NULL dereference
      Bluetooth: Fix dereference after NULL check
      Bluetooth: AMP: Factor out amp_ctrl_add
      Bluetooth: AMP: Factor out phylink_add
      Bluetooth: AMP: Use block_mtu for AMP controller
      Bluetooth: Adjust L2CAP Max PDU size for AMP packets
      Bluetooth: L2CAP: Fix using default Flush Timeout for EFS
      Bluetooth: btmrv: Use %*ph specifier instead of print_hex_dump_bytes
      Bluetooth: Allow to set flush timeout
      Bluetooth: AMP: Handle AMP_LINK timeout
      Bluetooth: AMP: Add handle to hci_chan structure
      Bluetooth: AMP: Handle number of compl blocks for AMP_LINK
      Bluetooth: AMP: Handle AMP_LINK connection
      Bluetooth: AMP: Hanlde AMP_LINK case in conn_put
      Bluetooth: AMP: Use Loglink handle in ACL Handle field
      Bluetooth: AMP: Handle complete frames in l2cap
      Bluetooth: AMP: Drop packets when no l2cap conn exist
      Bluetooth: Send EFS Conf Rsp only for BR/EDR chan
      Bluetooth: Zero bredr pointer when chan is deleted
      Bluetooth: AMP: Get amp_mgr reference in HS hci_conn

Dmitry Kasatkin (1):
      Bluetooth: Add function to derive AMP key using hmac

Gustavo Padovan (9):
      Bluetooth: Fix two warnings in BT_DBG
      Bluetooth: Fix L2CAP coding style
      Bluetooth: Remove GFP_ATOMIC usage from l2cap_core.c
      Bluetooth: use l2cap_chan_set_err()
      Bluetooth: Use locked l2cap_state_change()
      Bluetooth: Call ops->teardown() without checking for NULL
      Bluetooth: Move bt_accept_enqueue() to l2cap_sock.c
      Bluetooth: Add chan->ops->defer()
      Bluetooth: Rename __l2cap_connect() to l2cap_connect()

Jefferson Delfes (1):
      Bluetooth: Force the process of unpair command if disconnect failed

Mat Martineau (2):
      Bluetooth: Process create response and connect response identically
      Bluetooth: Factor out common L2CAP connection code

Rami Rosen (1):
      Bluetooth: remove unused member of hci_dev.

Sasha Levin (1):
      Bluetooth: don't attempt to free a channel that wasn't created

Syam Sidhardhan (2):
      Bluetooth: Use __constant modifier for L2CAP SMP CID
      Bluetooth: Use __constant modifier for RFCOMM PSM

 drivers/bluetooth/btmrvl_sdio.c   |  28 ++-
 include/net/bluetooth/a2mp.h      |  24 +-
 include/net/bluetooth/amp.h       |  50 ++++
 include/net/bluetooth/bluetooth.h |   1 -
 include/net/bluetooth/hci.h       |  40 +++-
 include/net/bluetooth/hci_core.h  |  48 +++-
 include/net/bluetooth/l2cap.h     |  14 +-
 net/bluetooth/Kconfig             |   1 +
 net/bluetooth/Makefile            |   2 +-
 net/bluetooth/a2mp.c              | 459 +++++++++++++++++++++++++++++++++---
 net/bluetooth/af_bluetooth.c      |  10 +-
 net/bluetooth/amp.c               | 374 +++++++++++++++++++++++++++++
 net/bluetooth/bnep/core.c         |   3 +-
 net/bluetooth/cmtp/core.c         |   2 +-
 net/bluetooth/hci_conn.c          |  70 +++++-
 net/bluetooth/hci_core.c          |  65 ++++--
 net/bluetooth/hci_event.c         | 167 ++++++++++++-
 net/bluetooth/hci_sysfs.c         |  10 +-
 net/bluetooth/hidp/core.c         |   8 +-
 net/bluetooth/l2cap_core.c        | 503 +++++++++++++++++++++++-----------------
 net/bluetooth/l2cap_sock.c        |  89 ++++---
 net/bluetooth/lib.c               |  14 --
 net/bluetooth/mgmt.c              |   5 +-
 net/bluetooth/rfcomm/core.c       |  19 +-
 net/bluetooth/rfcomm/sock.c       |   9 +-
 net/bluetooth/rfcomm/tty.c        |   6 +-
 net/bluetooth/sco.c               |  12 +-
 net/bluetooth/smp.c               |   2 +-
 28 files changed, 1641 insertions(+), 394 deletions(-)
 create mode 100644 include/net/bluetooth/amp.h
 create mode 100644 net/bluetooth/amp.c


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQgHvtAAoJEPs3PUX4s20oDskP/AmpwJnSXiqRG72HxkCtyf6J
cMeSbuEwR5OUSML4P0Hg2SVn6lZnz65rDt8Dfcz7yDK/TP4nlTK689StXJDYcA/X
A2TzJhZG+BM5QfiNt7LKj8NPR5rjRO0SMutzBuaxvAgn0VpCssM64Pkta+YMr0ct
ZSeVO7VkKxfSqYz5PyMlGY0IqTcpvmiy2ZwrscVaoq8tTTCHgkNyqtN1HoWeSJe2
2rgv6lkmtYU3A+vqAQgElEhjzcRodtjd/Vrqo2ivLmX2SzqlmZj1kQ2hRkfyaz38
dYgv+YKhF1hXRZ1lj5z69fFlNNziY58NRmAiHUxDfQYtIveqIQW+3LfUaVJUphDd
9y6H2MVD0tEFXlYwdayEl33GiPkNwvJbp7FuHTWni1cs/2K7qfiVRfqwjXKuoQlJ
NfJBE3o6yUYf0e0nemPltSeMVg/Y5LX9Nr0EaVhnLk9GCyaooeeoVNfqhgTwOwdF
B8MgbqqPTc7dNHIKAit35LSFKQ26K5HTvaWNie+S/d9LTCE1ojTBXLW6T4Ly3bBh
idrUxoFwekXqcouFJiWnhXnhGRyLlxot4lS8AP6m92SSFQZEOT5liB+9qO6K9h/n
wVnLtr+ROjkiY5YRe8QidSlpmM15DZw0tKe6/FjNjzUR5yjoXJzZv6dF6EgPqmDx
VKAkoQo0xvRwS1v9WB0/
=y25X
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--

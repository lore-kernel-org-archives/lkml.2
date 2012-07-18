Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2GRPXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:23:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36719 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2GRPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:23:18 -0400
Date: Wed, 18 Jul 2012 12:23:07 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-07-18
Message-ID: <20120718152307.GC19582@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This is my last pull towards 3.6, the biggest thing here is the new 3-wire UART
Bluetooth driver by Johan Hedberg. The rest is just fixes and clean ups.

Please pull or let me know of any problems. Thanks!

	Gustavo

---
The following changes since commit ea1e76a3f92f8565d395c549b9ca836c7eaa44b9:

  Bluetooth: btmrvl: Do not send vendor events to bluetooth stack (2012-06-19 00:19:11 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next master

for you to fetch changes up to e0482103c22957b413db4c4ba35eca3b1e99751d:

  Bluetooth: Introduce a flags variable to Three-wire UART state (2012-07-17 14:49:24 -0300)

----------------------------------------------------------------
Andre Guedes (4):
      Bluetooth: Remove magic value in disconnect mgmt handler
      Bluetooth: Use GFP_KERNEL in mgmt_handlers
      Bluetooth: Use GFP_KERNEL in mgmt_pending_add
      Bluetooth: Use GFP_KERNEL in mgmt events functions

Andrei Emeltchenko (20):
      Bluetooth: Use standard HCI cmd timeout for RESET
      Bluetooth: Update HCI timeouts constants to use msecs_to_jiffies
      Bluetooth: Add opcode to error message
      Bluetooth: Correct debug print specifier for u16 objects
      Bluetooth: Fix not setting HCI_RESET flag for AMP
      Bluetooth: Fix compile warnings in mgmt
      Bluetooth: Use AUTO_OFF constant in jiffies
      Bluetooth: Improve debugging messages for hci_conn
      Bluetooth: Fix warning: using int as NULL pointer
      Bluetooth: Route traffic only through BR/EDR controller
      Bluetooth: bluecard_cs: Shorten scope for iobase
      Bluetooth: Do not auto off AMP controller
      Bluetooth: btmrvl: trivial style fixes
      Bluetooth: debug: Add printing num of cmds queued
      Bluetooth: debug: Correct types specifiers for L2CAP
      Bluetooth: debug: Print CID and PSM in hex format
      Bluetooth: debug: Add debug to l2cap_security_cfm
      Bluetooth: debug: Use standard hex object specifiers in hci_event
      Bluetooth: debug: Print l2cap_chan refcount
      Bluetooth: debug: Print amp_mgr refcnt

Devendra Naga (1):
      Bluetooth: cleanup dtl1_config

Gustavo Padovan (2):
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth

Jaganath Kanakkassery (1):
      Bluetooth: Refactor PIN code rejection to use user_pairing_resp()

Jefferson Delfes (1):
      Bluetooth: Fix flags of mgmt_device_found event

Johan Hedberg (19):
      Bluetooth: Change page scan interval in fast connectable mode
      Bluetooth: Initial skeleton for Three-wire UART (H5) support
      Bluetooth: Add basic state tracking to Three-wire UART driver
      Bluetooth: Add initial reliable packet support for Three-wire UART
      Bluetooth: Add basic packet parsing to Three-wire UART driver
      Bluetooth: Add initial packet sending support to Three-wire UART
      Bluetooth: Add Three-wire header value convenience macros
      Bluetooth: Fix/implement Three-wire reliable packet sending
      Bluetooth: Add support for Three-wire Link Control packets
      Bluetooth: Simplify hci_uart_tty_close logic
      Bluetooth: Add delayed init sequence support for UART controllers
      Bluetooth: Use delayed init for Three-wire UART
      Bluetooth: Improve rx debug logs for Three-wire UART
      Bluetooth: Add initial sleep support to Three-wire UART
      Bluetooth: Add initialization tracking to HCI Three-wire driver
      Bluetooth: Implement proper low-power support for Three-wire UART
      Bluetooth: Remove unnecessary h5_build_pkt function
      Bluetooth: Improve Three-wire UART configuration handling
      Bluetooth: Introduce a flags variable to Three-wire UART state

Mat Martineau (1):
      Bluetooth: Use tx window from config response for ack timing

 drivers/bluetooth/Kconfig         |   12 +
 drivers/bluetooth/Makefile        |    1 +
 drivers/bluetooth/bluecard_cs.c   |   16 +-
 drivers/bluetooth/bpa10x.c        |    2 +-
 drivers/bluetooth/bt3c_cs.c       |    6 +-
 drivers/bluetooth/btmrvl_main.c   |    8 +-
 drivers/bluetooth/btmrvl_sdio.c   |    6 +-
 drivers/bluetooth/btuart_cs.c     |    6 +-
 drivers/bluetooth/btusb.c         |   14 +-
 drivers/bluetooth/dtl1_cs.c       |   22 +-
 drivers/bluetooth/hci_bcsp.c      |    2 +-
 drivers/bluetooth/hci_h4.c        |    2 +-
 drivers/bluetooth/hci_h5.c        |  747 +++++++++++++
 drivers/bluetooth/hci_ldisc.c     |   68 +-
 drivers/bluetooth/hci_ll.c        |    6 +-
 drivers/bluetooth/hci_uart.h      |   10 +
 include/net/bluetooth/a2mp.h      |  126 +++
 include/net/bluetooth/bluetooth.h |   39 +-
 include/net/bluetooth/hci.h       |  110 +-
 include/net/bluetooth/hci_core.h  |   37 +-
 include/net/bluetooth/l2cap.h     |  210 +---
 include/net/bluetooth/mgmt.h      |    2 +-
 net/bluetooth/Makefile            |    3 +-
 net/bluetooth/a2mp.c              |  568 ++++++++++
 net/bluetooth/af_bluetooth.c      |   14 +-
 net/bluetooth/bnep/core.c         |   21 +-
 net/bluetooth/bnep/netdev.c       |   16 +-
 net/bluetooth/bnep/sock.c         |   18 +-
 net/bluetooth/hci_conn.c          |  143 ++-
 net/bluetooth/hci_core.c          |  265 +++--
 net/bluetooth/hci_event.c         |  479 ++++-----
 net/bluetooth/hci_sock.c          |   59 +-
 net/bluetooth/hci_sysfs.c         |   99 +-
 net/bluetooth/hidp/core.c         |   26 +-
 net/bluetooth/hidp/sock.c         |   16 +-
 net/bluetooth/l2cap_core.c        | 2248 ++++++++++++++++++++++++---------------
 net/bluetooth/l2cap_sock.c        |  130 ++-
 net/bluetooth/lib.c               |    7 +-
 net/bluetooth/mgmt.c              |  131 ++-
 net/bluetooth/rfcomm/core.c       |   32 +-
 net/bluetooth/rfcomm/sock.c       |   21 +-
 net/bluetooth/rfcomm/tty.c        |    9 +-
 net/bluetooth/sco.c               |   43 +-
 net/bluetooth/smp.c               |    7 +-
 44 files changed, 3868 insertions(+), 1939 deletions(-)
 create mode 100644 drivers/bluetooth/hci_h5.c
 create mode 100644 include/net/bluetooth/a2mp.h
 create mode 100644 net/bluetooth/a2mp.c

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBtTbAAoJEPs3PUX4s20om0QP/irr8kduPL2zhC4bC4fe4vJy
HJu+hjPazfwQGOmwRSjjp5BlXq33NFo+43PgTeq+E4uWVdL7G9fNWU2s5Eeqcy6P
Dp+LxIhyQSyXYWF4WbN0KSNPzkk0VmzHnrTjgwheQtP3OPTd8/hh/InHTQhaexF5
EPkz+l/baCw1J9jjjjgD5JdRdXYWkYFXAbD4W5qCYk0CHjeJK2YfvzgD6Se4criI
7oLSup/81D4xB2B657hPzY3xEmz4QjFOwXo291MJnOE/PbYS7j9rdS1vn57egUDH
TeGCZJj735FZ1kwxoK0I18a5nnBG40fWnd3Vqj41fe/hpsSnKcam5wOS82jqYABB
OvPzUbHG7gYJwbC227wSoPkChVTGJZZa2UEaJV3iJ4Nr5xIO4kGr0AwswGTR00pp
yMlWEqi72mZEFRyoTuufC+4EU/50/oJ4rIqAT/msWmGnwPu19+KyICFwos/uglXn
9vWCx5NSeBQPAGmtrX1yVPyILhvnTxMUGCX89KaO7lpeEsBPvgLM3dOz2VFxHsL4
p/9sdFgV7ojAzT8Bdwcore8LctQESlEb/H6gYQieFYHGILlRrcfnsycJIQTzSYM9
cVyi6GO6p5Mr5a9tTj1PnEFqK4W4a3fNkp0RK1amXW3xpGmaZqgxXZuQC893HJDk
3DAvpRyFxWwwP6IpDUmH
=516v
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2EIEqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:46:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53207 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2EIEqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:46:11 -0400
Date: Wed, 9 May 2012 01:46:05 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-05-09
Message-ID: <20120509044604.GD2362@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A big pull request for inclusion in 3.5. In this set there is some changes
regarding periodic scan and LE, endian fixes, L2CAP ERTM improvements. Ther=
e is
also fixes, clean ups and small improvements all over the tree.

I checked the whole diff of this pull request for offending coding style ch=
anges
and couldn't spot anything wrong.

Please pull, or let me know of any problems!

	Gustavo

---

The following changes since commit 341352d13dae752610342923c53ebe461624ee2c:

  iwlwifi: fix-up some merge damage from commit 0d6c4a2 (2012-05-08 22:18:0=
9 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream=20

for you to fetch changes up to 000092b0b4793caf831f6016fa69d25abba31e51:

  Bluetooth: bnep: use constant for ethertype (2012-05-09 01:40:54 -0300)

----------------------------------------------------------------
Amitkumar Karwar (2):
      Bluetooth: btmrvl: configure default host sleep parameters
      Bluetooth: btmrvl: add support for SDIO suspend/resume callbacks

Andre Guedes (21):
      Bluetooth: Check FINDING state in interleaved discovery
      Bluetooth: Add hci_cancel_le_scan() to hci_core
      Bluetooth: LE support for MGMT stop discovery
      Bluetooth: Replace EPERM by EALREADY in hci_cancel_inquiry
      Bluetooth: Refactor stop_discovery
      Bluetooth: Add Periodic Inquiry command complete handler
      Bluetooth: Add HCI_PERIODIC_INQ to dev_flags
      Bluetooth: Check HCI_PERIODIC_INQ in start_discovery
      Bluetooth: Ignore inquiry results from periodic inquiry
      Bluetooth: Add Periodic Inquiry command complete handler
      Bluetooth: Add HCI_PERIODIC_INQ to dev_flags
      Bluetooth: Remove MGMT_ADDR_INVALID macro
      Bluetooth: Remove useless code in hci_connect
      Bluetooth: Move address type macros to bluetooth.h
      Bluetooth: Rename link_to_mgmt to link_to_bdaddr
      Bluetooth: Add address type to struct sockaddr_l2
      Bluetooth: Rename mgmt_to_le to bdaddr_to_le
      Bluetooth: Move bdaddr_to_le to hci_core
      Bluetooth: Add dst_type parameter to hci_connect
      Bluetooth: Use address type info from user-space
      Bluetooth: Remove advertising cache

Andrei Emeltchenko (24):
      Bluetooth: trivial: Correct endian conversion
      Bluetooth: Correct type for hdev lmp_subver
      Bluetooth: Correct type for ediv to __le16
      Bluetooth: Fix extra conversion to __le32
      Bluetooth: Correct chan->psm endian conversions
      Bluetooth: Correct ediv in SMP
      Bluetooth: Correct length calc in L2CAP conf rsp
      Bluetooth: Correct CID endian notation
      Bluetooth: Convert error codes to le16
      Bluetooth: trivial: Fix endian conversion mode
      Bluetooth: trivial: Correct types
      Bluetooth: Fix type in cpu_to_le conversion
      Bluetooth: Fix opcode access in hci_complete
      Bluetooth: trivial: Remove sparse warnings
      Bluetooth: Silence sparse warning
      Bluetooth: Comments and style fixes
      Bluetooth: Remove unneeded timer clear
      Bluetooth: Make L2CAP chan_add functions static
      Bluetooth: Remove unneeded zero initialization
      Bluetooth: Add Read Local AMP Info to init
      Bluetooth: Adds set_default function in L2CAP setup
      Bluetooth: Fix debug printing unallocated name
      Bluetooth: trivial: Remove empty line
      Bluetooth: Remove unneeded calculation and magic number

David Herrmann (5):
      Bluetooth: Remove redundant hdev->parent field
      Bluetooth: vhci: Ignore return code of nonseekable_open()
      Bluetooth: Move hci_alloc/free_dev close to hci_register/unregister_d=
ev
      Bluetooth: Move device initialization to hci_alloc_dev()
      Bluetooth: Remove unneeded initialization in hci_alloc_dev()

Eldad Zack (1):
      Bluetooth: bnep: use constant for ethertype

Gustavo Padovan (5):
      Bluetooth: Remove sk parameter from l2cap_chan_create()
      Bluetooth: Remove err parameter from alloc_skb()
      Bluetooth: remove unneeded declaration of sco_conn_del()
      Bluetooth: Remove unneeded elements from size calculation
      Bluetooth: Remove hlen variable

Hemant Gupta (5):
      Bluetooth: Send correct address type for LTK
      Bluetooth: Fix clearing discovery type when stopping discovery
      Bluetooth: mgmt: Fix missing connect failed event for LE
      Bluetooth: mgmt: Fix address type while loading Long Term Key
      Bluetooth: Don't distribute keys in case of Encryption Failure

Ido Yariv (1):
      Bluetooth: Search global l2cap channels by src/dst addresses

Jesper Juhl (1):
      Bluetooth: btmrvl_sdio: remove pointless conditional before release_f=
irmware()

Lukasz Rymanowski (1):
      Bluetooth: Remove not needed status parameter

Marcel Holtmann (11):
      Bluetooth: Add TX power tag to EIR data
      Bluetooth: Handle EIR tags for Device ID
      Bluetooth: Add management command for setting Device ID
      Bluetooth: Fix broken usage of put_unaligned_le16
      Bluetooth: Fix broken usage of get_unaligned_le16
      Bluetooth: Update management interface revision
      Bluetooth: Split error handling for L2CAP listen sockets
      Bluetooth: Split error handling for SCO listen sockets
      Bluetooth: Don't check source address in SCO bind function
      Bluetooth: Restrict to one SCO listening socket
      Bluetooth: Enable Low Energy support by default

Mat Martineau (12):
      Bluetooth: Add definitions and struct members for new ERTM state mach=
ine
      Bluetooth: Add a structure to carry ERTM data in skb control blocks
      Bluetooth: Add the l2cap_seq_list structure for tracking frames
      Bluetooth: Functions for handling ERTM control fields
      Bluetooth: Improve ERTM sequence number offset calculation
      Bluetooth: Remove duplicate structure members from bt_skb_cb
      Bluetooth: Move recently-added ERTM header packing functions
      Bluetooth: Initialize new l2cap_chan structure members
      Bluetooth: Remove unused function
      Bluetooth: Make better use of l2cap_chan reference counting
      Bluetooth: Add Code Aurora Forum copyright
      Bluetooth: Refactor L2CAP ERTM and streaming transmit segmentation

Mikel Astiz (3):
      Bluetooth: Use unsigned int instead of signed int
      Bluetooth: Remove unnecessary check
      Bluetooth: btusb: Dynamic alternate setting

Syam Sidhardhan (5):
      Bluetooth: mgmt: Remove unwanted goto statements
      Bluetooth: remove header declared but not defined
      Bluetooth: Remove strtoba header declared but not defined
      Bluetooth: Remove unused hci_le_ltk_reply()
      Bluetooth: Remove unused hci_le_ltk_neg_reply()

Szymon Janc (2):
      Bluetooth: mgmt: Fix some code style and indentation issues
      Bluetooth: mgmt: Don't allow to set invalid value to DeviceID source

Ulisses Furquim (1):
      Bluetooth: Fix registering hci with duplicate name

Vinicius Costa Gomes (1):
      Bluetooth: Add support for reusing the same hci_conn for LE links

 drivers/bluetooth/btmrvl_drv.h    |    3 +
 drivers/bluetooth/btmrvl_main.c   |   56 ++--
 drivers/bluetooth/btmrvl_sdio.c   |  112 ++++++-
 drivers/bluetooth/btusb.c         |   13 +-
 drivers/bluetooth/hci_ldisc.c     |    2 +-
 drivers/bluetooth/hci_vhci.c      |    3 +-
 include/net/bluetooth/bluetooth.h |   22 +-
 include/net/bluetooth/hci.h       |    8 +-
 include/net/bluetooth/hci_core.h  |   50 ++-
 include/net/bluetooth/l2cap.h     |   93 +++++-
 include/net/bluetooth/mgmt.h      |    9 +
 include/net/bluetooth/smp.h       |    2 +-
 net/bluetooth/bnep/core.c         |    2 +-
 net/bluetooth/hci_conn.c          |   56 +---
 net/bluetooth/hci_core.c          |  259 ++++++---------
 net/bluetooth/hci_event.c         |   67 +++-
 net/bluetooth/hci_sysfs.c         |    5 +-
 net/bluetooth/l2cap_core.c        |  702 ++++++++++++++++++++++++++++-----=
------
 net/bluetooth/l2cap_sock.c        |   38 ++-
 net/bluetooth/mgmt.c              |  283 +++++++++-------
 net/bluetooth/sco.c               |   75 +++--
 net/bluetooth/smp.c               |    2 +-
 22 files changed, 1202 insertions(+), 660 deletions(-)

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqfaMAAoJEPs3PUX4s20oFbMP/idv0QI94JDaXgl/rSXRCVFT
7sz40tI8u8oRxMA/UIeYxCNVMXsWWESYJ0G+QQjzDbL5klBIB8LNn0yj5mMS4DI7
pfjdYhmH9cqVOxC9XCn0b6uHOVXq/CfSifqKgSrLfBmOIdhOzGuPORf0Oi/GlvOQ
bcPKZ3SArYmBBDFEQFZaIXfeNPUv34IQFHFOinC4tBsRhloApz8R0oIKySPRdDoz
2i8V1hJX6Vekhpfsuj/ZpOQOvmuZ/nrbqel1g/+nczt/+cVDPQOSAaKmcCMRTbWu
hPvyvb9p5FaQxVQcNSskQyep5oADYCLZcPvnBGIS23xLsCkTXi2NLbUKxaORNV/t
pd44nmS+pFYYXJ61Q95jMM9SrwWIJoIkTH51h3dNDGtVidrQIMrlFZpZbn+eHDdU
g46u1cPVBc4vxltvSUIKFkqTI5WG3GJku5HAFuD7iGOfg0zN3KyHNovmC32D+eB5
XjgjYLMYOQhCY5v/KFrRsXu0WkCJpmbC2FJgAQgHS7CfpWoeC8uQdCqUn/jX6naO
/qkXo1wi7XW1Fn0hIIuuajuCL03laU3wBhEcFmBkD2+3fKtVgIVz9LlbB+bAT4UZ
GkguIUILQSbefRlFNdJSy7bwHzEvxtY60E9EOjUdcGz5eyRGBAu0+6bdiKg7e6jw
BUK9bKCHE0vRuTGf5Sbq
=aHn6
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--

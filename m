Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2EPPxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:53:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49913 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab2EPPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:53:48 -0400
Date: Wed, 16 May 2012 12:53:40 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-05-16
Message-ID: <20120516155340.GC1414@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A big pull request for inclusion in 3.5. In this set there is some changes
regarding periodic scan and LE, endian fixes, L2CAP ERTM improvements. There
is also fixes, clean ups and small improvements all over the tree.
I also included the patches rejected in the bluetooth pull request.

I checked the whole diff of this pull request for offending coding style
changes and couldn't spot anything wrong.

I merged wireless/master into this.

Please pull, or let me know of any problems!

	Gustavo

---

The following changes since commit 341352d13dae752610342923c53ebe461624ee2c:

  iwlwifi: fix-up some merge damage from commit 0d6c4a2 (2012-05-08 22:18:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

for you to fetch changes up to cde5b476786450fb058a23502372d63c3e8629d0:

  Bluetooth: Report proper error number in disconnection (2012-05-16 18:44:35 +0300)

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

Cristian Chilipirea (1):
      Bluetooth: Fixed checkpatch warnings

David Herrmann (5):
      Bluetooth: Remove redundant hdev->parent field
      Bluetooth: vhci: Ignore return code of nonseekable_open()
      Bluetooth: Move hci_alloc/free_dev close to hci_register/unregister_dev
      Bluetooth: Move device initialization to hci_alloc_dev()
      Bluetooth: Remove unneeded initialization in hci_alloc_dev()

Eldad Zack (1):
      Bluetooth: bnep: use constant for ethertype

Gustavo Padovan (13):
      Bluetooth: Remove sk parameter from l2cap_chan_create()
      Bluetooth: Remove err parameter from alloc_skb()
      Bluetooth: remove unneeded declaration of sco_conn_del()
      Bluetooth: Remove unneeded elements from size calculation
      Bluetooth: Remove hlen variable
      Bluetooth: notify userspace of security level change
      Bluetooth: Fix wrong set of skb fragments
      Bluetooth: Fix packet size provided to the controller
      Bluetooth: Fix skb length calculation
      Bluetooth: improve readability of l2cap_seq_list code
      Bluetooth: report the right security level in getsockopt
      Bluetooth: Create flags for bt_sk()
      Bluetooth: Report proper error number in disconnection

Hemant Gupta (5):
      Bluetooth: Send correct address type for LTK
      Bluetooth: Fix clearing discovery type when stopping discovery
      Bluetooth: mgmt: Fix missing connect failed event for LE
      Bluetooth: mgmt: Fix address type while loading Long Term Key
      Bluetooth: Don't distribute keys in case of Encryption Failure

Ido Yariv (1):
      Bluetooth: Search global l2cap channels by src/dst addresses

Jesper Juhl (1):
      Bluetooth: btmrvl_sdio: remove pointless conditional before release_firmware()

Johan Hedberg (2):
      Bluetooth: mgmt: Fix device_connected sending order
      Bluetooth: Fix Inquiry with RSSI event mask

Larry Finger (1):
      rtlwifi: fix for race condition when firmware is cached

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

Mat Martineau (17):
      Bluetooth: Add definitions and struct members for new ERTM state machine
      Bluetooth: Add a structure to carry ERTM data in skb control blocks
      Bluetooth: Initialize the transmit queue for L2CAP streaming mode
      Bluetooth: Fix a redundant and problematic incoming MTU check
      Bluetooth: Restore locking semantics when looking up L2CAP channels
      Bluetooth: Lock the L2CAP channel when sending

Michael Gruetzner (1):
      Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

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

Vishal Agarwal (1):
      Bluetooth: Fix EIR data generation for mgmt_device_found

 drivers/bluetooth/ath3k.c          |    6 +
 drivers/bluetooth/btmrvl_drv.h     |    3 +
 drivers/bluetooth/btmrvl_main.c    |   56 +--
 drivers/bluetooth/btmrvl_sdio.c    |  112 +++++-
 drivers/bluetooth/btusb.c          |   16 +-
 drivers/bluetooth/hci_ldisc.c      |    2 +-
 drivers/bluetooth/hci_vhci.c       |    3 +-
 drivers/net/wireless/rtlwifi/pci.c |   16 +-
 drivers/net/wireless/rtlwifi/usb.c |   10 +-
 include/net/bluetooth/bluetooth.h  |   31 +-
 include/net/bluetooth/hci.h        |    8 +-
 include/net/bluetooth/hci_core.h   |   67 ++--
 include/net/bluetooth/l2cap.h      |   93 ++++-
 include/net/bluetooth/mgmt.h       |    9 +
 include/net/bluetooth/smp.h        |    2 +-
 net/bluetooth/af_bluetooth.c       |    8 +-
 net/bluetooth/bnep/core.c          |    2 +-
 net/bluetooth/hci_conn.c           |   56 +--
 net/bluetooth/hci_core.c           |  275 ++++++--------
 net/bluetooth/hci_event.c          |   84 +++--
 net/bluetooth/hci_sysfs.c          |    5 +-
 net/bluetooth/l2cap_core.c         |  765 +++++++++++++++++++++++++++-----------
 net/bluetooth/l2cap_sock.c         |   84 +++--
 net/bluetooth/mgmt.c               |  286 ++++++++------
 net/bluetooth/rfcomm/sock.c        |   14 +-
 net/bluetooth/sco.c                |   75 ++--
 net/bluetooth/smp.c                |    2 +-
 27 files changed, 1349 insertions(+), 741 deletions(-)


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPs82EAAoJEPs3PUX4s20oTbMP/jH77+OCAsPvx+2KkFUsh2NJ
49M6j/o6Wx/jIxsX0TvAiU+p33zwp3k5ST/FDhp4swV42/mZ0gROTTfEF01u/tCS
N7hdI83d07/x7EzwDCZlvtrR78y08UnuotuvrrvXEfvYDgjwM7wZ3DIPxQWJnLy4
w7Y56YNOfe70VHcU/ZUyDQsKXUzmLmUHHhBfW1EdTEdbqm5sGrKlJ1+BArayiIeQ
vE7ytVHLRYkgB33xOI9tDCrU/IeoAgKE7QpiHFLyDy0A0dcRhnltwaEsDqX3DCN0
V/wtPV96BBUCUi7DKlIvsAsMl5hZ+BcoI8bi7B/xzRpQN34T2VApMybeEB8sa3gz
xhdN1JdqlduQ+YnrW/mUGWspx99EP+9R4F66dj4RP+mczIxmCPGBteI8idXNW2MB
x2ykOHln/MC5EakN+5yF77C50dZvi8sVAnZN3UI//1D9JVunneLIQwMapxg/NeL/
rwGnxBGAEiQGS6C3InLZrRIc5wJnMazTVKmlMjPnOQHYQlPU2j/p+CY0t2bqHYWT
YblQaYThlINw3VyNSw0sFiMg2tAgWrkvkwclc56bZpRa6g8Ap50/AcYKHEGPo9rm
QXJWOFLqUQebTzNQjK9kXS2md6JHJiqQrxhBB58DK3+Gv9w6NUf/93g/EAp7GA1s
hrP7aKPqBiYZ7xEAXxCd
=cOhh
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--

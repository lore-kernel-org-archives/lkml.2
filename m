Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2DXNrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:47:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33340 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2DXNrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:47:45 -0400
Date: Tue, 24 Apr 2012 10:47:39 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-04-23
Message-ID: <20120424134739.GB9343@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

This is our first request for 3.5. In this set there is some changes
regarding periodic scan, endian fixes and support for new devices.=20
The rest are just fixes and small improvements.

Please pull, or let me know if something is wrong. Thanks.

	Gustavo


The following changes since commit 66f3b913e68e8e62bd2f9499495eeb6cc81b2662:

  Bluetooth: Fix userspace compatibility issue with mgmt interface (2012-04=
-05 15:05:51 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to 86f7a807b6b35eba074a04d7130bee151f413613:

  Bluetooth: Fix coding style issues (2012-04-24 16:04:01 +0300)

----------------------------------------------------------------
AceLan Kao (3):
      Bluetooth: Add support for Atheros [04ca:3005]
      Bluetooth: Add support for Atheros [13d3:3362]
      Bluetooth: Add support for AR3012 [0cf3:e004]

Andre Guedes (10):
      Bluetooth: Check FINDING state in interleaved discovery
      Bluetooth: Add hci_cancel_le_scan() to hci_core
      Bluetooth: LE support for MGMT stop discovery
      Bluetooth: Replace EPERM by EALREADY in hci_cancel_inquiry
      Bluetooth: Refactor stop_discovery
      Bluetooth: Add Periodic Inquiry command complete handler
      Bluetooth: Add HCI_PERIODIC_INQ to dev_flags
      Bluetooth: Check HCI_PERIODIC_INQ in start_discovery
      Bluetooth: Ignore inquiry results from periodic inquiry
      Bluetooth: Remove MGMT_ADDR_INVALID macro

Andrei Emeltchenko (26):
      Bluetooth: Correct type for hdev lmp_subver
      Bluetooth: trivial: Correct endian conversion
      Bluetooth: Correct type for ediv to __le16
      Bluetooth: Fix extra conversion to __le32
      Bluetooth: Correct chan->psm endian conversions
      Bluetooth: Correct ediv in SMP
      Bluetooth: Correct length calc in L2CAP conf rsp
      Bluetooth: Correct CID endian notation
      Bluetooth: Convert error codes to le16
      Bluetooth: trivial: Fix endian conversion mode
      Bluetooth: mgmt: Add missing endian conversion
      Bluetooth: trivial: Correct types
      Bluetooth: Fix type in cpu_to_le conversion
      Bluetooth: Fix opcode access in hci_complete
      Bluetooth: trivial: Remove sparse warnings
      Bluetooth: Silence sparse warning
      Bluetooth: mgmt: Fix timeout type
      Bluetooth: Remove unneeded timer clear
      Bluetooth: Fix memory leaks due to chan refcnt
      Bluetooth: Make L2CAP chan_add functions static
      Bluetooth: Comments and style fixes
      Bluetooth: Remove unneeded zero initialization
      Bluetooth: Add Read Local AMP Info to init
      Bluetooth: Adds set_default function in L2CAP setup
      Bluetooth: trivial: Remove empty line
      Bluetooth: Fix debug printing unallocated name

Brian Gix (1):
      Bluetooth: mgmt: Fix corruption of device_connected pkt

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros maryann PIDVID support

David Herrmann (5):
      Bluetooth: Remove redundant hdev->parent field
      Bluetooth: vhci: Ignore return code of nonseekable_open()
      Bluetooth: Move hci_alloc/free_dev close to hci_register/unregister_d=
ev
      Bluetooth: Move device initialization to hci_alloc_dev()
      Bluetooth: Remove unneeded initialization in hci_alloc_dev()

Don Zickus (1):
      Bluetooth: btusb: typo in Broadcom SoftSailing id

Gustavo Padovan (6):
      Bluetooth: Remove sk parameter from l2cap_chan_create()
      Bluetooth: Fix userspace compatibility issue with mgmt interface
      Merge git://git.kernel.org/.../bluetooth/bluetooth
      Bluetooth: Remove err parameter from alloc_skb()
      Bluetooth: remove unneeded declaration of sco_conn_del()
      Bluetooth: Fix coding style issues

Hemant Gupta (6):
      Bluetooth: Use correct flags for checking HCI_SSP_ENABLED bit
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

Johan Hedberg (2):
      Bluetooth: Don't increment twice in eir_has_data_type()
      Bluetooth: Check for minimum data length in eir_has_data_type()

Johan Hovold (2):
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      Bluetooth: hci_core: fix NULL-pointer dereference at unregister

Jo=E3o Paulo Rechi Vita (1):
      Bluetooth: btusb: Add USB device ID "0a5c 21e8"

Luis R. Rodriguez (1):
      Bluetooth: properly use pr_fmt() on lib.c

Lukasz Rymanowski (1):
      Bluetooth: Remove not needed status parameter

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0489 e042) for BCM20702A0

Marcel Holtmann (10):
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

Mat Martineau (4):
      Bluetooth: Add definitions and struct members for new ERTM state mach=
ine
      Bluetooth: Add a structure to carry ERTM data in skb control blocks
      Bluetooth: Add the l2cap_seq_list structure for tracking frames
      Bluetooth: Functions for handling ERTM control fields

Mikel Astiz (3):
      Bluetooth: Use unsigned int instead of signed int
      Bluetooth: Remove unnecessary check
      Bluetooth: btusb: Dynamic alternate setting

Santosh Nayak (1):
      Bluetooth: Fix Endian Bug.

Steven Harms (1):
      Add Foxconn / Hon Hai IDs for btusb module

Syam Sidhardhan (3):
      Bluetooth: remove header declared but not defined
      Bluetooth: Remove strtoba header declared but not defined
      Bluetooth: mgmt: Remove unwanted goto statements

Szymon Janc (3):
      Bluetooth: mgmt: Fix some code style and indentation issues
      Bluetooth: mgmt: Don't allow to set invalid value to DeviceID source
      Bluetooth: Fix missing break in hci_cmd_complete_evt

Ulisses Furquim (1):
      Bluetooth: Fix registering hci with duplicate name

Vinicius Costa Gomes (1):
      Bluetooth: Add support for reusing the same hci_conn for LE links

Vishal Agarwal (2):
      Bluetooth: hci_persistent_key should return bool
      Bluetooth: Temporary keys should be retained during connection

 drivers/bluetooth/ath3k.c         |    4 +
 drivers/bluetooth/btmrvl_sdio.c   |    9 +-
 drivers/bluetooth/btusb.c         |   19 +-
 drivers/bluetooth/hci_ldisc.c     |    2 +-
 drivers/bluetooth/hci_vhci.c      |    3 +-
 include/net/bluetooth/bluetooth.h |   14 +-
 include/net/bluetooth/hci.h       |    7 +
 include/net/bluetooth/hci_core.h  |   21 +-
 include/net/bluetooth/l2cap.h     |   78 ++++++-
 include/net/bluetooth/mgmt.h      |    9 +
 include/net/bluetooth/smp.h       |    2 +-
 net/bluetooth/hci_conn.c          |   32 +--
 net/bluetooth/hci_core.c          |  206 +++++++++---------
 net/bluetooth/hci_event.c         |   61 +++++-
 net/bluetooth/hci_sysfs.c         |    5 +-
 net/bluetooth/l2cap_core.c        |  454 ++++++++++++++++++++++++++++++++-=
------
 net/bluetooth/l2cap_sock.c        |   33 +--
 net/bluetooth/lib.c               |    2 +
 net/bluetooth/mgmt.c              |  225 ++++++++++++-------
 net/bluetooth/sco.c               |   72 ++++---
 net/bluetooth/smp.c               |    2 +-
 21 files changed, 901 insertions(+), 359 deletions(-)

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlq77AAoJEPs3PUX4s20oRq8P+wWsfbe53J8eRM31WTiqA4Gk
dN3V6L+9aJqFJaeqiNQ2ccAuK1Oq78yUw2ewSSNldaPfXOlu51utNmsK2sh5GpM8
uJqO0q7Y/Ha98HtLgaJoXA22fg/LjL4kkxmNtPMLqE5f3Um4q/9HLJN0rCcCt1dj
QaLNB8s2GthSmVUu8h31B/K7fx2//u9QTmkCJVK0thjO6bpQZCVj+/E5ADqOwRrV
JePtTiNohGvOeh+SdyekH8+oG8YP2T+1YQr78PRVoMVs1v0MTAYnP4Yjq1Rtwlct
5HxP/7J4pl03nz8TOtThMbDT/we6re7dxg3Oxp9CtTCqUFgGA3GCTXnN5jJqCWo/
KiaxLaX4/lJfRC5Ia+2yAQ9S+9KtPLdRHscKaDD7qT0aCyPH96CAdIEHkZib8DII
sLTy5vg9bra8ftLIta4DBcHtOJZLu1bXw1dWjBVqpFm5IrZhDXQ28zuN0KaWKdy/
uiAabJzuFcNSYz7b9Q/z8ctDD7bMLNbgfHksQjHO45JzBzBS9j43juMCKzu1sWYU
SAQR90G00eLMGVQ/OF3+DTHy6SZuiFMQUHslhvEt7whj1ShYcIFzSsXpnsOX3Tq7
6XuPtsD94mF9oT3y8GTVqlMCd7R1G2KxAm+LWnrhnLdkQjwoOMKNzSg0tWDZXp6w
hAoinG2gY7WxbHhxGOaj
=RnQo
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--

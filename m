Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3AJIAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:00:46 -0500
Received: from mail-gg0-f177.google.com ([209.85.161.177]:55849 "EHLO
	mail-gg0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab3AJIAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:00:45 -0500
Date: Thu, 10 Jan 2013 05:34:23 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-01-10
Message-ID: <20130110073423.GE18821@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few fixes for 3.8. Five of them are just new devices ids addition.
Apart from the that there is fix to a kernel memory leak to userspace from
Anderson Lizardo, two interoperability fixes from Jaganath Kanakkassery and
Szymon Janc. And a crash fix by me.

Please pull, or let me know of any problem with these patches. Thanks.

	Gustavo
--

The following changes since commit 5e20a4b53094651d80f856ff55a916b999dbb57a:

  b43: Fix firmware loading when driver is built into the kernel (2013-01-07 14:34:45 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to b7e98b5100aad9290d7f06fcb9d1e80f7f62f05f:

  Bluetooth: Check if the hci connection exists in SCO shutdown (2013-01-10 03:53:32 -0200)

----------------------------------------------------------------
AceLan Kao (3):
      Bluetooth: Add support for IMC Networks [13d3:3393]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Daniel Schaal (1):
      Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

Gustavo Padovan (1):
      Bluetooth: Check if the hci connection exists in SCO shutdown

Jaganath Kanakkassery (1):
      Bluetooth: Fix authentication if acl data comes before remote feature evt

Sergio Cambra (1):
      Bluetooth device 04ca:3008 should use ath3k

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

 drivers/bluetooth/ath3k.c  | 10 ++++++++++
 drivers/bluetooth/btusb.c  |  5 +++++
 net/bluetooth/hci_core.c   |  8 --------
 net/bluetooth/hci_event.c  |  2 +-
 net/bluetooth/hidp/core.c  |  2 +-
 net/bluetooth/l2cap_core.c | 11 +++++++++++
 net/bluetooth/sco.c        |  2 +-
 7 files changed, 29 insertions(+), 11 deletions(-)


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7m7+AAoJEPs3PUX4s20om3sP/1j3grsJYyfloizebfbJNMre
ctSSnZm2SZJyLztRozcgs47ucdc8++09VFisEvv+cxf7SCfY9ZeJjTGVfHIiQIjX
mnL/gpHmIN68hTLF2x/pV5umaMDcUs+FNgtysZbQY6CetgXA2Eso37Abwk5sB+pU
CIwvLJBC6YDm6xv995eMPPbI+F4QKZQPe+lv9dybIK5eG9/v1ZrvF91EAIPFIthf
WZ+jWwerhTYQZI0F8yTITbG8pSqA8WukGbMcot/GsJbkrWylkVIhQv67kbEiKvBm
EYIHdCxFKtBzCpg2UVcLSo5zM738wkAmkkBSCviE42PLCkFCZLtmbKPWGMpzeVu/
OEtIWhkakxWd+IX015B7kkmhnUirUzd0pKlNRffm2E2he/juHotyx+o1BeMlrxXJ
rBob+unWhUzbj78+bbRUPKOLbVS+wu3GyBeIXZ04hmIIn+3irCsYvVDQQUk5N0VI
qubb80bdBdWMgQAhVNR/ySYg00F4zIhsBUkI9H1Q3fWRmgq2b/owg6MS+IURy/mW
qbvjhJ8BlYbBIa5LKmT+4fHup2DbrjC23LoPK/YRZuByJ5MGRCqcEYHO6FxrIEO8
QMXJqkvpq1QxOB8K27+7A/KYq/NPoL5I891zEVgp2W+kL1tG5yRJQhG+AFssm8ki
C3d6A4pzjuE/38uTJRXb
=PkuK
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

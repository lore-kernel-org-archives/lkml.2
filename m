Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2H0QTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:19:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52054 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2H0QTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:19:01 -0400
Date: Mon, 27 Aug 2012 09:18:43 -0700
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-08-27
Message-ID: <20120827161843.GD8934@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few updates for the 3.6 kernel. There are two btusb patches to add more
supported devices through the new USB_VENDOR_AND_INTEFACE_INFO() macro and
another one that add a new device id for a Sony Vaio laptop, one fix for a
user-after-free and, finally, two patches from Vinicius to fix a issue in SMP
pairing.

	Gustavo

---
The following changes since commit 7dd6753f6d2e7e0ccbf2263cef3a9fff6bc89988:

  ath5k: fix spin_lock_irqsave/spin_lock_bh nesting in mesh (2012-08-13 15:17:25 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to d8343f125710fb596f7a88cd756679f14f4e77b9:

  Bluetooth: Fix sending a HCI Authorization Request over LE links (2012-08-27 08:11:51 -0700)

----------------------------------------------------------------
Andre Guedes (1):
      Bluetooth: Fix use-after-free bug in SMP

Gustavo Padovan (1):
      Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Henrik Rydberg (1):
      Bluetooth: Add support for Apple vendor-specific devices

Vinicius Costa Gomes (2):
      Bluetooth: Change signature of smp_conn_security()
      Bluetooth: Fix sending a HCI Authorization Request over LE links

Yevgeniy Melnichuk (1):
      Bluetooth: Add support for Sony Vaio T-Series

 drivers/bluetooth/ath3k.c   |  2 ++
 drivers/bluetooth/btusb.c   | 12 +++++++-----
 include/net/bluetooth/smp.h |  2 +-
 net/bluetooth/hci_conn.c    |  4 ++++
 net/bluetooth/l2cap_core.c  | 11 ++++++-----
 net/bluetooth/l2cap_sock.c  |  2 +-
 net/bluetooth/smp.c         | 10 +++++-----
 7 files changed, 26 insertions(+), 17 deletions(-)

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQO53jAAoJEPs3PUX4s20obg4QAKcSulWXOn7BIEh3qZeuNtO1
vL6Yf9B/wumfMQ5UbLUG9AKEOIGbYpJ1BtkckhCoGY2r4g9ENq0MX/b3fxoa20qr
2P94mCws2M0kGjY/aQOqQ3jdjCd5cgckZp8QyQ29XtmRznwX8r4371e+40QKLJnx
56NCy2Qy5cHofSchMBVpnRXvKT57pMy8sMXHiuXs2Fa7dZhF5gZ2I1EHgetw6FbU
VBsQZbnTZ9I53AKNRyk+L3OiEPtZ8k3ag95erGFEaOdyRHIqolYZ4OLUO4gHXDRZ
iEXSZqKSpWw7y/nJOibyigGG9nkQBu8P0b3CYGaSA0sZHgkSdm4YSmY8Eqy6m1Rp
DHYdz0YBVM5EU3es+k7C3Hkac1aME/p5YcbAjwMUyeGNdllgd/z5uRBpX17H1ixe
KpY2PjP/a+v/Bc6sNG5H7CsabnVi1FJaUG4W4mlhbiP1sU+/9O1VtcqwEy0vf1uN
JpGFeYR3sW8RmE8ChEsoKvIlxODdHFqw85U6tTNYXfpNywPG4r+xv2J9smxhT9dy
h5ehKtI7mBDsKUcF1Z3IK8oQHtGOEWUWGhExgNPLbqSjs+menOxj8Ei1inX5/+7p
cCtobKW+hWbaiGxbn99zrH44jfJ/m73pLZPxVI0RcqyZQ3hMU6wnt4zuzYT4B04G
PoSBSI2Wler3ylhk3ilh
=BJwS
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

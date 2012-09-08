Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2IHWAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:00:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58241 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2IHWAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:00:04 -0400
Date: Sat, 8 Sep 2012 18:59:56 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-09-08
Message-ID: <20120908215956.GP5788@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few more fixes to 3.6, here we have four important fix to the MGMT interface,
two from Johan Hedberg and Andrzej Kaczmarek. Andrei fixed a free on
uninitialized memory and I added support for Broadcom/Foxconn devices.

Please pull, or let me know of any problems. Thanks.

	Gustavo

The following changes since commit f10723841e624c0726c70356b31d91befed01dd6:

  libertas sdio: fix suspend when interface is down (2012-09-05 14:53:36 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to b6f04c364ef853d8baa8949be20ef708000bcb97:

  Bluetooth: Fix freeing uninitialized delayed works (2012-09-08 17:27:52 -0300)

----------------------------------------------------------------
Andrei Emeltchenko (1):
      Bluetooth: Fix freeing uninitialized delayed works

Andrzej Kaczmarek (2):
      Bluetooth: mgmt: Fix enabling SSP while powered off
      Bluetooth: mgmt: Fix enabling LE while powered off

Gustavo Padovan (1):
      Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn

Johan Hedberg (2):
      Bluetooth: mgmt: Implement support for passkey notification
      Bluetooth: Update management interface revision

 drivers/bluetooth/btusb.c        |  2 +-
 include/net/bluetooth/hci.h      | 18 ++++++++++++
 include/net/bluetooth/hci_core.h |  5 ++++
 include/net/bluetooth/mgmt.h     |  7 +++++
 net/bluetooth/hci_event.c        | 67 ++++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/l2cap_core.c       |  2 +-
 net/bluetooth/mgmt.c             | 35 +++++++++++++++++++++-
 7 files changed, 133 insertions(+), 3 deletions(-)


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQS7/cAAoJEPs3PUX4s20oo/4P/2SfqurEsM04BlBQZ5HsAaBE
qEc4xhiZ+T1zoL8rzRezlc8wyjGXGm8xA6ZXMe64yr+/soi6L/2y9pFV4MK6vg19
/QIDsr58mL0oAqDOiJ81U2TmDaWICJHEbuT1rqzQvif5ntOdnF4fXAHcJSab+6eE
DPDGfOSimYocpDDEnafurohPTtr3Hkux86nEO02aU+xJmyUrwHiWNLnnEnbfD29W
4nNKGTpiHi5F3ncP/1kCI2HN95GQr2K1juCwAeTrD38rnrr7U6+jVrWbrpoexsPk
5eVKF0udX6lkJFGEICLltWLN6urSLuS7JU7GnGl0xzZH4BZe/MnfH+r4QpbT1/hv
gqPlLo9On5ppqEHeMzMYqVqWbaW0Rq9ynuND/Dn4VS3nlOj7y05ZQVRA6gYZ7OPp
C9p1qblSttySbZidVGXTlhDUN32CHXn/Drbe0e7HLyzupNgQi74SsKjxKa8b+NJ8
tvwTC0gKARmVv55Zrl4KlOHuu7/wx17Vjbpas9RXfk7a0+JflURItpnuWvmSX+NZ
eLrEB/EACPbygqDQ7UsV3T24fpt2b9gCVpMhS/tNymiuwx943sXy7HSz9VCexdUq
NwxdUgZt9IG19qmSohRdrT1i33yWwzQXnhVJfV2WObwAmRwc6DtiVkMHEvfVFh5W
SfDKmUvvpRogtlUa755C
=bQlT
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2DXQMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:12:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61598 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2DXQMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:12:20 -0400
Date: Tue, 24 Apr 2012 13:12:06 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-04-24
Message-ID: <20120424161206.GC9343@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few more fixes to 3.4, there is tree new device id supported, a missing
break and a fix to retain key during the connection.

Please pull. Thanks.

	Gustavo

--

The following changes since commit 66f3b913e68e8e62bd2f9499495eeb6cc81b2662:

  Bluetooth: Fix userspace compatibility issue with mgmt interface (2012-04-05 15:05:51 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-upstream

for you to fetch changes up to 985140369be1e886754d8ac0375dd64e4f727311:

  Add Foxconn / Hon Hai IDs for btusb module (2012-04-24 11:38:41 -0300)

----------------------------------------------------------------
AceLan Kao (2):
      Bluetooth: Add support for Atheros [13d3:3362]
      Bluetooth: Add support for AR3012 [0cf3:e004]

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0489 e042) for BCM20702A0

Steven Harms (1):
      Add Foxconn / Hon Hai IDs for btusb module

Szymon Janc (1):
      Bluetooth: Fix missing break in hci_cmd_complete_evt

Vishal Agarwal (2):
      Bluetooth: hci_persistent_key should return bool
      Bluetooth: Temporary keys should be retained during connection

 drivers/bluetooth/ath3k.c        |    4 ++++
 drivers/bluetooth/btusb.c        |    6 ++++++
 include/net/bluetooth/hci_core.h |    3 ++-
 net/bluetooth/hci_core.c         |   27 +++++++++++++--------------
 net/bluetooth/hci_event.c        |    3 +++
 net/bluetooth/mgmt.c             |    2 +-
 6 files changed, 29 insertions(+), 16 deletions(-)

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPltDWAAoJEPs3PUX4s20odxIQAIvDhmfZyBmzGTa8KQtXQ/LV
EkkcLF3eQ2lmgk59U+ugm4FYTZcDG2GuOn7S4lCel7bTtqrgbuh8djKgCoq4wvPa
KN16XzDRwl1guBY7ncgvG8yzPEMuII+qf6JcuVF2G8SRYF2r4GARQQOtmphVKr31
5vMDJC4mCtz8V4YdrFG6ZPxBSbclGyjcxvNFgPXnf3Nxb6i2s+UIjicZXLAgeD+b
f5QlUeERZDTAs6l6bf50Uq+JbKCyMm/ra4/4VIWeBt8zsvZcHWbPaETLlZsGK/hx
HAwt4SXyBOG3IC0rH/dJ1Eb/IOsRJmxGCX50fuNXHCQgbw2xdhVRuCsuKvBwpcrq
pw2AMJa6DTDs1+GKgj91ZfYfjqv02CjRCZEpLEeR8B75+GFVnJY2datsI2GIo/Bd
melp41L1x+7ivdVNjh0k7IOskUat8nBATrbl2V3zeYVGd3/JWwAUPRzqJkEri2Gg
k+qlZR2Uu8qSjclgJS7IFnIFWMUUsAdMj/ijl0lhcU7B4M6rs2jIBMu3Ew74F8Qr
rY9KfVAttVO4Bskg+earnwuynvLFcs1rLkg9ZEbYFrWM3X7W0027dGoApp597N/P
d6LnyfThIoS+S94EpaT+XAJgKg2Z4BTZNZRDsxZiv0Fp5dia5QNpR3c2WN+bRzdl
SRRRY4uwyt/N/xF+rY0n
=pgi+
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--

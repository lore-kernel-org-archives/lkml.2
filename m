Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab2EEAMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:12:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45408 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab2EEAMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:12:50 -0400
Date: Fri, 4 May 2012 21:12:43 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-05-04
Message-ID: <20120505001243.GC23728@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few more patch to 3.4. There is 3 fixes from Mat Martineau, a fix for
a incoming MTU check that was breaking ERTM, still on ERTM there is a
patch that fixes concurrency with one of our locks. His third patch is
related to lock fixes too.
Besides that Johan fixed a wrong bit set in the Inquiry code, Vishal
Agarwal added a EIR fix and finally we have support for one more usb id.

Please pull or let me know of any problems!

	Gustavo

---

The following changes since commit 985140369be1e886754d8ac0375dd64e4f727311:

  Add Foxconn / Hon Hai IDs for btusb module (2012-04-24 11:38:41 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-upstream

for you to fetch changes up to 78521bdb4a42770c4c2d48317c00ec0d7f451a08:

  Bluetooth: Lock the L2CAP channel when sending (2012-05-04 20:56:29 -0300)

----------------------------------------------------------------
Johan Hedberg (1):
      Bluetooth: Fix Inquiry with RSSI event mask

Mat Martineau (3):
      Bluetooth: Fix a redundant and problematic incoming MTU check
      Bluetooth: Restore locking semantics when looking up L2CAP channels
      Bluetooth: Lock the L2CAP channel when sending

Michael Gruetzner (1):
      bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

Vishal Agarwal (1):
      Bluetooth: Fix EIR data generation for mgmt_device_found

 drivers/bluetooth/ath3k.c         |    6 ++++++
 drivers/bluetooth/btusb.c         |    3 +++
 include/net/bluetooth/bluetooth.h |    2 --
 include/net/bluetooth/hci_core.h  |   17 +++++++++++++++++
 net/bluetooth/hci_event.c         |    6 ++++--
 net/bluetooth/l2cap_core.c        |   30 +++---------------------------
 net/bluetooth/l2cap_sock.c        |   19 +++++++++++--------
 7 files changed, 44 insertions(+), 39 deletions(-)


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpHB7AAoJEPs3PUX4s20oDGEQAKO2ZR5q735Yi+gGkqww68It
r1zGCHFsyGRlq4egeCwuC8bzjKIYhVz7TuC8DqN1dX0BHjtoBWtyCahktj1gOhU8
30XccbBJNLPnTJKceTueF+/54q53mVguQiypDn+Kjfgokbpw2cZAT0yuSHfBYmYF
4t9RL1OIdl4LM9sDsnE0zAP7dRlKLB5zaw3NdHvxJqaQtjfnp9gOyZBX8J4ccZUB
VJ4Nhq8IJ63TvnsRKuTbwFGoVezMYXmglnNioCslsQMLLH70SVCiNTnoDiedAmjb
KECCl5NQOPloKemm2mSIMb3xutbCfB1m8NJFcXrhrNFsjx1piRrcd//8QnDXY8pZ
aHVuX45aqC08nnQyZAxANxDuzCKJKQJGTT/yMxYNWotA9GSAbjkM93JQ/+jB6ULd
dVZdzLLtFP1u8aPgQfdXdixBEALDyHx8iIu8nBX86xPorhj6ckKbNE+ByNSWVqYo
gpp9sWjjCJFwBIATl0gT1JSL3BRcKSNnJs/QLaTbUB4yQyevPqb80vyiVPau0/GM
BM6m7RtTiUFT792t43WWd3o3FocvrKXU9EImxiJBvlBmUeXsZ05mqdKL9obAVzLV
MYa9PDDuMwkI4vjv1isJ5V9mSqd/Wf8xrMsnTEFqUIQQohFe9RPho3RmKarFoUWh
lw5F6CdX5WrRARSSyPAx
=TY3/
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--

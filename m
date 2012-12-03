Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2LCSWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:22:18 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49634 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2LCSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:22:16 -0500
Date: Mon, 3 Dec 2012 16:22:08 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-12-03
Message-ID: <20121203182208.GB2930@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A few more patches to 3.8, I hope they can still make it to mainline!
The most important ones are the socket option for the SCO protocol to allow
accept/refuse new connections from userspace. Other than that I added some
fixes and Andrei did more AMP work.

Please pull, or let me know any concerns you have. Thanks!

	Gustavo

---
The following changes since commit 2b2fec4d08a0aabe20d2e749cb7978f04217af65:

  Bluetooth: Remove OOB data if device was discovered in band (2012-11-20 1=
6:03:15 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to 0b27a4b97cb1874503c78453c0903df53c0c86b2:

  Revert "Bluetooth: Fix possible deadlock in SCO code" (2012-12-03 16:00:0=
4 -0200)

----------------------------------------------------------------
Andrei Emeltchenko (6):
      Bluetooth: Refactor l2cap_send_disconn_req
      Bluetooth: AMP: Mark controller radio powered down after HCIDEVDOWN
      Bluetooth: AMP: Check that AMP is present and active
      Bluetooth: Fix missing L2CAP EWS Conf parameter
      Bluetooth: Process receiving FCS_NONE in L2CAP Conf Rsp
      Bluetooth: trivial: Change NO_FCS_RECV to RECV_NO_FCS

Fr=E9d=E9ric Dalleau (2):
      Bluetooth: Add BT_DEFER_SETUP option to sco socket
      Bluetooth: Implement deferred sco socket setup

Gustavo Padovan (4):
      Bluetooth: Add missing lock nesting notation
      Bluetooth: cancel power_on work when unregistering the device
      Bluetooth: Move double negation to macros
      Revert "Bluetooth: Fix possible deadlock in SCO code"

 include/net/bluetooth/hci_core.h |  31 ++++++++++---
 include/net/bluetooth/l2cap.h    |   2 +-
 net/bluetooth/hci_core.c         |   5 +++
 net/bluetooth/hci_event.c        |  56 ++++++++++++++++++++---
 net/bluetooth/l2cap_core.c       | 100 +++++++++++++++++++++--------------=
------
 net/bluetooth/mgmt.c             |  10 ++---
 net/bluetooth/rfcomm/sock.c      |   4 +-
 net/bluetooth/sco.c              |  86 ++++++++++++++++++++++++++++++-----
 8 files changed, 213 insertions(+), 81 deletions(-)

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQvO3PAAoJEPs3PUX4s20oGJwQAJx59z01ELd99HkIoCDEKXvS
rm8QvTn6PJdSJCkH6PyXkYPTC4XTV66TLxYJkBfqgZZFe/nYEHkjdpljZqfrVbYx
hBHqFa0wDHyvPEXDmUe1iOycMlK5GqS+RLlOnft5vOREbofo0zGlEUtFKOYMOROW
0dCl61kcl+pbcXvhLktOdov3WD/7SG67vEqaNxC/aIyhXhy2j331d842JBC0e+WK
JceK2VfvrDC/w+A7mA5qmpMvW+LGpWH0wS1FOtGS2xNTAdx1qPSenLNjljXVKZxR
mCVmBWrajFMypmckRv8j4lfaaHK1jjzBmGU8/MuOw72z4ZvAVLTsZ3cBo8sdRV6W
eF7I7dCCu8mnF0OAmvndoJDRT62f6n+ivSLCE+BUw7KM+GO7y7+WBcxfI7+Gc2Xy
WxkLaeTQDZDtqJshNYnOIB2y8sI+IKdeIs3AvaI13NWwFJUa7Hks5GEz+wk3jtuf
3GgYHhsTqGNdO6igWFTfWAAoo8ysHe1zuF6JJ6wXCiuW6cKBxwT/dGx7qL3uy5kl
nYJQfT26yXheUtI5k6Zl4jV67MXK4cmm4ZrSZ8wgohEjbUQwP5NDWUGEvTxmZSO3
0SUWgmzJydh6a85CRF1d2LMRnbpK4tC4CVFaQhpNkiJLk5ssF/1oLsHFbI6WvWFS
g8WY3G6/RVhXrArboRRW
=fW/r
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--

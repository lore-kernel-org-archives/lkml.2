Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2KTWIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:08:52 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:43232 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KTWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:08:50 -0500
Date: Tue, 20 Nov 2012 20:08:42 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2012-11-20
Message-ID: <20121120220842.GA15370@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few patches to 3.8. The majority of the work here is from Andrei on the High
Speed support. Other than that Johan added support for setting LE advertising
data. The rest are fixes and clean ups and small improvements like support for
a new broadcom hardware.

	Gustavo

---
The following changes since commit 57527f8d4d71b5167a02fb6713857f55d3974748:

  ath9k_hw: Program filter coefficients correctly (2012-11-16 14:29:11 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

for you to fetch changes up to 2b2fec4d08a0aabe20d2e749cb7978f04217af65:

  Bluetooth: Remove OOB data if device was discovered in band (2012-11-20 16:03:15 -0200)

----------------------------------------------------------------
Andrei Emeltchenko (9):
      Bluetooth: Use __l2cap_no_conn_pending helper
      Bluetooth: Remove unneeded local_amp_id initialization
      Bluetooth: Refactor locking in amp_physical_cfm
      Bluetooth: Disable FCS only for new HS channels
      Bluetooth: trivial: Use __constant for constants
      Bluetooth: Fix sending L2CAP Create Chan Req
      Bluetooth: Set local_amp_id after getting Phylink Completed evt
      Bluetooth: Improve error message printing
      Bluetooth: AMP: Set no FCS for incoming L2CAP chan

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Johan Hedberg (3):
      Bluetooth: Use proper invalid value for tx_power
      Bluetooth: Add support for setting LE advertising data
      Bluetooth: Fix updating advertising state flags and data

Szymon Janc (2):
      Bluetooth: Increase HCI command tx timeout
      Bluetooth: Remove OOB data if device was discovered in band

 drivers/bluetooth/btusb.c        |  1 +
 include/net/bluetooth/hci.h      | 22 +++++++++-
 include/net/bluetooth/hci_core.h |  4 ++
 include/net/bluetooth/l2cap.h    |  2 +-
 net/bluetooth/amp.c              |  8 +++-
 net/bluetooth/hci_core.c         | 98 ++++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/hci_event.c        | 44 ++++++++++++++++++-
 net/bluetooth/l2cap_core.c       | 52 ++++++++++++----------
 net/bluetooth/mgmt.c             |  2 +-
 9 files changed, 204 insertions(+), 29 deletions(-)

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQq/9qAAoJEPs3PUX4s20oLEIP/jkq+Kke8MrYQPLwLLkMpybr
RIv3gm9KOb8Z5btvxHNGj1T9+svzH8x6d5y/uHOgKxkqkQCLYAR0K0ZOUq7ZQrKP
IP8HoUDTUkIBjJKcZPZReBNCtUty6lLYi+W3fRtBlxxI+w2tWuyaou6+5rOZRxo0
C9ln7OcvFCSCp9SB62lKJ5PnMZVIrRxIJJp8ZtT3wmTTtTVciLfKuhB984Xh2Fwk
v1D8jvjn1Cffzo7jTgqHlnk8PfTjtQAN1kISYetfzaS1iA6/P/XnS6kWt7JRReo/
8eAusYzp/dV9aZGqkwhkgwT9/QEyQdEerIKg7yo5eK3UdDIM0ieA5pxn0/KglaWt
p12SdKnNCQsqqFwMv3Qvz+3UwIVksg9VSF6k9KbwJCXPXNJK94S+PjS+dYLeLaW2
8KyUn3jKePs2uYQULUiz+2ALzjf13KXfoOqfp01tneTlViZ67faS++D/LtbVkze4
lGBUbzQAlBwoCTToiLNxE3OU7XrWLTJIEUnBJZSXhzyYjd7tNMQt+1GfuZ5E29A3
3LUb4CxjDyFtJ+05RUVpIeSvNE0EAlnp/uatAzdUvo42P4+YhGSVa7xjSnCkpbn0
GOcaecXaT13bvkgQle/dv5cDg3HrGO+jdunb9MzMtACa669OEAizkT0GLV7HeTC8
sRtEK+rt5lBa3lXj7niY
=npXK
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2DFBQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 21:16:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45019 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2DFBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 21:16:04 -0400
Date: Thu, 5 Apr 2012 22:15:57 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-04-05
Message-ID: <20120406011557.GA7718@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a batch of fixes for 3.4. We have added support to 3 new devices,
fixes some NULL-pointer dereferences, memory leaks, memory corruption and
endian bugs. There was also a userspace compatibility fix reported by Keith=
=20
Packard on lkml. The fixes are all simple.

Please pull, or let me know any concerns you have.

	Gustavo


The following changes since commit de312db345f9770b64ff39ef5a7f86f6358e93cc:

  mac80211: fix oper channel timestamp updation (2012-03-28 14:25:37 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

AceLan Kao (1):
      Bluetooth: Add support for Atheros [04ca:3005]

Andrei Emeltchenko (3):
      Bluetooth: Fix memory leaks due to chan refcnt
      Bluetooth: mgmt: Add missing endian conversion
      Bluetooth: mgmt: Fix timeout type

Brian Gix (1):
      Bluetooth: mgmt: Fix corruption of device_connected pkt

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros maryann PIDVID support

Don Zickus (1):
      Bluetooth: btusb: typo in Broadcom SoftSailing id

Gustavo Padovan (1):
      Bluetooth: Fix userspace compatibility issue with mgmt interface

Hemant Gupta (1):
      Bluetooth: Use correct flags for checking HCI_SSP_ENABLED bit

Johan Hedberg (2):
      Bluetooth: Don't increment twice in eir_has_data_type()
      Bluetooth: Check for minimum data length in eir_has_data_type()

Johan Hovold (2):
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      Bluetooth: hci_core: fix NULL-pointer dereference at unregister

Jo=E3o Paulo Rechi Vita (1):
      Bluetooth: btusb: Add USB device ID "0a5c 21e8"

Marcel Holtmann (1):
      MAINTAINERS: update Bluetooth tree locations

Santosh Nayak (1):
      Bluetooth: Fix Endian Bug.

 MAINTAINERS                      |    8 ++++----
 drivers/bluetooth/ath3k.c        |    4 ++++
 drivers/bluetooth/btusb.c        |    5 ++++-
 drivers/bluetooth/hci_ldisc.c    |    2 +-
 include/net/bluetooth/hci.h      |    3 ++-
 include/net/bluetooth/hci_core.h |   12 +++++++-----
 include/net/bluetooth/mgmt.h     |    2 +-
 net/bluetooth/hci_core.c         |    7 +++++++
 net/bluetooth/l2cap_core.c       |    3 +++
 net/bluetooth/l2cap_sock.c       |    5 +++--
 net/bluetooth/mgmt.c             |   13 +++++++++----
 11 files changed, 45 insertions(+), 19 deletions(-)


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPfkPNAAoJEPs3PUX4s20oB5QP/2WFumoGR3DSAOlzt1yUWIC/
7X7BNgW0gbPk/OXKUAyjg6Y/vIMQXHdqrzLgGyz2PR+5nv2nqGfiWEehEq0UKald
7msJWKX2kaFeHS+gUOICUXy1T9xw21pkJgtY6lAjGjGbKjnHAING9kjUkDCme8vj
0jAaEA8zlypFO+PGowloH44H61JTksDf1y733phaNhAMV1vOrVUcBxSX4e7Hb8A6
pDajG3dBRVGE1e6lf8TB8khpqdrifI50xbBnl9E2R3xY8Il5yMXcKEOpwSzU2nWf
xR3NhrnUS+WJYdusQ+ezAaBFkhm6wwEUjM9aFEbg1tpdQXMcuI8nVfywttT2puPF
lA/T4lzDDag+KTA1yDeMDY0FNxb49aPNo15kCa/aK/WnF+3/ct2HQRcjxJysuYLU
tc9YBflxCfGHXlh201JPD+dw3sJB1iB7D0lwkA5ZJuEIbUHvWAMJH3WLLo/BTg0E
fA5twPJUP9ZiGIgNsfdj6LZsZQWc9FBRFlwhmL5IqSM3R3X/kZTrjJlJhYeaQa82
dmqa+/A8GTyWk3JcB8VMSqmwi42pzc3zi+7njk6rnKXJXcnAdGMhxsHoChe7SqMR
Oy69MEtLEJ8Mm/sS2Fhr4WBKTpqf3XFAwY05tVjl/LjPwV1pkswUVmEisbUH3DBw
kxMDNvH8mqXHV1gX9ywD
=ZsR4
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--

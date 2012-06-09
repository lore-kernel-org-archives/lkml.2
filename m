Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2FIV7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 17:59:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65487 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2FIV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 17:59:30 -0400
Date: Sat, 9 Jun 2012 18:59:23 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-06-10
Message-ID: <20120609215923.GA1458@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few fixes to 3.5. The issues fixed by these patches were found at the last
UPS testing session. They fix several bugs with LE devices.

Please pull. Thanks.

	Gustavo

---

The following changes since commit ddcd0f41471a1e0394c8840a119ec3986a78462c:

  Bluetooth: Fix checking the wrong flag when accepting a socket (2012-06-05 06:26:26 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-upstream

for you to fetch changes up to 1c2e004183178e1947882cd2e74f37826f45230e:

  Bluetooth: Add support for encryption key refresh (2012-06-08 21:00:40 -0300)

----------------------------------------------------------------
Johan Hedberg (4):
      Bluetooth: Fix SMP pairing method selection
      Bluetooth: Fix deadlock and crash when SMP pairing times out
      Bluetooth: Fix SMP security elevation from medium to high
      Bluetooth: Add support for encryption key refresh

Vishal Agarwal (1):
      Bluetooth: Fix LE pairing completion on connection failure

 include/net/bluetooth/hci.h |    6 ++++++
 net/bluetooth/hci_event.c   |   48 +++++++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/l2cap_core.c  |    7 ++++++-
 net/bluetooth/mgmt.c        |   18 +++++++++++++++++
 net/bluetooth/smp.c         |   11 +++++++----
 5 files changed, 85 insertions(+), 5 deletions(-)



--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP08c7AAoJEPs3PUX4s20or5AQALhK5XUAI0tA4fVBaOpbxXET
QHwpQSf4lvZwxGJuUNC6L1rlwdBMXEuuimZDynlfRqV6c9FPudafHK/4/9VorDzU
fj8mL9qEuNp+flpxj9q3nMxgCNurRMaisYf383Vn8O/QWOkLTPAgD6Ppt5hIRcEr
L1sjwvvImn0CaxdPjjTCAgqnD2Qj5SOnrT7gNRDXxU5SegXSOtJabxI3PNTQ9kLd
Puta+qQwcJyTe+6Zpt8WWHBISiX6SlBLMvPKUNZ0FMPPUov7tTRh6bHasc2cmyrj
bfvnoBggSQ6/64pLiDFPXERH0oGw2CD+UuV1M08/I9Zr2nS8s35u0avjtLtskntx
pIwnNTRRNrjngyJIaWZxW1BrilwMS7f9wM1rB/hK+1UckpWCGW73j695oP4XO3/+
Q44yUvj7dhV6Hlb8rMSNWTu4Ko2dmu24R4V3uqZSme7eAk1cqVHzj0/w6Ofqtg/2
OC+mjl6g9Ft5AmayNzeO9zj7SQ1CL+Mj4D28QcW7lod6WIMmo3lKEP0bV8MMAleg
7lsKGQi2NsadL3Q9PUYAbdCgD8k1z50jVogpNqyZe2+hTbLuUrZh4QVekTorssth
hBTBpOgj8ATfJ9v1r4e1jJsFWofQARFkqYFpFYK+VH7XM9JZ+AUKmfiMfZ14Huw8
MMpP0XzpA4U0oHzjMNHb
=tqmJ
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--

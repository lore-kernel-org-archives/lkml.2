Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2KJSYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:24:35 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60321 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KJSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:24:31 -0500
Date: Sat, 10 Nov 2012 19:24:27 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-11-09
Message-ID: <20121110182427.GA7523@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121012110142.GF10739@joana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20121012110142.GF10739@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A few important fixes to go into 3.7. There is a new hw support by Marcos
Chaparro. Johan added a memory leak fix and hci device index list fix.
Also Marcel fixed a race condition in the device set up that was prevent the
bt monitor to work properly. Last, Paulo S=E9rgio added a fix to the error
status when pairing for LE fails. This was prevent userspace to work to han=
dle
the failure properly.

Please pull! or let me know of any issues. Thanks.

	Gustavo

---
The following changes since commit 6fe7cc71bbf3a0bc28c9cec3c00bc11e81344412:

  ath9k: Test for TID only in BlockAcks while checking tx status (2012-10-3=
0 15:58:54 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 482049f75750d73358e65236b933417b69f9cc25:

  Bluetooth: Fix memory leak when removing a UUID (2012-11-09 16:45:37 +010=
0)

----------------------------------------------------------------
Johan Hedberg (2):
      Bluetooth: Fix having bogus entries in mgmt_read_index_list reply
      Bluetooth: Fix memory leak when removing a UUID

Marcel Holtmann (1):
      Bluetooth: Notify about device registration before power on

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Paulo S=E9rgio (1):
      Bluetooth: Fix error status when pairing fails

 drivers/bluetooth/ath3k.c |  1 +
 drivers/bluetooth/btusb.c |  1 +
 net/bluetooth/hci_core.c  |  4 ++--
 net/bluetooth/mgmt.c      | 12 +++++++-----
 net/bluetooth/smp.c       |  2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnpvbAAoJEPs3PUX4s20oz2gP/1stWZnrYAP8XCuXv+9FYhwI
i4CMHyR32Qf4QfSwaCMZXfoNFTMOPb8jXJKTTxslffEWMQ0DCPTQnga3FuQazhx5
jFvU4DAe4F2SMJUuSfI03b+Mkp+AhoZAcle3zL3fjx0sJY0kzbbClwzMWL33jIVJ
BCXAk8q56HII/8AcAlEgECqXbjVT6yDgxapHWzIMcUH46hta2pqxhS7/hYKPRWrB
1JRAkSLpi6xXd4pMk2pqt8a/bW8s0UCh200O9VY6Pmo/H/cVnOphZCLBuRcIbqUm
oGBxhtRVaVyokcvy2ayXem/uzM57eiHFSzx5T0mh8VonVwaS6YovBZUZZ86tCktW
xZbHr8pspTpHrebMM1ofk91EsTzeHmL4wwPzOyzyPyBWm+rYN0uDKX6bXBu/aMk9
R+6jTapeA/H/tDAec7mXUUuvmHqevIMVMTend54JI9fJE1B3EJjgySer3JCPXEEv
2yeUVhhD40QmEg4admfQq5cMedcG/zRXfETsJo/UzKWZjmCa5Jh8SdRGKDfvRUkT
RmKHT8cBaHrKi+2fmpE86Jj1Z4WD2CMssx3+aGJKsf0uWEWNs1hL17S0wojYEJnS
B8KrkQ73oVzKYlqbm8SJtB+Z38X+CQcaGVy3H4NfzJ/zFs1f0wMAhxRMd5iNQW2Z
/FEriSD7fTpUgwM/gcmW
=BFkS
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

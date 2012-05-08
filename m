Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2EHHIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:08:02 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34625 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2EHHIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:08:00 -0400
Date: Tue, 8 May 2012 04:07:54 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-05-04
Message-ID: <20120508070211.GB11843@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120505001243.GC23728@joana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <20120505001243.GC23728@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

* Gustavo Padovan <gustavo@padovan.org> [2012-05-04 21:12:43 -0300]:

> Hi John,
>=20
> A few more patch to 3.4. There is 3 fixes from Mat Martineau, a fix for
> a incoming MTU check that was breaking ERTM, still on ERTM there is a
> patch that fixes concurrency with one of our locks. His third patch is
> related to lock fixes too.
> Besides that Johan fixed a wrong bit set in the Inquiry code, Vishal
> Agarwal added a EIR fix and finally we have support for one more usb id.
>=20
> Please pull or let me know of any problems!

I saw that you didn't pull this yet, so I decided to re-do this pull reques=
t.
We have more 3 important fixes to go in. They fix a regression that was
preventing Bluetooth keyboard to work. I'll re-do the whole pull request
message, so you can copy and paste it easily:

A few more patch to 3.4. There is 3 fixes from Mat Martineau, a fix for a
incoming MTU check that was breaking ERTM, still on ERTM there is a patch t=
hat
fixes concurrency with one of our locks. His third patch is related to lock
fixes too.
Besides that Johan fixed a wrong bit set in the Inquiry code, Vishal Agarwal
added a EIR fix and finally we have support for one more usb id.  Finally
Johan and I fixed a regression that was preventing bluetooth keyboard to wo=
rk.

Please pull or let me know of any problems!

	Gustavo

---

The following changes since commit 985140369be1e886754d8ac0375dd64e4f727311:

  Add Foxconn / Hon Hai IDs for btusb module (2012-04-24 11:38:41 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for=
-upstream

for you to fetch changes up to fbcb6a061652b38257a1d8bcf6ebd70fc1771549:

  Bluetooth: mgmt: Fix device_connected sending order (2012-05-07 20:56:30 =
+0300)

----------------------------------------------------------------
Gustavo Padovan (2):
      Bluetooth: notify userspace of security level change
      Bluetooth: report the right security level in getsockopt

Johan Hedberg (2):
      Bluetooth: Fix Inquiry with RSSI event mask
      Bluetooth: mgmt: Fix device_connected sending order

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
 include/net/bluetooth/bluetooth.h |    3 +--
 include/net/bluetooth/hci_core.h  |   17 +++++++++++++++++
 net/bluetooth/af_bluetooth.c      |    2 +-
 net/bluetooth/hci_core.c          |    8 ++++++++
 net/bluetooth/hci_event.c         |   17 +++++++++++++----
 net/bluetooth/l2cap_core.c        |   35 ++++++++-------------------------=
--
 net/bluetooth/l2cap_sock.c        |   39 +++++++++++++++++++++++++--------=
------
 9 files changed, 82 insertions(+), 48 deletions(-)

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqMZKAAoJEPs3PUX4s20owrEP/3fRjmR3d8E5nEzJUMg+LHtN
t6vbBpi61YN6pb7cJMCWTTfKrMO58qWt2BhMe7SymoTjoxq5Z2g2j2T9cv0MVbUy
/hokx/GN9c/lKyBUt90sbxOTOW/whnJhuv1T9G6KmVseewNDciEZugNFNlnPlI7Z
gLZogCR15v9B/H4iA4B4baJuMEon3+A9U1wKPACRFwZYf1QGvwyiwbiYxmdgZudx
WDcdTe9zCDfiwibStcv1/DzOo3peTHHxSnURlbs3R80DwPS3SDBN3e8xOIF155gl
ltbXUOgicPyWRYcpbeJHlyI0ueEJTydWU9tNTDSPFImW0sO68UJVx9EeNcFi+Zzk
BGOIP9hd3HqMD3ULoeWZpcckTNeGZfDQzb+NEF11+jdihRpUT3DPSVN3Ofj8vVrq
6LuSYucZ6jWUrOv5S76slnlQp61KkyuLnHnD1R4zDpBZsqN+6calr+HCqaea3uYk
zza6HAdkXM4gstXBX1HqA2qiYAYH8I0aBQOm0mM02PJJLCQD+akfqqAQulS/9gqj
UFFS8lY0xJFEXOcBIEMEAxf6htIwHe8JqxUhH3kwzZV9xBDMhu7f3ZNzQ7i80N2i
B6P2RtdIW56LFMMd5ufwisyu4FjWvobCBnqVyx02W40Qf7nGYtfZi1RcYnAYfH5b
k6yYm2BvaDPoxoLIfQu2
=tEYg
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab2IMWJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:09:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50731 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2IMWJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:09:44 -0400
Date: Thu, 13 Sep 2012 23:09:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] Pull request for x86 platform driver tree
Message-ID: <20120913220942.GA22238@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

A few small updates for 3.6 - a trivial regression fix and a couple of=20
conformance updates for the gmux driver, plus some tiny fixes for=20
asus-wmi, eeepc-laptop and thinkpad_acpi.

The following changes since commit 5b716ac728bcc01b1f2a7ed6e437196602237c27:

  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6 (2012-09-=
02 11:30:10 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to eceeb4371240aff22e9a535a2bc57d2311820942:

  thinkpad_acpi: buffer overflow in fan_get_status() (2012-09-13 16:46:31 -=
0400)

----------------------------------------------------------------
Bernhard Froemel (2):
      apple-gmux: Obtain version info from indexed gmux
      apple-gmux: Fix index read functions

Corentin Chary (2):
      drivers-platform-x86: remove useless #ifdef CONFIG_ACPI_VIDEO
      asus-laptop: HRWS/HWRS typo

Dan Carpenter (1):
      thinkpad_acpi: buffer overflow in fan_get_status()

Jiang Liu (1):
      eeepc-laptop: fix device reference count leakage in eeepc_rfkill_hotp=
lug()

Maxim Nikulin (1):
      platform/x86: fix asus_laptop.wled_type description

Seth Forshee (1):
      apple-gmux: Fix port address calculation in gmux_pio_write32()

 drivers/platform/x86/acer-wmi.c       |  2 --
 drivers/platform/x86/apple-gmux.c     | 24 +++++++++++++-----------
 drivers/platform/x86/asus-laptop.c    | 10 +++++-----
 drivers/platform/x86/asus-wmi.c       |  4 ----
 drivers/platform/x86/eeepc-laptop.c   | 10 ++++++----
 drivers/platform/x86/samsung-laptop.c |  4 ----
 drivers/platform/x86/thinkpad_acpi.c  | 13 +++++++------
 7 files changed, 31 insertions(+), 36 deletions(-)


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBSWaYACgkQ7Hkv8l1YiTvyLACfY5gRqR7INUv+COb4P71lIpvI
zl8AoLAd8MA1ruTrqz8qYfjv6n0rObIz
=OYNR
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--

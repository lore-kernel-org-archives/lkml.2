Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3AGRR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:17:28 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53777 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3AGRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:17:26 -0500
Date: Mon, 7 Jan 2013 17:17:22 +0000
From: Matthew Garrett <matthew.garrett@nebula.com>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform driver updates for 3.8
Message-ID: <20130107171722.GA31427@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

A bit delayed (new job fun), but there's nothing terribly exciting in=20
here.

The following changes since commit 11520e5e7c1855fc3bf202bb3be35a39d9efa034:

  Revert "x86-64/efi: Use EFI to deal with platform wall clock (again)" (20=
12-12-15 15:20:41 -0800)

are available in the git repository at:

  git://cavan.codon.org.uk/platform-drivers-x86.git linux-next

for you to fetch changes up to 6710c61d03d5bab8321208156113a31676967407:

  asus-laptop: Fix potential invalid pointer dereference (2012-12-28 10:54:=
42 -0500)

----------------------------------------------------------------
AceLan Kao (6):
      asus-wmi: update wlan LED through rfkill led trigger
      asus-laptop: correct a touchpad hotkey mapping
      asus-nb-wmi: correct a touchpad hotkey mapping
      asus-laptop: add all video switch keys
      asus-wmi: add display toggle quirk
      asus-nb-wmi: add all video switch keys

Ben Hutchings (1):
      asus-laptop: Do not call HWRS on init

Benson Leung (1):
      Platform: x86: Add Chrome OS Laptop driver

Bill Pemberton (5):
      platform/x86: remove use of __devinitdata
      platform/x86: remove use of __devinitconst
      platform/x86: remove use of __devexit
      platform/x86: remove use of __devexit_p
      platform/x86: remove use of __devinit

Corentin Chary (5):
      asus-laptop: map some new keys
      asus-{nb-wmi|laptop}.c: sync keymaps
      platform-drivers-x86: change my mail
      asus-wmi: always report brightness key events
      asus-laptop: always report brightness key events

Lee, Chun-Yi (6):
      msi-laptop: merge quirk tables to one
      MAINTAINERS: change the mail address of acer-wmi/msi-laptop maintainer
      acer-wmi: support Lenovo ideapad S205 10382JG wifi switch
      acer-wmi: fix obj is NULL but dereferenced
      acer-wmi: support Lenovo ideapad S205 1038DPG wifi switch
      acer-wmi: change to emit touchpad on off key

Manoj Iyer (1):
      thinkpad-acpi: enable loading module with new B-series Lenovo BIOS

Matthew Garrett (2):
      Update MAINTAINERS entry
      asus-laptop: Fix potential invalid pointer dereference

Mattia Dongili (4):
      sony-laptop: fully enable SNY controlled modems
      sony-laptop: fix SNC buffer calls when SN06 returns Integers
      sony-laptop: allow reading the status of gfx switch
      sony-laptop: support basic functions for handle 0x14B and 0x14C

Maxim Mikityanskiy (11):
      msi-laptop: Use proper return codes instead of -1
      msi-laptop: Work around gcc warning
      msi-laptop: Add MSI Wind U90/U100 support
      msi-laptop: Add missing ABI documentation
      msi-laptop: Disable brightness control for new EC
      msi-wmi: Fix memory leak
      msi-wmi: Avoid repeating constants
      msi-wmi: Use enums for scancodes
      msi-wmi: Make keys and backlight independent
      msi-wmi: Introduced quirk_last_pressed
      msi-wmi: Add MSI Wind support

Sergey Senozhatsky (1):
      acer-wmi: add Aspire 5741G touchpad toggle key

Seth Forshee (1):
      samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Trep=E1k Vilmos (1):
      Platform: hp-wmi: add rfkill support for integrated GPS

 .../ABI/testing/sysfs-platform-msi-laptop          |  83 +++++
 MAINTAINERS                                        |  10 +-
 drivers/platform/x86/Kconfig                       |  11 +
 drivers/platform/x86/Makefile                      |   1 +
 drivers/platform/x86/acer-wmi.c                    |  86 +++--
 drivers/platform/x86/acerhdf.c                     |   2 +-
 drivers/platform/x86/amilo-rfkill.c                |   4 +-
 drivers/platform/x86/apple-gmux.c                  |   6 +-
 drivers/platform/x86/asus-laptop.c                 | 110 +++---
 drivers/platform/x86/asus-nb-wmi.c                 |  78 ++++-
 drivers/platform/x86/asus-wmi.c                    | 115 ++++++-
 drivers/platform/x86/asus-wmi.h                    |   9 +
 drivers/platform/x86/chromeos_laptop.c             | 205 +++++++++++
 drivers/platform/x86/compal-laptop.c               |  10 +-
 drivers/platform/x86/dell-laptop.c                 |   4 +-
 drivers/platform/x86/eeepc-laptop.c                |   6 +-
 drivers/platform/x86/eeepc-wmi.c                   |   4 +-
 drivers/platform/x86/fujitsu-tablet.c              |  12 +-
 drivers/platform/x86/hp-wmi.c                      |  52 ++-
 drivers/platform/x86/ideapad-laptop.c              |  12 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |   6 +-
 drivers/platform/x86/intel_mid_thermal.c           |   2 +-
 drivers/platform/x86/intel_oaktrail.c              |   6 +-
 drivers/platform/x86/intel_pmic_gpio.c             |   2 +-
 drivers/platform/x86/msi-laptop.c                  | 374 ++++++++++++++++-=
----
 drivers/platform/x86/msi-wmi.c                     | 224 +++++++-----
 drivers/platform/x86/samsung-laptop.c              |  10 +
 drivers/platform/x86/samsung-q10.c                 |   6 +-
 drivers/platform/x86/sony-laptop.c                 | 158 ++++++++-
 drivers/platform/x86/tc1100-wmi.c                  |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |  10 +-
 drivers/platform/x86/toshiba_acpi.c                |  10 +-
 drivers/platform/x86/xo1-rfkill.c                  |   6 +-
 33 files changed, 1294 insertions(+), 344 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-msi-laptop
 create mode 100644 drivers/platform/x86/chromeos_laptop.c

--=20
Matthew Garrett | mjg59@srcf.ucam.org

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDrAyIACgkQ7Hkv8l1YiTuepgCfQNB05dZupfyGCJ6JV7M247kk
B18AniBPL+4Pkw22pkbFAgP4HLqAfa13
=Dn6b
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

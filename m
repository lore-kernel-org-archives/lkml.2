Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2C0PUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:20:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44029 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2C0PUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:20:33 -0400
Date: Tue, 27 Mar 2012 16:20:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 platform driver updates for 3.4
Message-ID: <20120327152031.GA7576@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Some significant updates to samsung-laptop, additional hardware support=20
for Toshibas, misc updates to various hardware and a new backlight=20
driver for some Apple machines.

The following changes since commit e22057c8599373e5caef0bc42bdb95d2a361ab0d:

  Merge tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/pub/scm/=
linux/kernel/git/konrad/xen (2012-03-24 12:20:25 -0700)

are available in the git repository at:

  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

AceLan Kao (4):
      dell-laptop: add 3 machines that has touchpad LED
      dell-laptop: touchpad LED should persist its status after S3
      asus-wmi: add scalar board brightness adj. support
      asus-wmi: store backlight power status for AIO machine

Alan Cox (2):
      intel_scu_ipc: Remove Moorestown support
      platform, x86: Kill off Moorestown

Axel Lin (1):
      platform-drivers-x86: convert drivers/platform/x86/* to use module_pl=
atform_driver()

Azael Avalos (1):
      toshiba_acpi: Support additional hotkey scancodes

Borislav Petkov (1):
      hdaps: Shut up gcc uninitialized variable warnings

Chih-Wei Huang (1):
      eeepc-wmi: add extra keymaps for EP121

Corentin Chary (33):
      samsung-laptop: put all local variables in a single structure
      samsung-laptop: move code into init/exit functions
      samsung-laptop: don't handle backlight if handled by acpi/video
      samsung-laptop: use a sysfs group
      samsung-laptop: ehance SABI support
      samsung-laptop: add a small debugfs interface
      samsung-laptop: remove selftest
      samsung-laptop: add battery life extender support
      samsung-laptop: add usb charge support
      samsung-laptop: cleanup KConfig
      samsung-laptop: add keyboard backlight support
      samsung-laptop: add true rfkill support for swsmi
      samsung-laptop: make the dmi check less strict
      samsung-laptop: dump model and version informations
      samsung-laptop: tweak traces
      samsung-laptop: promote myself as maintainer of samsung-laptop
      asus-laptop: log unknown keys
      eeepc-laptop: log unknown keys
      asus-laptop: cleanup rfkill code
      asus-laptop: control how BLED and WLED should be exposed
      asus-laptop: add rfkill interfaces for wlan and wwan
      asus-laptop: check WLED and BLED presence before adding rfkill
      platform/x86: drop deprecated asus_acpi driver
      asus-laptop: add some keys found on Lenovo SL500
      samsung-laptop: fix seclinux rfkill and us it as fallback
      asus-nb-wmi: ignore useless keys
      asus-wmi: on/off bit is not set when reading the value
      asus-wmi: move WAPF variable into quirks_entry
      asus-nb-wmi: set panel_power correctly
      eeepc-wmi: refine quirks handling
      eeepc-wmi: split et2012 specific hacks
      asus-wmi: don't update power and brightness when using scalar
      samsung-laptop: unregister ACPI video module for some well known lapt=
ops

Dan Carpenter (2):
      toshiba_acpi: make one-bit bitfields unsigned
      samsung-laptop: cleanup return type: mode_t vs umode_t

Danny Kukawka (1):
      hdaps: trivial fix for -Wuninitialized

David Rientjes (2):
      drivers, samsung-laptop: fix initialization of sabi_data in sabi_set_=
commandb
      drivers, samsung-laptop: fix usage of isalnum

Dmitry Torokhov (3):
      dell-laptop: switch to using use MODULE_DEVICE_TABLE
      compal-laptop: switch to using use MODULE_DEVICE_TABLE
      intel-oaktrail: switch to using use MODULE_DEVICE_TABLE

Jesper Juhl (1):
      drivers/platform/x86/amilo-rfkill.c::amilo_rfkill_probe() avoid NULL =
deref

Joe Perches (2):
      acer-wmi: Message logging neatening
      acerhdf: Message logging neatening

John Hughes (1):
      to fix scancodes returned by sony-laptop driver

Josh Boyer (1):
      sony-laptop: Enable keyboard backlight by default

Lee, Chun-Yi (6):
      acer-wmi: remove useless input argument for internal wmi
      acer-wmi: Detect communication hot key number
      acer-wmi: fix out of input parameter size when set
      acer-wmi: support Lenovo ideapad S205 Brazos wifi switch
      acer-wmi: No wifi rfkill on Sony machines
      acer-wmi: add quirk table for video backlight vendor mode

Manoj Iyer (1):
      thinkpad-acpi: recognize Lenovo as version string in newer V-series B=
IOS

Marcos Paulo de Souza (1):
      drivers/platform/x86/dell-laptop.c: Remove some unneeded break statem=
ents

Merlin Schumacher (1):
      acer-wmi: support for P key on TM8372

Michael Demeter (1):
      intel_mid_powerbtn: use MSIC read/write instead of ipc_scu

Mika Westerberg (4):
      platform-x86: intel_mid_thermal: add msic_thermal alias
      platform-x86: intel_mid_thermal: convert to use Intel MSIC API
      platform-x86: intel_mid_thermal: turn off thermistor voltage by defau=
lt
      x86, mrst: add msic_thermal platform support

Philip A. Prindeville (1):
      geos: Platform driver for Geos and Geos2 single-board computers.

Sergey Senozhatsky (1):
      acer-wmi: ignore missing Aspire 5741G keys (checkpatched)

Seth Forshee (5):
      ACPI: EC: Add ec_get_handle()
      toshiba_acpi: Support alternate hotkey interfaces
      toshiba_acpi: Refuse to load on machines with buggy INFO implementati=
ons
      apple_bl: Add register/unregister functions
      platform/x86: Add driver for Apple gmux device

 .../ABI/testing/sysfs-driver-samsung-laptop        |   18 +
 Documentation/laptops/asus-laptop.txt              |    2 +-
 Documentation/laptops/sony-laptop.txt              |    5 +
 MAINTAINERS                                        |    6 +
 arch/x86/Kconfig                                   |    7 +
 arch/x86/platform/geode/Makefile                   |    1 +
 arch/x86/platform/geode/geos.c                     |  128 ++
 arch/x86/platform/mrst/mrst.c                      |    6 +
 drivers/acpi/ec.c                                  |   10 +
 drivers/acpi/video_detect.c                        |    2 +-
 drivers/platform/x86/Kconfig                       |   95 +-
 drivers/platform/x86/Makefile                      |    7 +-
 drivers/platform/x86/acer-wmi.c                    |  152 ++-
 drivers/platform/x86/acerhdf.c                     |   19 +-
 drivers/platform/x86/amilo-rfkill.c                |    5 +-
 drivers/platform/x86/apple-gmux.c                  |  244 +++
 drivers/platform/x86/asus-laptop.c                 |  273 ++-
 drivers/platform/x86/asus-nb-wmi.c                 |   12 +-
 drivers/platform/x86/asus-wmi.c                    |   68 +-
 drivers/platform/x86/asus-wmi.h                    |   14 +-
 drivers/platform/x86/asus_acpi.c                   | 1513 -----------------
 drivers/platform/x86/compal-laptop.c               |   14 +-
 drivers/platform/x86/dell-laptop.c                 |   34 +-
 drivers/platform/x86/eeepc-laptop.c                |   13 +-
 drivers/platform/x86/eeepc-wmi.c                   |  108 +-
 drivers/platform/x86/hdaps.c                       |    8 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |   44 +-
 drivers/platform/x86/intel_mid_thermal.c           |   59 +-
 drivers/platform/x86/intel_oaktrail.c              |    2 +-
 drivers/platform/x86/intel_rar_register.c          |  669 --------
 drivers/platform/x86/intel_scu_ipc.c               |  206 +--
 drivers/platform/x86/intel_scu_ipcutil.c           |   32 +-
 drivers/platform/x86/samsung-laptop.c              | 1771 ++++++++++++++--=
----
 drivers/platform/x86/sony-laptop.c                 |   15 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/platform/x86/toshiba_acpi.c                |  254 +++-
 drivers/platform/x86/xo1-rfkill.c                  |   13 +-
 drivers/video/backlight/apple_bl.c                 |   23 +-
 include/linux/acpi.h                               |    1 +
 include/linux/apple_bl.h                           |   26 +
 include/linux/rar_register.h                       |   60 -
 41 files changed, 2536 insertions(+), 3405 deletions(-)
 create mode 100644 arch/x86/platform/geode/geos.c
 create mode 100644 drivers/platform/x86/apple-gmux.c
 delete mode 100644 drivers/platform/x86/asus_acpi.c
 delete mode 100644 drivers/platform/x86/intel_rar_register.c
 create mode 100644 include/linux/apple_bl.h
 delete mode 100644 include/linux/rar_register.h

--=20
Matthew Garrett | mjg59@srcf.ucam.org

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9x2r8ACgkQ7Hkv8l1YiTu/RgCbB/+BzN7azR+x/qYTiWzlm/ON
mYQAnir+REeTo9nKVUKLIskZeRiS9PTz
=kcnN
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--

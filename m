Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1C1MRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:17:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46489 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1C1MRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:17:08 -0400
Date: Mon, 28 Mar 2011 13:17:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT REQUEST] X86 platform driver updates for 2.6.39
Message-ID: <20110328121702.GA28056@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing overly exciting - a few minor bugfixes and some driver updates,
plus the driver for Samsung machines. There's some churn from the acer 
code being refactored.

The following changes since commit 18bcd0c8cb7d85a9063b88ec810dc1cdc0974518:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6 (2011-03-27 20:37:50 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Anssi Hannula (7):
      hp-wmi: check query return value in hp_wmi_perform_query
      hp-wmi: remove a variable that is never read
      hp-wmi: allow setting input and output buffer sizes separately
      hp-wmi: split rfkill initialization out of hp_wmi_bios_setup
      hp-wmi: clear rfkill device pointers when appropriate
      hp-wmi: make rfkill initialization failure non-fatal
      hp-wmi: add rfkill support for wireless query 0x1b

Axel Lin (3):
      platform-driver-x86: intel_mid_thermal: fix unterminated platform_device_id table
      platform-driver-x86: fix wrong merge for compal-laptop.c
      platform-driver-x86: samsung-laptop: make dmi_check_cb to return 1 instead of 0

Colin Ian King (1):
      Enable Dell All-In-One volume up/down keys

Corentin Chary (36):
      eeepc-wmi: reorder keymap
      eeepc-wmi: add wlan key found on 1015P
      eeepc-wmi: add hotplug code for Eeepc 1000H
      eeepc-wmi: serialize access to wmi method
      eeepc-wmi: return proper error code in eeepc_rfkill_set()
      eeepc-wmi: add an helper using simple return codes
      eeepc-wmi: add hibernate/resume callbacks
      eeepc-wmi: switch to platform_create_bundle()
      eeepc-wmi: reorder defines
      eeepc-wmi: use the presence bit correctly
      eeepc-wmi: add camera and card reader support
      eeepc-wmi: add wimax support
      eeepc-wmi: set the right key code for 0xe9
      eeepc-wmi: support backlight power (bl_power) attribute
      eeepc-wmi: respect wireless_hotplug setting
      eeepc-wmi: real touchpad led device id is 0x001000012
      eeepc-wmi: comments keymap to clarify the meaning of some keys
      asus-laptop: let WLED alone on L1400B
      asus-laptop: remove deprecated interfaces (lcd_switch and display_get)
      eeepc-wmi: add touchpad sysfs file
      eeepc-wmi: reorder device ids
      eeepc-wmi: add camera keys
      asus-wmi: move generic code to asus-wmi
      eeepc-wmi: asus generic asus-wmi.ko module
      asus-wmi: minor cleanups
      asus-wmi: introduce struct asus_rfkill
      asus-wmi: handle "unknown status" bit
      asus-wmi: factorise wmi_evaluate_method call
      asus-wmi: try to guess the right DSTS methods
      asus-wmi: fix and clean backlight code
      asus-wmi: add calls to INIT, SPEC and SFUN on init
      asus-wmi: allow debugfs interface to call arbitrary method
      asus-nb-wmi: Asus Notebooks WMI Driver
      asus-wmi: add some common device ids and method ids
      asus-wmi: add hwmon interface and pwm1
      eeepc-wmi: restore KEY_CAMERA_* keys lost in 190ca27

Dan Carpenter (6):
      sony-laptop: make a couple variables static
      sony-laptop: return negative on failure in sony_nc_add()
      sony-laptop: handle allocation failures
      sony-laptop: potential null dereference
      asus-wmi: signedness bug in read_brightness()
      asus-wmi: potential NULL dereference in show_call()

Durgadoss R (1):
      medfield: Add Thermal Driver

Greg Kroah-Hartman (1):
      Platform: add Samsung Laptop platform driver

Hong Liu (1):
      intel_mid_powerbtn: add power button driver for Medfield platform (#3)

Ike Panhc (2):
      ideapad: read brightness setting on brightness key notify
      ideapad: read brightness setting on brightness key notify

Jesse Barnes (1):
      ips: use interruptible waits in ips-monitor

Joey Lee (1):
      msi-laptop: use pr_<level> for messages

Keng-Yu Lin (1):
      eeepc-wmi: set the touchpad toggle key code to KEY_TOUCHPAD_TOGGLE

Lee, Chun-Yi (5):
      acer-wmi: set the touchpad toggle key code to KEY_TOUCHPAD_TOGGLE
      msi-laptop: send out touchpad on/off key
      acer-wmi: use pr_<level> for messages
      acer-wmi: does not set persistence state by rfkill_init_sw_state
      acer-wmi: does not poll device status when WMI event is available

Lucas De Marchi (1):
      platform-drivers: x86: fix common misspellings

Matthew Garrett (2):
      xo15-ebook: Remove device.wakeup_count
      Merge branch 'x86-platform-next' into x86-platform

Mattia Dongili (8):
      sony-laptop: add some debug printk useful for bug reports
      sony-laptop: documentation updates
      sony-laptop: ignore hard switch rfkill events (SPIC)
      sony-laptop: use pr_<level> for messages
      sony-laptop: remove unused Type4 define
      sony-laptop: cache handles and report them via sysfs
      sony-laptop: implement keyboard backlight support
      sony-laptop: implement new backlight control method

Pali Rohár (2):
      acer-wmi: deactive mail led when power off
      acer-wmi: Fix WMI ID

Paul Fox (1):
      OLPC XO-1.5 ebook switch driver

Randy Dunlap (2):
      platform/x86: intel_mid_powerbutton needs INPUT
      eeepc-wmi: kconfig changes to fix build errors

 .../ABI/testing/sysfs-driver-samsung-laptop        |   19 +
 Documentation/ABI/testing/sysfs-platform-asus-wmi  |   31 +
 Documentation/ABI/testing/sysfs-platform-eeepc-wmi |   10 -
 Documentation/laptops/sony-laptop.txt              |   37 +-
 MAINTAINERS                                        |   30 +-
 drivers/platform/x86/Kconfig                       |   90 +-
 drivers/platform/x86/Makefile                      |    9 +-
 drivers/platform/x86/acer-wmi.c                    |  127 +-
 drivers/platform/x86/asus-laptop.c                 |  182 +--
 drivers/platform/x86/asus-nb-wmi.c                 |   98 ++
 drivers/platform/x86/asus-wmi.c                    | 1656 ++++++++++++++++++++
 drivers/platform/x86/asus-wmi.h                    |   58 +
 drivers/platform/x86/compal-laptop.c               |    8 +-
 drivers/platform/x86/dell-wmi-aio.c                |  171 ++
 drivers/platform/x86/eeepc-laptop.c                |    2 +-
 drivers/platform/x86/eeepc-wmi.c                   |  912 +----------
 drivers/platform/x86/hp-wmi.c                      |  312 ++++-
 drivers/platform/x86/ideapad-laptop.c              |    2 +
 drivers/platform/x86/intel_ips.c                   |    2 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |  148 ++
 drivers/platform/x86/intel_mid_thermal.c           |  576 +++++++
 drivers/platform/x86/intel_rar_register.c          |    2 +-
 drivers/platform/x86/intel_scu_ipc.c               |    2 +-
 drivers/platform/x86/msi-laptop.c                  |   95 +-
 drivers/platform/x86/samsung-laptop.c              |  832 ++++++++++
 drivers/platform/x86/sony-laptop.c                 |  501 +++++--
 drivers/platform/x86/thinkpad_acpi.c               |    4 +-
 drivers/platform/x86/xo15-ebook.c                  |  180 +++
 include/linux/input.h                              |    7 +
 include/linux/sonypi.h                             |    1 +
 30 files changed, 4845 insertions(+), 1259 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-samsung-laptop
 create mode 100644 Documentation/ABI/testing/sysfs-platform-asus-wmi
 delete mode 100644 Documentation/ABI/testing/sysfs-platform-eeepc-wmi
 create mode 100644 drivers/platform/x86/asus-nb-wmi.c
 create mode 100644 drivers/platform/x86/asus-wmi.c
 create mode 100644 drivers/platform/x86/asus-wmi.h
 create mode 100644 drivers/platform/x86/dell-wmi-aio.c
 create mode 100644 drivers/platform/x86/intel_mid_powerbtn.c
 create mode 100644 drivers/platform/x86/intel_mid_thermal.c
 create mode 100644 drivers/platform/x86/samsung-laptop.c
 create mode 100644 drivers/platform/x86/xo15-ebook.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org

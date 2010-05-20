Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0ETOUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:20:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49625 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0ETOUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:20:51 -0400
Date: Thu, 20 May 2010 15:20:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT PULL] x86 platform driver updates for 2.6.35
Message-ID: <20100520142047.GA17279@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit e40152ee1e1c7a63f4777791863215e3faa37a86:
  Linus Torvalds (1):
        Linus 2.6.34

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86 for_linus

Daniel Mack (1):
      drivers/platform/x86/eeepc-wmi.c: fix build warning

Greg Kroah-Hartman (1):
      msi-laptop: fix up some coding style issues found by checkpatch

Henrique de Moraes Holschuh (15):
      Merge mainline (v2.6.34-rc7)
      thinkpad-acpi: constrain IBM-era support to IBM boxes
      thinkpad-acpi: X100e quick fixes
      thinkpad-acpi: fix volume/mute hotkey poll handling
      thinkpad-acpi: move greeting messages out of the first subdriver (v2)
      thinkpad-acpi: let other subdrivers know backlight level range
      thinkpad-acpi: fix brightness hotkey poll handling
      thinkpad-acpi: update HKEY and hotkey subdriver documentation (v2)
      thinkpad-acpi: disclose usertask for ALSA callbacks
      thinkpad-acpi: detect EC node using its HID (v2)
      thinkpad-acpi: acpi_evalf fixes
      thinkpad-acpi: explain errors from acpi_install_notify_handler
      thinkpad-acpi: don't depend on led_path for led firmware type (v2)
      thinkpad-acpi: clean up ACPI handles handling
      thinkpad-acpi: document backlight level writeback at driver init

Julia Lawall (2):
      drivers/platform/x86: Use kzalloc
      drivers/platform/x86: Use kmemdup

Lee, Chun-Yi (6):
      msi-laptop: Add N014 N051 dmi information to scm models table
      msi-laptop: Add MSI CR620 notebook dmi information to scm models table
      msi-laptop: Set rfkill init state when msi-laptop intiial
      msi-laptop: Add i8042 filter to sync sw state with BIOS when function key pressed
      Clean up all objects used by scm model when driver initial fail or exit
      Move N014, N051 and CR620 dmi information to load scm dmi table

Matthew Garrett (3):
      drivers/platform/x86: Clarify the MRST IPC driver description slightly
      Merge branch 'x86-platform-next' into x86-platform
      Merge branch 'for-upstream/platform-x86_tpacpi' of git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6 into x86-platform

Randy Dunlap (2):
      eeepc-wmi: depends on BACKLIGHT_CLASS_DEVICE
      eeepc-wmi: depends on BACKLIGHT_CLASS_DEVICE

Sreedhara DS (1):
      IPC driver for Intel Mobile Internet Device (MID) platforms

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: Add RFKILL support.

Thomas Renninger (3):
      X86 platform wmi: Introduce debug param to log all WMI events
      X86 platform wmi: Also log GUID string when an event happens and debug is set
      X86 platfrom wmi: Add debug facility to dump WMI data in a readable way

 Documentation/laptops/thinkpad-acpi.txt |   66 ++-
 arch/x86/include/asm/intel_scu_ipc.h    |   55 ++
 drivers/platform/x86/Kconfig            |   10 +
 drivers/platform/x86/Makefile           |    1 +
 drivers/platform/x86/classmate-laptop.c |  170 ++++++-
 drivers/platform/x86/eeepc-wmi.c        |    2 +-
 drivers/platform/x86/fujitsu-laptop.c   |    6 +-
 drivers/platform/x86/intel_scu_ipc.c    |  829 +++++++++++++++++++++++++++++++
 drivers/platform/x86/msi-laptop.c       |  163 ++++++-
 drivers/platform/x86/thinkpad_acpi.c    |  600 ++++++++++++++---------
 drivers/platform/x86/wmi.c              |  103 ++++-
 11 files changed, 1710 insertions(+), 295 deletions(-)
 create mode 100644 arch/x86/include/asm/intel_scu_ipc.h
 create mode 100644 drivers/platform/x86/intel_scu_ipc.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org

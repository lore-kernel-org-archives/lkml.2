Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1E2Sa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:30:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41975 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab1E2Sa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:30:28 -0400
Date: Sun, 29 May 2011 19:30:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] x86 platform driver pull request
Message-ID: <20110529183022.GA28339@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 139f37f5e14cd883eee2a8a36289f544b5390a44:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin (2011-05-28 23:12:28 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Ameya Palande (4):
      platform-x86: intel_mid_thermal: Fix coding style
      platform/x86: Simplify intel_mid_powerbtn
      platform/x86: Fix Makefile for intel_mid_powerbtn
      platform-x86: intel_mid_thermal: Fix memory leak

Carlos Corbacho (4):
      tc1100-wmi: Orphan driver
      wmi: Orphan ACPI-WMI driver
      acer-wmi: Update MAINTAINERS
      acer-wmi: Delete out-of-date documentation

Jean Delvare (2):
      acerhdf: Drop pointless dependency on THERMAL_HWMON
      acerhdf: Clean up includes

Joe Perches (24):
      asus-wmi: Remove __init from asus_wmi_platform_init
      ibm_rtl: Remove warnings from casts of pointer to int
      acer-wmi: pr_<level> cleanups
      asus: Add pr_fmt and convert printks to pr_<level>
      compal-laptop: Convert printks to pr_<level>
      dell: Convert printks to pr_<level>
      eeepc: Use pr_warn
      fujitsu-laptop: Convert printks to pr_<level>
      hdaps: Convert printks to pr_<level>
      hp-wmi: Convert printks to pr_<level>
      ibm_rtl: Use pr_fmt and pr_<level>
      ideapad-laptop: Add pr_fmt
      intel_menlow: Add pr_fmt and use pr_<level>
      intel_pmic_gpio: Convert printks to pr_<level>
      msi-laptop: pr_<level> neatening
      msi-wmi: Use pr_fmt and pr_<level>
      sony-laptop: Add and use #define pr_fmt
      tc1100-wmi: Add pr_fmt, use pr_<level>
      topstar-laptop: Convert remaining printk to pr_info
      toshiba: Convert printks to pr_<level>
      wmi: Removed trailing whitespace from logging message.
      xo15-ebook: Use pr_<level>
      thinkpad_acpi: Correct !CONFIG_THINKPAD_ACPI_VIDEO warning
      thinkpad_acpi: Convert printks to pr_<level>

Lee, Chun-Yi (6):
      acer-wmi: does not allow negative number set to initial device state
      acer-wmi: check the existence of internal 3G device when set capability
      acer-wmi: allow 64-bits return buffer from WMI methods
      acer-wmi: support to set communication device state by new wmid method
      msi-laptop: fix section mismatch in reference from the function load_scm_model_init
      acer-wmi: support integer return type from WMI methods

Matthew Garrett (1):
      Merge branch 'x86-platform-next' into x86-platform

Melchior FRANZ (1):
      support wlan hotkey on Acer Travelmate 5735Z

Weiping Pan (1):
      platform/x86:delete two unused variables

Yin Kangkai (1):
      platform/oaktrail: ACPI EC Extra driver for Oaktrail

 Documentation/laptops/acer-wmi.txt        |  184 ---------
 MAINTAINERS                               |   11 +-
 drivers/platform/x86/Kconfig              |   11 +-
 drivers/platform/x86/Makefile             |    3 +-
 drivers/platform/x86/acer-wmi.c           |  184 ++++++++--
 drivers/platform/x86/acerhdf.c            |    4 +-
 drivers/platform/x86/asus-laptop.c        |   34 +-
 drivers/platform/x86/asus-wmi.c           |   22 +-
 drivers/platform/x86/asus_acpi.c          |   77 ++---
 drivers/platform/x86/compal-laptop.c      |   22 +-
 drivers/platform/x86/dell-laptop.c        |   12 +-
 drivers/platform/x86/dell-wmi-aio.c       |    3 +-
 drivers/platform/x86/dell-wmi.c           |   17 +-
 drivers/platform/x86/eeepc-laptop.c       |   21 +-
 drivers/platform/x86/eeepc-wmi.c          |   14 +-
 drivers/platform/x86/fujitsu-laptop.c     |   39 +-
 drivers/platform/x86/hdaps.c              |   19 +-
 drivers/platform/x86/hp-wmi.c             |   43 +--
 drivers/platform/x86/ibm_rtl.c            |   23 +-
 drivers/platform/x86/ideapad-laptop.c     |    2 +
 drivers/platform/x86/intel_menlow.c       |    5 +-
 drivers/platform/x86/intel_mid_powerbtn.c |   72 ++--
 drivers/platform/x86/intel_mid_thermal.c  |  607 ++++++++++++++---------------
 drivers/platform/x86/intel_oaktrail.c     |  396 +++++++++++++++++++
 drivers/platform/x86/intel_pmic_gpio.c    |   14 +-
 drivers/platform/x86/msi-laptop.c         |   11 +-
 drivers/platform/x86/msi-wmi.c            |   45 +--
 drivers/platform/x86/sony-laptop.c        |  106 +++---
 drivers/platform/x86/tc1100-wmi.c         |    7 +-
 drivers/platform/x86/thinkpad_acpi.c      |  490 ++++++++++--------------
 drivers/platform/x86/topstar-laptop.c     |    2 +-
 drivers/platform/x86/toshiba_acpi.c       |   59 ++--
 drivers/platform/x86/toshiba_bluetooth.c  |   11 +-
 drivers/platform/x86/wmi.c                |   10 +-
 drivers/platform/x86/xo15-ebook.c         |    5 +-
 35 files changed, 1393 insertions(+), 1192 deletions(-)
 delete mode 100644 Documentation/laptops/acer-wmi.txt
 create mode 100644 drivers/platform/x86/intel_oaktrail.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org

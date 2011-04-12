Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1DLPbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:31:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49007 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1DLPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:31:35 -0400
Date: Tue, 12 Apr 2011 16:31:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] X86 platform drivers updates
Message-ID: <20110412153130.GA32247@srcf.ucam.org>
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

Hi Linus,

Small number of updates, including removing the duplicate copy of 
samsung-laptop (miscommunication between Greg and me) and some 
miscellaneous fixes.

The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:

  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Alberto Mardegan (1):
      samsung-laptop: Samsung R410P backlight driver

Corentin Chary (3):
      asus-laptop: remove removed features from feature-removal-schedule.txt
      asus-wmi: swap input name and phys
      eeepc-wmi: add keys found on EeePC 1215T

Greg Kroah-Hartman (1):
      samsung-laptop: add support for N230 model

Keith Packard (1):
      thinkpad-acpi fails to load with newer Thinkpad X201s BIOS

Lee, Chun-Yi (1):
      acer-wmi: Fix capitalisation of GUID in module alias

Marco Chiappero (1):
      sony-laptop: keyboard backlight fixes

Mattia Dongili (2):
      sony-laptop: fix early NULL pointer dereference
      sony-laptop: only show the handles sysfs file in debug mode

Michal Marek (2):
      staging: samsung-laptop has moved to platform/x86
      samsung-laptop: set backlight type

Randy Dunlap (1):
      msi-laptop: fix config-dependent build error

Thomas Gleixner (1):
      platform-drivers: x86: pmic: Restore the dropped buslock/unlock

 Documentation/feature-removal-schedule.txt      |   20 -
 drivers/platform/x86/Kconfig                    |    3 +-
 drivers/platform/x86/acer-wmi.c                 |    2 +-
 drivers/platform/x86/asus-wmi.c                 |    4 +-
 drivers/platform/x86/eeepc-wmi.c                |    2 +
 drivers/platform/x86/intel_pmic_gpio.c          |   43 +-
 drivers/platform/x86/samsung-laptop.c           |   17 +-
 drivers/platform/x86/sony-laptop.c              |   65 ++-
 drivers/platform/x86/thinkpad_acpi.c            |    3 +-
 drivers/staging/Kconfig                         |    2 -
 drivers/staging/Makefile                        |    1 -
 drivers/staging/samsung-laptop/Kconfig          |   10 -
 drivers/staging/samsung-laptop/Makefile         |    1 -
 drivers/staging/samsung-laptop/TODO             |    5 -
 drivers/staging/samsung-laptop/samsung-laptop.c |  843 -----------------------
 15 files changed, 114 insertions(+), 907 deletions(-)
 delete mode 100644 drivers/staging/samsung-laptop/Kconfig
 delete mode 100644 drivers/staging/samsung-laptop/Makefile
 delete mode 100644 drivers/staging/samsung-laptop/TODO
 delete mode 100644 drivers/staging/samsung-laptop/samsung-laptop.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org

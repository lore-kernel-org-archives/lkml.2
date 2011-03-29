Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1C2WWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:12 -0400
Received: from mail.perches.com ([173.55.12.10]:4341 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1C2WWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:11 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        ibm-acpi-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/23] drivers/platform/x86: Remove warnings and use pr_<level>
Date: Tue, 29 Mar 2011 15:21:31 -0700
Message-Id: <cover.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a couple of compilation warnings.
Use pr_<level> consistently.

Joe Perches (23):
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
  thinkpad_acpi: Convert printks to pr_<level>
  topstar-laptop: Convert remaining printk to pr_info
  toshiba: Convert printks to pr_<level>
  wmi: Removed trailing whitespace from logging message.
  xo15-ebook: Use pr_<level>

 drivers/platform/x86/acer-wmi.c          |   32 +-
 drivers/platform/x86/asus-laptop.c       |   34 +-
 drivers/platform/x86/asus-wmi.c          |   22 +-
 drivers/platform/x86/asus_acpi.c         |   77 ++---
 drivers/platform/x86/compal-laptop.c     |   22 +-
 drivers/platform/x86/dell-laptop.c       |   12 +-
 drivers/platform/x86/dell-wmi-aio.c      |    3 +-
 drivers/platform/x86/dell-wmi.c          |   17 +-
 drivers/platform/x86/eeepc-laptop.c      |   20 +-
 drivers/platform/x86/eeepc-wmi.c         |   14 +-
 drivers/platform/x86/fujitsu-laptop.c    |   39 ++--
 drivers/platform/x86/hdaps.c             |   19 +-
 drivers/platform/x86/hp-wmi.c            |   43 +--
 drivers/platform/x86/ibm_rtl.c           |   23 +-
 drivers/platform/x86/ideapad-laptop.c    |    2 +
 drivers/platform/x86/intel_menlow.c      |    5 +-
 drivers/platform/x86/intel_pmic_gpio.c   |   14 +-
 drivers/platform/x86/msi-laptop.c        |    9 +-
 drivers/platform/x86/msi-wmi.c           |   45 ++--
 drivers/platform/x86/sony-laptop.c       |  104 +++----
 drivers/platform/x86/tc1100-wmi.c        |    7 +-
 drivers/platform/x86/thinkpad_acpi.c     |  471 ++++++++++++------------------
 drivers/platform/x86/topstar-laptop.c    |    2 +-
 drivers/platform/x86/toshiba_acpi.c      |   59 ++--
 drivers/platform/x86/toshiba_bluetooth.c |   11 +-
 drivers/platform/x86/wmi.c               |   10 +-
 drivers/platform/x86/xo15-ebook.c        |    5 +-
 27 files changed, 495 insertions(+), 626 deletions(-)

-- 
1.7.4.2.g597a6.dirty


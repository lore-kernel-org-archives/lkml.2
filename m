Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1G2RnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:43:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:6122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1G2RnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,288,1309762800"; 
   d="scan'208";a="33603541"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git pull] pstore + ia64 changes
Date: Fri, 29 Jul 2011 10:43:19 -0700
Message-Id: <4e32f13721205e7dbe@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release

This will update the files shown below.

Thanks!

-Tony

 Documentation/ABI/testing/pstore    |    6 +
 Documentation/kernel-parameters.txt |    2 +
 arch/ia64/Kconfig                   |    4 +
 arch/ia64/include/asm/gpio.h        |   55 ++++++++
 drivers/acpi/apei/erst.c            |   20 ++-
 drivers/firmware/efivars.c          |  243 +++++++++++++++++++++++++++++++++--
 fs/pstore/inode.c                   |   12 +-
 fs/pstore/internal.h                |    2 +-
 fs/pstore/platform.c                |   30 +++-
 include/linux/efi.h                 |    6 +
 include/linux/pstore.h              |    9 +-
 11 files changed, 355 insertions(+), 34 deletions(-)
 create mode 100644 arch/ia64/include/asm/gpio.h

Mark Brown (1):
      [IA64] Hook up gpiolib support

Matthew Garrett (5):
      pstore: Extend API for more flexibility in new backends
      pstore: Add extra context for writes and erases
      pstore: Make "part" unsigned
      pstore: Allow the user to explicitly choose a backend
      efi: Add support for using efivars as a pstore backend

Mike Waychison (4):
      efivars: String functions
      efivars: introduce utf16_strncmp
      efivars: Use string functions in pstore_write
      efivars: Introduce PSTORE_EFI_ATTRIBUTES


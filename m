Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HAQ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:56:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:34381 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1HAQ4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:56:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,301,1309762800"; 
   d="scan'208";a="32918489"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] pstore changes
Date: Mon, 01 Aug 2011 09:56:52 -0700
Message-Id: <4e36dad425294f12e2@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git pstore-efi

This will update the files shown below - adding a new pstore backend that
uses EFI variables as persistant storage.

Thanks!

-Tony

 Documentation/ABI/testing/pstore    |    6 +
 Documentation/kernel-parameters.txt |    2 +
 drivers/acpi/apei/erst.c            |   20 ++-
 drivers/firmware/efivars.c          |  243 +++++++++++++++++++++++++++++++++--
 fs/pstore/inode.c                   |   12 +-
 fs/pstore/internal.h                |    2 +-
 fs/pstore/platform.c                |   30 +++-
 include/linux/efi.h                 |    6 +
 include/linux/pstore.h              |    9 +-
 9 files changed, 296 insertions(+), 34 deletions(-)

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


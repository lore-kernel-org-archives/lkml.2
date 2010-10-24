Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab0JXNJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 09:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab0JXNJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 09:09:54 -0400
Message-ID: <4CC43017.5010105@redhat.com>
Date: Sun, 24 Oct 2010 11:09:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: [GIT PULL for 2.6.36-rc1] i7300 EDAC driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git devel

For a new EDAC driver for Intel 7300 chipsets.

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git devel

Mauro Carvalho Chehab (25):
      i7300_edac: start a driver for i7300 chipset (Clarksboro)
      i7300_edac: display info if ECC is enabled or not
      i7300_edac: add global error registers
      i7300_edac: Add a FIXME note about the error correction type
      i7300_edac: Better name PCI devices
      i7300_edac: Add error detection code for global errors
      i7300_edac: Clear the error bit after reading
      i7300_edac: Adds detection for enhanced scrub mode on x8
      i7300_edac: Detect if the device is on single mode
      i7300_edac: Properly detect the type of error correction
      i7300_edac: Add support for reporting FBD errors
      i7300_edac: Add a code to cleanup error registers
      i7300_edac: Cleanup: remove get_error_info logic
      i7300_edac: Make the debug messages coherent with the others
      i7300_edac: Fix MTR x4/x8 detection logic
      i7300_edac: pre-allocate a buffer used to prepare err messages
      i7300_edac: enrich FBD error info for fatal errors
      i7300_edac: enrich FBD error info for corrected errors
      i7300_edac: Properly detect channel on CE errors
      i7300_edac: Cleanup: reorganize the file contents
      i7300_edac: Improve comments
      i7300-edac: CodingStyle cleanup
      MAINTAINERS: Add maintainer for i7300-edac driver
      V4L/DVB: i7300_edac: better initialize page counts
      i7300_edac: Properly initialize per-csrow memory size

 MAINTAINERS               |    7 +
 drivers/edac/Kconfig      |    7 +
 drivers/edac/Makefile     |    1 +
 drivers/edac/i7300_edac.c | 1247 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |   19 +-
 5 files changed, 1273 insertions(+), 8 deletions(-)
 create mode 100644 drivers/edac/i7300_edac.c

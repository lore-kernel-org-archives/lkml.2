Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3ABSsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:48:24 -0500
Received: from mail-vc0-f201.google.com ([209.85.220.201]:61605 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3ABSsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:48:22 -0500
Date: Wed, 2 Jan 2013 11:48:21 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Huang Ying <ying.huang@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [GIT PULL] PCI updates for v3.8
Message-ID: <20130102184821.GA31813@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some fixes for v3.8.  They include a fix for the new SR-IOV
sysfs management support, an expanded quirk for Ricoh SD card readers,
a Stratus DMI quirk fix, and a PME polling fix.

Bjorn


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/3.8-pci-fixes

for you to fetch changes up to 812089e01b9f65f90fc8fc670d8cce72a0e01fbb:

  PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz (2012-12-26 10:43:06 -0700)

----------------------------------------------------------------
PCI updates for v3.8:

  PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz
  PCI: Remove spurious error for sriov_numvfs store and simplify flow
  PCI: Add PCIe Link Capability link speed and width names
  PCI/PM: Do not suspend port if any subordinate device needs PME polling
  PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)

----------------------------------------------------------------
Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Bjorn Helgaas (2):
      PCI: Remove spurious error for sriov_numvfs store and simplify flow
      PCI: Add PCIe Link Capability link speed and width names

Huang Ying (1):
      PCI/PM: Do not suspend port if any subordinate device needs PME polling

Myron Stowe (1):
      PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)

 arch/x86/pci/common.c          |  3 +-
 drivers/pci/pci-sysfs.c        | 85 +++++++++++++++++-------------------------
 drivers/pci/pcie/portdrv_pci.c | 20 +++++++++-
 drivers/pci/quirks.c           |  7 +++-
 include/linux/pci_ids.h        |  1 +
 include/uapi/linux/pci_regs.h  |  2 +
 6 files changed, 63 insertions(+), 55 deletions(-)

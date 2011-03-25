Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1CYRWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:22:40 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:47399 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752072Ab1CYRWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d7h/4x0RlqTWZbGcx6DatLtPFJDwtZC7mMc6LOP21TgTVSZ15fhvFhCIZW1g0GnNg8DDdgu7eHE8qZnnQapozLVz8/qzxVIN+Y8zFqyoI86MJAAgSGHrxhTdK/WVdbQs;
Date: Fri, 25 Mar 2011 10:22:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20110325102231.44ea28dc@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
a44f99c7efdb88fa41128065c9a9445c19894e34:

  Merge branch 'trivial' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6 (2011-03-20 18:14:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

A few misc. fixes.

Naga Chumbalkar (3):
      PCI: PCIe links may not get configured for ASPM under POWERSAVE mode
      PCI: Changing ASPM policy, via /sys, to POWERSAVE could cause NMIs
      PCI: Disable ASPM when _OSC control is not granted for PCIe services

Rafael J. Wysocki (1):
      PCI/ACPI: Report ASPM support to BIOS if not disabled from command line

 drivers/acpi/pci_root.c         |   11 ++++++++---
 drivers/pci/pci.c               |    6 ++++++
 drivers/pci/pcie/aspm.c         |   33 +++++++++++++++++++++++++++++++++
 drivers/pci/pcie/portdrv_core.c |    5 +----
 include/linux/pci-aspm.h        |    4 ++++
 include/linux/pci.h             |    7 +++----
 6 files changed, 55 insertions(+), 11 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center

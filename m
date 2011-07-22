Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1GVDdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:33:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46845 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1GVDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:33:37 -0400
Date: Thu, 21 Jul 2011 23:33:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/pci.cleanups.v1 for 3.1
Message-ID: <20110722033321.GB22901@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E28EF8E.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/pci.cleanups.v1

which has patches since git commit 075d9db13183c102770dc6cefabfee1b832f9614
Linus Torvalds (1):
    Merge branch 'stable/bug.fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen

This patchset cleans ups the Xen PCI glue code. No major improvements but it sure
makes the code easier to read.

Konrad Rzeszutek Wilk (10):
      xen/pci: Shuffle code around.
      xen/pci: Update comments and fix empty spaces.
      xen/pci: Provide #ifdef CONFIG_ACPI to easy code squashing.
      xen/pci: In xen_register_pirq bind the GSI to the IRQ after the hypercall.
      xen/pci: Use the xen_register_pirq for HVM and initial domain users
      xen/pci: Squash pci_xen_initial_domain and xen_setup_pirqs together.
      xen/pci: Move the allocation of IRQs when there are no IOAPIC's to the end
      xen/pci: Retire unnecessary #ifdef CONFIG_ACPI
      xen/pci: Remove 'xen_allocate_pirq_gsi'.
      xen/pci: Use 'acpi_gsi_to_irq' value unconditionally.

 arch/x86/include/asm/xen/pci.h |    5 +-
 arch/x86/pci/xen.c             |  371 +++++++++++++++++-----------------------
 drivers/xen/events.c           |    7 +-
 include/xen/events.h           |    2 -
 4 files changed, 165 insertions(+), 220 deletions(-)

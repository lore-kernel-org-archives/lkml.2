Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab2DFSCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:02:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42666 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2DFSCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:02:42 -0400
Date: Fri, 6 Apr 2012 13:57:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: jinsong.liu@intel.com, jbeulich@suse.com, srivatsa.bhat@linux.vnet.ibm.com,
        drjones@redhat.com, imammedo@redhat.com
Subject: [GIT PULL] (xen) stable/for-linus-3.4-rc1-tag for v3.4-rc1.
Message-ID: <20120406175749.GA21325@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F7F2FBA.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.4-rc1-tag

which has two fixes for regressions:
 - one is a workaround that will be removed in v3.5 with proper fix in the tip/x86 tree,
 - the other is to fix drivers to load on PV (a previous patch made them only
   load in PVonHVM mode).

The rest are just minor fixes in the various drivers and some cleanup in the
core code. Nothing exciting.

 arch/x86/xen/mmu.c                    |    4 +++-
 arch/x86/xen/smp.c                    |    2 +-
 drivers/block/xen-blkfront.c          |    2 +-
 drivers/net/xen-netfront.c            |    2 +-
 drivers/pci/xen-pcifront.c            |    1 +
 drivers/xen/xen-pciback/pciback_ops.c |    2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

Igor Mammedov (1):
      xen: only check xen_platform_pci_unplug if hvm

Jan Beulich (2):
      xen/pciback: fix XEN_PCI_OP_enable_msix result
      xen/pcifront: avoid pci_frontend_enable_msix() falsely returning success

Konrad Rzeszutek Wilk (1):
      xen/x86: Workaround 'x86/ioapic: Add register level checks to detect bogus io-apic entries'

Srivatsa S. Bhat (1):
      xen/smp: Remove unnecessary call to smp_processor_id()

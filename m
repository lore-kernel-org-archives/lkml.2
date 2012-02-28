Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966024Ab2B1Stu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:49:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40694 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965988Ab2B1Sts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:49:48 -0500
From: Joe Perches <joe@perches.com>
To: linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH trivial next 0/9] treewide: Use vsprintf extention %pf
Date: Tue, 28 Feb 2012 10:49:29 -0800
Message-Id: <cover.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the actual function name when possible

Joe Perches (9):
  sparc: Use vsprintf extention %pf with builtin_return_address
  alpha: Use vsprintf extention %pf with builtin_return_address
  arm: Use vsprintf extention %pf with builtin_return_address
  microblaze: Use vsprintf extention %pf with builtin_return_address
  powerpc: Use vsprintf extention %pf with builtin_return_address
  parisc: Use vsprintf extention %pf with builtin_return_address
  scsi: Use vsprintf extention %pf with builtin_return_address
  staging: ramster: Use vsprintf extention %pf with builtin_return_address
  gadget: Use vsprintf extention %pf with builtin_return_address

 arch/alpha/kernel/pci_iommu.c               |   20 ++++++++++----------
 arch/arm/nwfpe/fpmodule.c                   |    2 +-
 arch/microblaze/mm/pgtable.c                |    2 +-
 arch/powerpc/mm/pgtable_32.c                |    2 +-
 arch/sparc/kernel/ds.c                      |    2 +-
 arch/sparc/mm/srmmu.c                       |    2 +-
 drivers/parisc/superio.c                    |    2 +-
 drivers/scsi/esp_scsi.c                     |    2 +-
 drivers/staging/ramster/cluster/heartbeat.c |    4 ++--
 drivers/usb/gadget/u_serial.c               |    2 +-
 10 files changed, 20 insertions(+), 20 deletions(-)

-- 
1.7.8.111.gad25c.dirty


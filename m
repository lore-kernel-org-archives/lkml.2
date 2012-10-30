Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2J3JlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:41:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55144 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757423Ab2J3JlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:41:18 -0400
Message-ID: <1351590074.32167.1.camel@joe-AO722>
Subject: Re: [pci:pci/misc 1/4] drivers/scsi/gdth.c:1111:41: sparse: not an
 lvalue
From: Joe Perches <joe@perches.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Oct 2012 02:41:14 -0700
In-Reply-To: <508f513a.dVOhrUH2oKbstSV1%fengguang.wu@intel.com>
References: <508f513a.dVOhrUH2oKbstSV1%fengguang.wu@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 12:02 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/misc
> head:   347593eb10fce5b691551d72cf63f1ea6a533f2a
> commit: 545974a28f786eb0ed42c90b4b5df9605b1d824c [1/4] PCI: Convert pci_resource_<foo> macros to static inlines
> 
> 
> sparse warnings:
> 
> drivers/scsi/gdth.c:2397:31: sparse: incorrect type in assignment (different base types)
> drivers/scsi/gdth.c:2397:31:    expected unsigned int [unsigned] [assigned] [usertype] last_block_no
> drivers/scsi/gdth.c:2397:31:    got restricted __be32 [usertype] <noident>
> drivers/scsi/gdth.c:2398:27: sparse: incorrect type in assignment (different base types)
> drivers/scsi/gdth.c:2398:27:    expected unsigned int [unsigned] [assigned] [usertype] block_length
> drivers/scsi/gdth.c:2398:27:    got restricted __be32 [usertype] <noident>
> drivers/scsi/gdth.c:2408:33: sparse: incorrect type in assignment (different base types)
> drivers/scsi/gdth.c:2408:33:    expected unsigned long long [unsigned] [usertype] last_block_no
> drivers/scsi/gdth.c:2408:33:    got restricted __be64 [usertype] <noident>
> drivers/scsi/gdth.c:2409:33: sparse: incorrect type in assignment (different base types)
> drivers/scsi/gdth.c:2409:33:    expected unsigned int [unsigned] [usertype] block_length
> drivers/scsi/gdth.c:2409:33:    got restricted __be32 [usertype] <noident>
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2504:23: sparse: cast to restricted __be64
> drivers/scsi/gdth.c:2506:24: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2506:24: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2506:24: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2506:24: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2506:24: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2506:24: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2509:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2509:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2509:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2509:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2509:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2509:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2511:24: sparse: cast to restricted __be16
> drivers/scsi/gdth.c:2511:24: sparse: cast to restricted __be16
> drivers/scsi/gdth.c:2511:24: sparse: cast to restricted __be16
> drivers/scsi/gdth.c:2511:24: sparse: cast to restricted __be16
> drivers/scsi/gdth.c:2514:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2514:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2514:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2514:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2514:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:2514:23: sparse: cast to restricted __be32
> drivers/scsi/gdth.c:445:5: sparse: symbol '__gdth_execute' was not declared. Should it be static?
> + drivers/scsi/gdth.c:1111:41: sparse: not an lvalue
> drivers/scsi/gdth.c: In function 'gdth_init_pci':
> drivers/scsi/gdth.c:1111:34: error: lvalue required as left operand of assignment
> --
> + drivers/staging/telephony/ixj.c:7732:52: sparse: Expected ; at end of statement
> + drivers/staging/telephony/ixj.c:7732:52: sparse: got pci_resource_start
> drivers/staging/telephony/ixj.c: In function 'ixj_probe_pci':
> drivers/staging/telephony/ixj.c:7732:13: warning: assignment makes integer from pointer without a cast [enabled by default]
> drivers/staging/telephony/ixj.c:7732:38: error: expected ';' before 'pci_resource_start'
> 
> vim +1111 drivers/scsi/gdth.c
> 
> ^1da177e Linus Torvalds 2005-04-16  1095  
> ^1da177e Linus Torvalds 2005-04-16  1096          ha->dma64_support = 0;
> ^1da177e Linus Torvalds 2005-04-16  1097  
> ^1da177e Linus Torvalds 2005-04-16  1098      } else {                                            /* MPR */
> ^1da177e Linus Torvalds 2005-04-16  1099          TRACE2(("init_pci_mpr() dpmem %lx irq %d\n",pcistr->dpmem,ha->irq));
> ^1da177e Linus Torvalds 2005-04-16  1100          ha->brd = ioremap(pcistr->dpmem, sizeof(gdt6m_dpram_str));
> ^1da177e Linus Torvalds 2005-04-16  1101          if (ha->brd == NULL) {
> ^1da177e Linus Torvalds 2005-04-16  1102              printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
> ^1da177e Linus Torvalds 2005-04-16  1103              return 0;
> ^1da177e Linus Torvalds 2005-04-16  1104          }
> ^1da177e Linus Torvalds 2005-04-16  1105  
> ^1da177e Linus Torvalds 2005-04-16  1106          /* manipulate config. space to enable DPMEM, start RP controller */
> 4c9c8d78 Jeff Garzik    2008-02-15  1107  	pci_read_config_word(pdev, PCI_COMMAND, &command);
> ^1da177e Linus Torvalds 2005-04-16  1108          command |= 6;
> 4c9c8d78 Jeff Garzik    2008-02-15  1109  	pci_write_config_word(pdev, PCI_COMMAND, command);
> 4c9c8d78 Jeff Garzik    2008-02-15  1110  	if (pci_resource_start(pdev, 8) == 1UL)
> 4c9c8d78 Jeff Garzik    2008-02-15 @1111  	    pci_resource_start(pdev, 8) = 0UL;
> ^1da177e Linus Torvalds 2005-04-16  1112          i = 0xFEFF0001UL;
> 4c9c8d78 Jeff Garzik    2008-02-15  1113  	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, i);
> ^1da177e Linus Torvalds 2005-04-16  1114          gdth_delay(1);
> 4c9c8d78 Jeff Garzik    2008-02-15  1115  	pci_write_config_dword(pdev, PCI_ROM_ADDRESS,
> 4c9c8d78 Jeff Garzik    2008-02-15  1116  			       pci_resource_start(pdev, 8));
> ^1da177e Linus Torvalds 2005-04-16  1117          
> ^1da177e Linus Torvalds 2005-04-16  1118          dp6m_ptr = ha->brd;
> ^1da177e Linus Torvalds 2005-04-16  1119  

Probably this is necessary, though it seems a hack-around.
---
 drivers/scsi/gdth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..148827f 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1107,8 +1107,8 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 	pci_read_config_word(pdev, PCI_COMMAND, &command);
         command |= 6;
 	pci_write_config_word(pdev, PCI_COMMAND, command);
-	if (pci_resource_start(pdev, 8) == 1UL)
-	    pci_resource_start(pdev, 8) = 0UL;
+	if (pdev->resource[8].start == 1UL)
+	    pdev->resource[8].start = 0UL;
         i = 0xFEFF0001UL;
 	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, i);
         gdth_delay(1);



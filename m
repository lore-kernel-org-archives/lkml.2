Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab2CBNAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:00:03 -0500
Received: from odpn1.odpn.net ([212.40.96.53]:35145 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab2CBNAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:00:01 -0500
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2012 08:00:01 EST
From: "Gabor Z. Papp" <gzp@papp.hu>
To: linux-kernel@vger.kernel.org
Subject: 3.0.23 & floppy
User-Agent: Gnus/5.110011 (No Gnus v0.11)
Date: Fri, 02 Mar 2012 13:37:37 +0100
Message-ID: <x6k433fab2@gzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
while dding from /dev/fd0 to /dev/null I'm getting this on vanilla 3.0.23:

WARNING: at drivers/block/floppy.c:1041 setup_rw_floppy+0x2b6/0x350 [floppy]()
Hardware name: To Be Filled By O.E.M.
floppy_disable_hlt() scheduled for removal in 2012
Modules linked in: floppy pcspkr nfsd exportfs nfs lockd sunrpc w83627hf hwmon_vid hwmon i2c_i801 i2c_dev i2c_core skge usb_storage uhci_hcd ehci_hcd usbcore
Pid: 0, comm: swapper Not tainted 3.0.23-gzp7 #1
Call Trace:
 [<c102cac8>] ? warn_slowpath_common+0x78/0xb0
 [<f8244266>] ? setup_rw_floppy+0x2b6/0x350 [floppy]
 [<f8244266>] ? setup_rw_floppy+0x2b6/0x350 [floppy]
 [<f82400b0>] ? vdma_dma_setup+0x40/0x40 [floppy]
 [<c102cb93>] ? warn_slowpath_fmt+0x33/0x40
 [<f8244266>] ? setup_rw_floppy+0x2b6/0x350 [floppy]
 [<f8243fb0>] ? fd_watchdog+0xa0/0xa0 [floppy]
 [<c1037145>] ? run_timer_softirq+0xd5/0x1d0
 [<c1031d10>] ? __do_softirq+0x70/0xf0
 [<c1031ca0>] ? irq_enter+0x60/0x60
 <IRQ>  [<c1031afe>] ? irq_exit+0x6e/0xa0
 [<c1015f61>] ? smp_apic_timer_interrupt+0x51/0x90
 [<c121ef2a>] ? apic_timer_interrupt+0x2a/0x30
 [<c1008ddb>] ? default_idle+0x2b/0x40
 [<c1001bdd>] ? cpu_idle+0x3d/0x70
 [<c12ea73f>] ? start_kernel+0x2a8/0x2ad
 [<c12ea2d5>] ? kernel_init+0x112/0x112
---[ end trace dd91b3ff941c1182 ]---

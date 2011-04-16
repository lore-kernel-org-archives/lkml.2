Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1DPQvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:51:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:50051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab1DPQu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:50:58 -0400
Message-Id: <20110416165050.079735249@aepfle.de>
User-Agent: quilt/0.47-15.10
Date: Sat, 16 Apr 2011 18:50:42 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/5] hv: make vmbus_loglevel writeable                                                                                                                                                                
References: <20110416165038.986214764@aepfle.de>
Content-Disposition: inline; filename=bug679942-vmbus_loglevel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make /sys/module/hv_vmbus/parameters/vmbus_loglevel writeable by root.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
compile tested.

 drivers/staging/hv/vmbus_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/drivers/staging/hv/vmbus_drv.c
===================================================================
--- linux-next.orig/drivers/staging/hv/vmbus_drv.c
+++ linux-next/drivers/staging/hv/vmbus_drv.c
@@ -827,7 +827,7 @@ static void __exit hv_pci_exit(void)
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
-module_param(vmbus_loglevel, int, S_IRUGO);
+module_param(vmbus_loglevel, int, S_IRUGO|S_IWUSR);
 
 module_init(hv_pci_init);
 module_exit(hv_pci_exit);


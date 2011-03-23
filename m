Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab1CWNJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:09:03 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:41868 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab1CWNJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:09:01 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRVC9ACJPg==
X-RZG-CLASS-ID: mo00
Date: Wed, 23 Mar 2011 14:08:54 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hv: make vmbus_loglevel writeable
Message-ID: <20110323130854.GA6579@aepfle.de>
References: <20110322210207.GA17724@aepfle.de>
 <20110322210627.GB17724@aepfle.de>
 <20110322210850.GC17724@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110322210850.GC17724@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make /sys/module/hv_vmbus/parameters/vmbus_loglevel writeable by root.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/staging/hv/vmbus_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/staging/hv/vmbus_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/vmbus_drv.c
+++ linux-2.6/drivers/staging/hv/vmbus_drv.c
@@ -1022,7 +1022,7 @@ MODULE_DEVICE_TABLE(pci, microsoft_hv_pc
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 module_param(vmbus_irq, int, S_IRUGO);
-module_param(vmbus_loglevel, int, S_IRUGO);
+module_param(vmbus_loglevel, int, S_IRUGO|S_IWUSR);
 
 module_init(vmbus_init);
 module_exit(vmbus_exit);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2ILXqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:46:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180Ab2ILXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:45:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Jakob Bornecrantz <jakob@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 43/46] drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot
Date: Wed, 12 Sep 2012 16:39:33 -0700
Message-Id: <20120912233822.177754743@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit c4903429a92be60e6fe59868924a65eca4cd1a38 upstream.

This will cause udev to load vmwgfx instead of waiting for X
to do it.

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -147,6 +147,7 @@ static struct pci_device_id vmw_pci_id_l
 	{0x15ad, 0x0405, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VMWGFX_CHIP_SVGAII},
 	{0, 0, 0}
 };
+MODULE_DEVICE_TABLE(pci, vmw_pci_id_list);
 
 static int enable_fbdev;
 



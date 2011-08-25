Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1HYNET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:04:19 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59758 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:04:18 -0400
Message-ID: <4E564845.3020209@gmail.com>
Date: Thu, 25 Aug 2011 21:04:05 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio.h: correct comment for struct virtio_driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.0.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/virtio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7108857..e0a1973 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -126,10 +126,10 @@ void unregister_virtio_device(struct virtio_device *dev);
  * virtio_driver - operations for a virtio I/O driver
  * @driver: underlying device driver (populate name and owner).
  * @id_table: the ids serviced by this driver.
- * @feature_table: an array of feature numbers supported by this device.
+ * @feature_table: an array of feature numbers supported by this driver.
  * @feature_table_size: number of entries in the feature table array.
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
- * @remove: the function when a device is removed.
+ * @remove: the function to call when a device is removed.
  * @config_changed: optional function to call when the device configuration
  *    changes; may be called in interrupt context.
  */
-- 
1.7.1


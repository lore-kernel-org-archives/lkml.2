Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2FIWDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 18:03:12 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34007 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843Ab2FIWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 18:03:11 -0400
Message-ID: <4FD3C813.50607@xenotime.net>
Date: Sat, 09 Jun 2012 15:02:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] driver core: fix some kernel-doc warnings in dma*.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in drivers/base/dma*.c:

Warning(drivers/base/dma-buf.c:498): No description found for parameter 'vaddr'
Warning(drivers/base/dma-coherent.c:199): No description found for parameter 'ret'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/base/dma-buf.c      |    1 +
 drivers/base/dma-coherent.c |    1 +
 2 files changed, 2 insertions(+)

--- lnx-35-rc2.orig/drivers/base/dma-buf.c
+++ lnx-35-rc2/drivers/base/dma-buf.c
@@ -493,6 +493,7 @@ EXPORT_SYMBOL_GPL(dma_buf_vmap);
 /**
  * dma_buf_vunmap - Unmap a vmap obtained by dma_buf_vmap.
  * @dmabuf:	[in]	buffer to vunmap
+ * @vaddr:	[in]	vmap to vunmap
  */
 void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 {
--- lnx-35-rc2.orig/drivers/base/dma-coherent.c
+++ lnx-35-rc2/drivers/base/dma-coherent.c
@@ -186,6 +186,7 @@ EXPORT_SYMBOL(dma_release_from_coherent)
  * @vma:	vm_area for the userspace memory
  * @vaddr:	cpu address returned by dma_alloc_from_coherent
  * @size:	size of the memory buffer allocated by dma_alloc_from_coherent
+ * @ret:	result from remap_pfn_range()
  *
  * This checks whether the memory was allocated from the per-device
  * coherent memory pool and if so, maps that memory to the provided vma.

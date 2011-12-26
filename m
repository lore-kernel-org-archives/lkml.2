Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1LZJZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 04:25:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52782 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1LZJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 04:24:35 -0500
From: Sumit Semwal <sumit.semwal@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, <linaro-mm-sig@lists.linaro.org>,
        <dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
        <arnd@arndb.de>, <airlied@redhat.com>
CC: <linux@arm.linux.org.uk>, <jesse.barker@linaro.org>,
        <m.szyprowski@samsung.com>, <rob@ti.com>, <daniel@ffwll.ch>,
        <t.stanislaws@samsung.com>, <patches@linaro.org>,
        Sumit Semwal <sumit.semwal@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 3/3] dma-buf: mark EXPERIMENTAL for 1st release.
Date: Mon, 26 Dec 2011 14:53:17 +0530
Message-ID: <1324891397-10877-4-git-send-email-sumit.semwal@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324891397-10877-1-git-send-email-sumit.semwal@ti.com>
References: <1324891397-10877-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark dma-buf buffer sharing API as EXPERIMENTAL for first release.
We will remove this in later versions, once it gets smoothed out
and has more users.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
---
 drivers/base/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 8a0e87f..e95c67e 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -178,6 +178,7 @@ config DMA_SHARED_BUFFER
 	bool "Buffer framework to be shared between drivers"
 	default n
 	select ANON_INODES
+	depends on EXPERIMENTAL
 	help
 	  This option enables the framework for buffer-sharing between
 	  multiple drivers. A buffer is associated with a file using driver
-- 
1.7.5.4


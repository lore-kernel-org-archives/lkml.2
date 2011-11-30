Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1K3OpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:45:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1K3OpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:45:09 -0500
Date: Wed, 30 Nov 2011 16:46:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH for-3.2] tools/virtio: add module.h stub
Message-ID: <20111130144647.GA24789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make it build with linux 3.2

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/linux/module.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 tools/virtio/linux/module.h

diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
new file mode 100644
index 0000000..96868eb
--- /dev/null
+++ b/tools/virtio/linux/module.h
@@ -0,0 +1,3 @@
+#ifndef LINUX_MODULE_H
+#define LINUX_MODULE_H
+#endif
-- 
1.7.5.53.gc233e

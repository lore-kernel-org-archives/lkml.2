Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2JKGoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:44:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49846 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2JKGn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:43:59 -0400
From: Bryan Venteicher <bryan.venteicher@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cong Meng <mc@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Bryan Venteicher <bryanv@daemoninthecloset.org>
Subject: [PATCH] [SCSI] virtio-scsi: Add real 2-clause BSD license to header
Date: Thu, 11 Oct 2012 01:41:31 -0500
Message-Id: <1349937691-60084-1-git-send-email-bryanv@daemoninthecloset.org>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is analogous to commit a1b383870a made by Rusty Russell to all
the VirtIO headers at the time. This eases the use of the header as
is by other OSes.

Signed-off-by: Bryan Venteicher <bryanv@daemoninthecloset.org>
---
 include/linux/virtio_scsi.h | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index dc8d305..a91fb52 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -1,7 +1,31 @@
+/*
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
 #ifndef _LINUX_VIRTIO_SCSI_H
 #define _LINUX_VIRTIO_SCSI_H
-/* This header is BSD licensed so anyone can use the definitions to implement
- * compatible drivers/servers. */
 
 #define VIRTIO_SCSI_CDB_SIZE   32
 #define VIRTIO_SCSI_SENSE_SIZE 96
-- 
1.7.11.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab1LOLLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:11:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1LOLLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:11:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Add missing linux/export.h to arch PCI dma
 implementations
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 15 Dec 2011 11:11:37 +0000
Message-ID: <20111215111137.395.21724.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing linux/export.h to arch PCI dma implementations so that
EXPORT_SYMBOL() is correctly handled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/pci-dma-nommu.c |    1 +
 arch/frv/mb93090-mb00/pci-dma.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/frv/mb93090-mb00/pci-dma-nommu.c b/arch/frv/mb93090-mb00/pci-dma-nommu.c
index e47857f..42ed284 100644
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c
+++ b/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/export.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 41098a3..be0916d 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/export.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 #include <linux/list.h>


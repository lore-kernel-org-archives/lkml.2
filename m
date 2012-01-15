Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2AOLhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 06:37:04 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:46660 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2AOLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 06:37:03 -0500
Message-ID: <4F12BA1F.5020304@freemail.hu>
Date: Sun, 15 Jan 2012 12:35:59 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Resolve the abbreviation PCI BAR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.94.24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Resolve the PCI BAR abbreviation as Base Address Registers
in documentation in order not to be confused with the placeholder
names foo and bar.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 lib/pci_iomap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index 4b0fdc2..1c92272 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -12,7 +12,7 @@
 /**
  * pci_iomap - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
- * @bar: BAR number
+ * @bar: BAR (Base Address Registers) index, zero based
  * @maxlen: length of the memory to map
  *
  * Using this function you will get a __iomem address to your device BAR.
-- 
1.7.2.5


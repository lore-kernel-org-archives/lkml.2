Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1JJPX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:23:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65266 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1JJPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:23:56 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/4] staging: et131x: Update TODO list
Date: Mon, 10 Oct 2011 16:22:32 +0100
Message-Id: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added some more tasks to the TODO list, as highlighted by Francois
Romieu <romieu@fr.zoreil.com>.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index d383e80..c67f83e 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -2,13 +2,18 @@ This is a driver for the ET1310 network device.
 
 Based on the driver found at https://sourceforge.net/projects/et131x/
 
-Cleaned up immensely by Olaf Hartman and Christoph
-Hellwig <hch@infradead.org>
+Cleaned up immensely by Olaf Hartman and Christoph Hellwig <hch@infradead.org>
 
 Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
+	- Put the driver into a single file, with a .h for the registers layout.
+	- rx_ring.fbr{0, 1} can probably share a common structure
+	- Use of kmem_cache seems a bit unusual
+	- Use dma_alloc_... in place of pci_alloc_...
+	- It's too late stopping the tx queue when there is no room for the current packet. The condition should be detected for the next packet.
+	- PCI_VDEVICE ?
 
 Please send patches to:
 	Greg Kroah-Hartman <gregkh@suse.de>
-- 
1.7.6.4


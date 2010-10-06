Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab0JFBCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:02:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab0JFBBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B7Jw0Wn4QpRjOxvYKDHsoh6MD+Km9ifS4Rh1tRivNt5UHJIkWskhkyrmCWAna8g4mh
         rANK6xHS0cZHAl/rLHWurH6PX5FQN42t/zLebnYhEqm2G5a45PXZ+pPtoh3+HFtHtqbc
         yAITkO+Q9nfAJ/viBMkPHG6gaallEkoNsnlCc=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 24/28] Staging: comedi: drivers: adv_pci_dio.c: Edit file so that checkpatch.pl has 3 warnings and 1 errors
Date: Tue,  5 Oct 2010 21:00:39 -0400
Message-Id: <1286326843-6170-24-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. Except a few warnings and
error.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d018bb4..aafefd8 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -12,20 +12,20 @@ Description: Advantech PCI-1730, PCI-1733, PCI-1734, PCI-1735U,
 	PCI-1754, PCI-1756, PCI-1762
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCI-1730 (adv_pci_dio), PCI-1733,
-  PCI-1734, PCI-1735U, PCI-1736UP, PCI-1750,
-  PCI-1751, PCI-1752, PCI-1753,
-  PCI-1753+PCI-1753E, PCI-1754, PCI-1756,
-  PCI-1760, PCI-1762
+	PCI-1734, PCI-1735U, PCI-1736UP, PCI-1750,
+	PCI-1751, PCI-1752, PCI-1753,
+	PCI-1753+PCI-1753E, PCI-1754, PCI-1756,
+	PCI-1760, PCI-1762
 Status: untested
 Updated: Tue, 04 May 2010 13:00:00 +0000
 
 This driver supports now only insn interface for DI/DO/DIO.
 
 Configuration options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-	If bus/slot is not specified, the first available PCI
-	device will be used.
+	[0] - PCI bus of device (optional)
+	[1] - PCI slot of device (optional)
+		If bus/slot is not specified, the first available PCI
+		device will be used.
 
 */
 
-- 
1.7.3.1.50.g1e633


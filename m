Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796Ab2EOCtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:49:08 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33990 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170Ab2EOCsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:48:54 -0400
X-Greylist: delayed 697 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 22:48:54 EDT
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q4F2b2cC006256, This message is released by code: ctaloc0852
From: <edwin_rong@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <wei_wang@realsil.com.cn>, <edwin_rong@realsil.com.cn>
Subject: [PATCH] staging: update TODO files for rts5139 & rts_pstor
Date: Tue, 15 May 2012 10:36:32 +0800
Message-ID: <1337049392-8544-1-git-send-email-edwin_rong@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: edwin_rong <edwin_rong@realsil.com.cn>

Recently we find that many warm-hearted people are helping improving the
coding style and something else of driver rts5139 & rts_pstor, which will
be replaced with one new refactored uniform Realtek cardreader driver in
the future, update the TODO file to inform people not to do modifications
to both of the drivers any more to avoid wasting their time and energy.

Thanks
Edwin

Signed-off-by: edwin_rong <edwin_rong@realsil.com.cn>
---
 drivers/staging/rts5139/TODO   |    2 ++
 drivers/staging/rts_pstor/TODO |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/staging/rts5139/TODO b/drivers/staging/rts5139/TODO
index dd5fabb..df0658e 100644
--- a/drivers/staging/rts5139/TODO
+++ b/drivers/staging/rts5139/TODO
@@ -7,3 +7,5 @@ TODO:
   drivers/mmc instead, as a host driver e.g. drivers/mmc/host/realtek-usb.c;
   see drivers/mmc/host/ushc.c as an example.
 - This driver presents cards as SCSI devices, but they should be MMC devices.
+- Stop updating this driver, one new refactored Realtek cardreader driver will
+  replace this one in the future.
diff --git a/drivers/staging/rts_pstor/TODO b/drivers/staging/rts_pstor/TODO
index becb95e..c2b8720 100644
--- a/drivers/staging/rts_pstor/TODO
+++ b/drivers/staging/rts_pstor/TODO
@@ -7,3 +7,5 @@ TODO:
   drivers/mmc instead, as a host driver e.g. drivers/mmc/host/realtek-pci.c;
   see drivers/mmc/host/via-sdmmc.c as an example.
 - This driver presents cards as SCSI devices, but they should be MMC devices.
+- Stop updating this driver, one new refactored Realtek cardreader driver will
+  replace this one in the future.
-- 
1.7.9.5


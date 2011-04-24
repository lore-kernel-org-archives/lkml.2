Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab1DXVPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:15:52 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:60320 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757610Ab1DXVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:15:49 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB492DD.3000600@verizon.net>
Date: Sun, 24 Apr 2011 17:15:09 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@suse.de>, <bcollins@bluecherry.net>
Subject: [PATCH] staging: solo6x10: add select SND_PCM to fix build error
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build error when SND_PCM is not set
by adding a select statment.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 drivers/staging/solo6x10/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/solo6x10/Kconfig b/drivers/staging/solo6x10/Kconfig
index 2cf77c9..03dcac4 100644
--- a/drivers/staging/solo6x10/Kconfig
+++ b/drivers/staging/solo6x10/Kconfig
@@ -2,6 +2,7 @@ config SOLO6X10
 	tristate "Softlogic 6x10 MPEG codec cards"
 	depends on PCI && VIDEO_DEV && SND && I2C
 	select VIDEOBUF_DMA_SG
+	select SND_PCM
 	---help---
 	  This driver supports the Softlogic based MPEG-4 and h.264 codec
 	  codec cards.
-- 
1.7.5.rc1


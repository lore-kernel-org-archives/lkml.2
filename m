Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325Ab2I1Vc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:32:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51449 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032605Ab2I1U1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 115/218] dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
Date: Fri, 28 Sep 2012 13:15:32 -0700
Message-Id: <20120928201514.708826393@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit c618a9be0e8c0f36baee2560860a0118a428fb26 upstream.

s/dma_memcpy/slave_sg/ and it is sg length that we are
talking about.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -664,7 +664,7 @@ atc_prep_slave_sg(struct dma_chan *chan,
 			flags);
 
 	if (unlikely(!atslave || !sg_len)) {
-		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
+		dev_dbg(chan2dev(chan), "prep_slave_sg: sg length is zero!\n");
 		return NULL;
 	}
 



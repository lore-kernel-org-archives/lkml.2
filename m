Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0C0BuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:50:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64967 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0C0BuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iEQXtj+X+G1w03OJ2bB38r7CxiqYJ8ls0VfHI1isIbfjo0+MRv/fyKjOwU9Cc+DssD
         WNp5dmajLCt+mc5kFWQj7YRSWlSTJ410ONj+8aYuYC/AHNdJLG5LHnV/B2DsUXcDQPME
         6HNFIB7hIyLp96m25nc+h9gVVUni+rWchm6yY=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 9/9] Staging: comedi: cb_pcidas64: fixed a coding style missed in the previosu patch
Date: Sat, 27 Mar 2010 09:48:43 +0800
Message-Id: <1269654523-2682-10-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1d43d0d..f17cb09 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1921,7 +1921,7 @@ static int detach(struct comedi_device *dev)
 						    ao_dma_desc_bus_addr);
 			if (priv(dev)->main_phys_iobase)
 				comedi_pci_disable(priv(dev)->hw_dev);
-	
+
 			pci_dev_put(priv(dev)->hw_dev);
 		}
 	}
-- 
1.7.0.3


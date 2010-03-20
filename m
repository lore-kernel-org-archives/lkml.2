Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0CTSQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:16:33 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35114 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0CTSQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ElSWmWUo5DerEqcWN2wkuxnHdiQmaaIopQOClNlzTqJEcg3h/1HX+dAs+SR2M7v1K4
         SkKTQQo5IuZZeVMHoutkNew+ecEUCY+beBIN9CI2NxhogCMIqQK4RvOdifrvNKy264v6
         r0pAfZxL1OIPxZ6mY2zuNTcsDIk10kmDW1g0M=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 9/9] Staging: comedi: cb_pcidas64: fixed a coding style missed in the previosu patch
Date: Sun, 21 Mar 2010 02:14:10 +0800
Message-Id: <1269108850-1414-10-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.2
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
1.7.0.2


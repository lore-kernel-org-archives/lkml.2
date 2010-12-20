Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0LTCBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:01:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63669 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0LTCBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=duED9QETnPa5hMsHLAkwd4e7/xHMe2MIKonw0fxyrYStHcjTlP5zKL66HFUXsw1IAM
         HSVLiUBp3+urI5t3BV/Vc5jAdArs+TPe6uh0K0rohzFh4IRsc9UBU2rSUgHgfAjtQPlO
         /oqbP/BU6L6NC9YfYUZFbhtA1YWVYx+M6htn4=
Subject: [PATCH RESEND] mfd: Add __devexit annotation for vx855_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Mon, 20 Dec 2010 10:02:06 +0800
Message-Id: <1292810526.17628.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Harald Welte <HaraldWelte@viatech.com>
---
hi Samuel,
Looks like this patch is missing.
It was posted at http://kerneltrap.org/mailarchive/linux-kernel/2010/10/25/4636759
with Harald's ack.

Axel

 drivers/mfd/vx855.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index ebb0597..348052a 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -112,7 +112,7 @@ out:
 	return ret;
 }
 
-static void vx855_remove(struct pci_dev *pdev)
+static void __devexit vx855_remove(struct pci_dev *pdev)
 {
 	mfd_remove_devices(&pdev->dev);
 	pci_disable_device(pdev);
-- 
1.7.2




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1CQHAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:00:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46647 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1CQHAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rRACbP5QEYws295OQ+7LOWVzyc/pRVPMEfLmVd7TZW50eM1J3HQrrVk2HqXfz2VArg
         Pg5+MjSts/OKStNewtSwhxbm1N8xwh6kTJ0HaxGS7a9lYd7bG9MolswSrpfPrWBSgGja
         B23LpeS3YNvlGHPzmYBWb4rIvzZ70YPPbUWU8=
Subject: [PATCH] drivers/misc: Add MODULE_DEVICE_TABLE to pch_phub
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 15:00:33 +0800
Message-ID: <1300345233.3369.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/pch_phub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 5dd0b92..b41e108 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -731,6 +731,7 @@ static struct pci_device_id pch_phub_pcidev_id[] = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, pch_phub_pcidev_id);
 
 static struct pci_driver pch_phub_driver = {
 	.name = "pch_phub",
-- 
1.7.1




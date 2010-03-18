Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0CRWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:08:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:51271 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0CRWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JU/yaWDG4BktEnDm3b42ioyjRNsI7NhmCzCMbGoH/H6IgxDVCkKd+Ff63hLZV6upEo
         hRygYdaFpIHll1q1TWyLpvnuRerj/0LXx58bni/VWdgBRUkP4UsUtrif5VZ50pIH+s4R
         ozjWLYt3ZjBNlKxLc7jIYsREC4cXXi3iIBD3s=
Message-ID: <4BA2A455.1070303@googlemail.com>
Date: Thu, 18 Mar 2010 23:08:21 +0100
From: =?windows-1252?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: =?windows-1252?Q?=5BPATCH_0/5=5D_drivers/ata/ahci=2Ec_warn?=
 =?windows-1252?Q?ing=3A_comparison_between_=91enum_=3Canonymous=3E?=
 =?windows-1252?Q?=92_and_=91enum_=3Canonymous=3E=92?=
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 108f2c6..f17b114 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -998,7 +998,7 @@ static int ahci_init_one(struct pci_dev *pdev, const 
struct pci_device_id *ent)

  	VPRINTK("ENTER\n");

-	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
+	WARN_ON(ATA_MAX_QUEUE >= AHCI_MAX_CMDS);

  	if (!printed_version++)
  		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");

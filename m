Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0CRWI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:08:29 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34555 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0CRWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nJQibuZ6F6acA5LFIPlH3ThtOkeG982Yil6cG/Z0PGI4LF4XaWWXee19org6tlBx+S
         WgKWpYj6+TUN8hyuKrCGW/X7GXRAcqnN0fSNOfu2ihE+zanwxOv644RvikWgJTkZhn9r
         UA1lE5trqYJIyryuskxKX1Coo6rfjrzfi9t5M=
Message-ID: <4BA2A458.8040808@googlemail.com>
Date: Thu, 18 Mar 2010 23:08:24 +0100
From: =?windows-1252?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/ata/ahci_platform.c Section mismatch
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>


diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 42cdd73..16fa45b 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -164,7 +164,7 @@ static int __devexit ahci_remove(struct 
platform_device *pdev)
  	return 0;
  }

-static struct platform_driver ahci_driver = {
+static struct platform_driver __refdata ahci_driver = {
  	.probe = ahci_probe,
  	.remove = __devexit_p(ahci_remove),
  	.driver = {

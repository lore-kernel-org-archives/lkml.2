Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2KAFbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:31:05 -0400
Received: from sjdciscan01.udc.trendmicro.com ([66.180.82.17]:57912 "EHLO
	sjdciscan01.udc.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab2KAFbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:31:04 -0400
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2012 01:31:04 EDT
From: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>
To: Wei Yongjun <weiyj.lk@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mtip32xx: remove unused variables from mtip32xx.c
Thread-Topic: [PATCH] mtip32xx: remove unused variables from mtip32xx.c
Thread-Index: AQHNt+77+h5QFTp2g02BLlTbygCE15fUbxfw
Date: Thu, 1 Nov 2012 05:14:33 +0000
Message-ID: <A360F954C61C69449463B060666371121CDEC867@CDCEXMBX02.tw.trendnet.org>
References: <CAPgLHd928Pn4GvgcRAHic6pGU2T1gLrWRpGsqjxsGk0=nDg9rw@mail.gmail.com>
In-Reply-To: <CAPgLHd928Pn4GvgcRAHic6pGU2T1gLrWRpGsqjxsGk0=nDg9rw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.44.136]
Content-Type: text/plain;
	charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA15VI1U023121

Hi all

Sorry, please ignore this mail, this mail just be resend by my mistake.

Regards,
Yongjun Wei

-----Original Message-----
From: Wei Yongjun [mailto:weiyj.lk@gmail.com] 
Sent: 2012Äê11ÔÂ1ÈÕ 13:09
To: axboe@kernel.dk
Cc: Yongjun Wei (RD-CN); linux-kernel@vger.kernel.org
Subject: [PATCH] mtip32xx: remove unused variables from mtip32xx.c

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variables fis, reply are initialized but never used otherwise, so remove the unused variables.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/mtip32xx/mtip32xx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index adc6f36..d1e0273 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -555,7 +555,6 @@ static void print_tags(struct driver_data *dd,  static void mtip_timeout_function(unsigned long int data)  {
 	struct mtip_port *port = (struct mtip_port *) data;
-	struct host_to_dev_fis *fis;
 	struct mtip_cmd *command;
 	int tag, cmdto_cnt = 0;
 	unsigned int bit, group;
@@ -587,7 +586,6 @@ static void mtip_timeout_function(unsigned long int data)
 			bit = tag & 0x1F;
 
 			command = &port->commands[tag];
-			fis = (struct host_to_dev_fis *) command->command;
 
 			set_bit(tag, tagaccum);
 			cmdto_cnt++;
@@ -1142,10 +1140,8 @@ static void mtip_issue_non_ncq_command(struct mtip_port *port, int tag)  static bool mtip_pause_ncq(struct mtip_port *port,
 				struct host_to_dev_fis *fis)
 {
-	struct host_to_dev_fis *reply;
 	unsigned long task_file_data;
 
-	reply = port->rxfis + RX_FIS_D2H_REG;
 	task_file_data = readl(port->mmio+PORT_TFDATA);
 
 	if (fis->command == ATA_CMD_SEC_ERASE_UNIT)



<table class="TM_EMAIL_NOTICE"><tr><td><pre>
TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidential 
and may be subject to copyright or other intellectual property protection. 
If you are not the intended recipient, you are not authorized to use or 
disclose this information, and we request that you notify us by reply mail or
telephone and delete the original message from your mail system.
</pre></td></tr></table>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

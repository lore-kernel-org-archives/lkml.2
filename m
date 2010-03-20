Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0CTTKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:10:07 -0400
Received: from smtp826.mail.ird.yahoo.com ([217.146.189.240]:35280 "HELO
	smtp826.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751154Ab0CTTKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:10:05 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2010 15:10:05 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Nqe4ZgiqH1fO824AeywGkL7Hdnna//XQNTxhKXM1okI+iY7Uox4a6bvxImmt9S2CkU4Qp/q5vU8fu89kFDQhMHC9Xy+ODiT2VkNR/2Hapd9JcPvldRB31V1koXMyxpE470RLpSGPMhQ4mEKBubvCdVp12X8A1jRhz+L/zQnREac=  ;
X-Yahoo-SMTP: k5SysT6swBB9P.tkS3lzIbg6PUzaCV7jCcJpLj9TyF3meik1xcwV.g--
X-YMail-OSG: OM6s6jEVM1k26qJ1APmy1qSbXbQ57U2Sr_4uUOEUw33DLS8RjkiF24vCyYKIYr6V0gWspqSJnHyiZOMWrnJ0d_M82MnLLp7uIt83m0eNEGZp1Ojp32_4CR6E1BVqF4U8L86NhjzsbLsUXQwu5j1WM3FPMl7.0._UKVTPa40.83UODVBFrNXdi0F4gkOj.hgSfH1aP6M8og8F5qcH.3e2_8aBG7TOCq4rAk9LmOcfAhnaWFBBanO0MM0vQaKc.TxSDA8svlpRyxZZu00d7Aay
X-Yahoo-Newman-Property: ymail-3
From: Laura Parkes <laura_parkes@btinternet.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>, Andre Haupt <andre@bitwigglers.org>,
       Andi Kleen <ak@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>,
       "Kevin A. Granade" <kevin.granade@gmail.com>
Subject: [PATCH] Staging: asus_oled: fix spaces coding style in asus_oled.c
Date: Sat, 20 Mar 2010 19:03:31 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003201903.32025.laura_parkes@btinternet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ada5a2f3c991cbbf8f6fbd97d72718c9bb806580 Mon Sep 17 00:00:00 2001
From: Laura Parkes <laura_parkes@btinternet.com>
Date: Sat, 20 Mar 2010 17:16:19 +0000
Subject: [PATCH] Staging: asus_oled: fix spaces coding style in asus_oled.c
 This is a patch to the asus_oled.c file that fixes a spaces
 warning found by checkpatch.pl tool.
 Signed-off-by: Laura Parkes <laura_parkes@btinternet.com>

---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..9e7e677 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -771,7 +771,7 @@ static struct usb_driver oled_driver = {
 };
 
 static CLASS_ATTR_STRING(version, S_IRUGO,
-		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
+	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
-- 
1.6.3.3


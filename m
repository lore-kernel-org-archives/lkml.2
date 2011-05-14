Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab1EODZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 23:25:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47842 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1EODZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 23:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RyqxqpdsvFDByOpZUyl0dRmGIwlzFqC2LQRz+fy60gp7mdlX/XWRWeJJ1IQnE8Grrl
         pQZ9y6iVJ1/x9uMyg0XT1iEibIkR7RPoWU2Zs2ju4ROW2SWHhMn1CV83yy87QuA07vSf
         A8b3azg6ysduyytNR8l5qxXeQyEy5jhVO10A0=
Subject: [PATCH 2/3] preferred form for passing a size to memory allocation
 routines
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 23:25:04 +0530
Message-ID: <1305395704.7400.17.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preferred form for passing a size of a struct is the following:
         p = kmalloc(sizeof(*p), ...);
Please refer Documentation/Codingstyle chapter 14
Signed-off-by: anish kumar<anish198519851985@gmail.com>
---
drivers/staging/sm7xx/smtcfb.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c
b/drivers/staging/sm7xx/smtcfb.c
index c1b8228..d1dd387 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -684,7 +684,7 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct
pci_dev *dev,
{
struct smtcfb_info *sfb;

- sfb = kzalloc(sizeof(struct smtcfb_info), GFP_KERNEL);
+ sfb = kzalloc(sizeof(*sfb), GFP_KERNEL);

if (!sfb)
return NULL;
-- 
1.7.0.4




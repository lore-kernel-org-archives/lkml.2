Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0IDXGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 19:06:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57100 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0IDXGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=OalsD2t2QoIs+wZF5pHFshoyV0thyqKN2Mq8nIU+wr2PWTGGJKeH/C+VdoeLbLmy+E
         1RBtwBRYnILMgKGhc5uGc9LRrNIWU76WsU8EmS1GC5eYrf34tIRTsMblBjTOYsrXcQB2
         ntS6cx2sAm7WrXe7OP7xRVx7fFGXvYqi8EWxc=
Subject: [PATCH 1/4] staging: xgifb: Fix compile warning
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Huang Weiyi <weiyi.huang@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 19:06:47 -0400
Message-ID: <1283641607.9641.4.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, In today linux-next I got a some compile warnings with the staging/xgifb driver. This is the first of a 4 patchset that fix all the issues.

The patches are:

[PATCH 1/4] staging: xgifb: Fix compile warning
[PATCH 2/4] staging: xgifb: Add compilation conditionals
[PATCH 3/4] staging: xgifb: Removes unused variable
[PATCH 4/4] staging: xgifb: Init uninitialized variables and fix some style issues

Thanks a lot.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 7cd3e95..3c80191 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3418,7 +3418,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		XGIfb_registered = 1;
 
 		printk(KERN_INFO "XGIfb: Installed XGIFB_GET_INFO ioctl (%lx)\n",
-		       XGIFB_GET_INFO);
+		       (unsigned long)XGIFB_GET_INFO);
 
 /*		printk(KERN_INFO "XGIfb: 2D acceleration is %s, scrolling mode %s\n",
 		     XGIfb_accel ? "enabled" : "disabled",
-- 
1.7.0.4


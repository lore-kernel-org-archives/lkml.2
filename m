Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1DHDTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:19:01 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25464 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1DHDS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:18:58 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=wI57O_xxTQIA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=n3DLBDIp2lSvWb96zoUu4Q==:17 a=47LbCVvxAAAA:8 a=Eu7Le4O4fPpckxKH8fQA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Wood <simon@mungewell.org>
Subject: [PatchV3 1/3] usb: plusb: Whitespace
Date: Thu,  7 Apr 2011 00:40:13 -0700
Message-Id: <1302162015-22504-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301456667-1648-1-git-send-email-simon@mungewell.org>
References: <1301456667-1648-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: simon <simon@ubuntu.(none)>

This patch cleans up a couple of instances of incorrect whitespace

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/net/usb/plusb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 823c537..2fe1bb5 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -134,13 +134,13 @@ static struct usb_driver plusb_driver = {
 
 static int __init plusb_init(void)
 {
- 	return usb_register(&plusb_driver);
+	return usb_register(&plusb_driver);
 }
 module_init(plusb_init);
 
 static void __exit plusb_exit(void)
 {
- 	usb_deregister(&plusb_driver);
+	usb_deregister(&plusb_driver);
 }
 module_exit(plusb_exit);
 
-- 
1.7.4.1


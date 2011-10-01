Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1JAUJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:09:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1JAUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/26] ARM: pxa: export symbols from pxa3xx-ulpi
Date: Sat,  1 Oct 2011 22:03:41 +0200
Message-Id: <1317499438-14058-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:O3biiTH0UZrcjAAoLYrGPtxwLKHz7iiUGQy98oaENRB
 AafgwCFSPK38SJbqZ9lwoYTBZHc/4Qy7hgnmqYcOJpGij57I0E
 UWamNAdu37C4tMMKgOcGFB7X8ROZTi/ySDvyXgSP2ii2Frw2U5
 qFFu2iEMBVAQjRtQDrW23NfewAPB4NmJJCMhLD9oPGuTlkpT+v
 hNrvPnrUUnkwqQ074gkPJh5u0YjL48hDPVZ8SUiidNDmmRs5IS
 mHr23OUS5wrspqIqtKYOGP0+7A4SHmeDjw70LZkJAvvEH11Bp9
 khindXoyiwMQVACNmTpPN/6aU6jgKX0dNUXXxkd02kpBt5u003
 g1UiUrKu67yWbQhpHiOaUWuU5MqJZSQrIaLhYkdrx1li82+5au
 TX9Uo6q0JIYnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pxa3xx_u2d_start_hc/pxa3xx_u2d_stop_hc symbols are used by the
ohci-pxa27x driver, which can be a module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/pxa3xx-ulpi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa3xx-ulpi.c b/arch/arm/mach-pxa/pxa3xx-ulpi.c
index ce7168b..e28dfb8 100644
--- a/arch/arm/mach-pxa/pxa3xx-ulpi.c
+++ b/arch/arm/mach-pxa/pxa3xx-ulpi.c
@@ -265,6 +265,7 @@ int pxa3xx_u2d_start_hc(struct usb_bus *host)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(pxa3xx_u2d_start_hc);
 
 void pxa3xx_u2d_stop_hc(struct usb_bus *host)
 {
@@ -277,6 +278,7 @@ void pxa3xx_u2d_stop_hc(struct usb_bus *host)
 
 	clk_disable(u2d->clk);
 }
+EXPORT_SYMBOL_GPL(pxa3xx_u2d_stop_hc);
 
 static int pxa3xx_u2d_probe(struct platform_device *pdev)
 {
-- 
1.7.5.4


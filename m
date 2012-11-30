Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2K3Bhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:37:32 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:57044 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2K3Bhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:37:31 -0500
Date: Thu, 29 Nov 2012 19:37:30 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: sunxi: add missing include for mdelay()
Message-ID: <20121130013730.GA30592@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/29/2012 07:37:23 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/29/2012 07:37:23 PM,
	Serialize complete at 11/29/2012 07:37:23 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-29_05:2012-11-29,2012-11-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/arm/mach-sunxi/sunxi.o
./arch/arm/mach-sunxi/sunxi.c: In function 'sunxi_restart':
./arch/arm/mach-sunxi/sunxi.c:55:3: error: implicit declaration of function 'mdelay' [-Werror=implicit-function-declaration]

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
Fixes multiplatform build error seen with today's linux-next-20121129.

 arch/arm/mach-sunxi/sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index dc634ae..9be910f 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -10,6 +10,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/of_address.h>
-- 
1.8.0

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0JVSeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:34:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61863 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab0JVSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=soH7Pl27ABpKYPPG01l8Ds1XUF60OfTEmKqn/SXV847YhQp7p2RRKFj3U0J0zEZYeN
         icY9zC9h6ci10GKAJ/heQdFgaScupHqNw1BVbLdFH/od81lUVC/E+dFpDZH3pZO7d3M8
         f1dAh58WbYrwSf1DIkUlDUOdtDsm88OPmUmyg=
Message-ID: <4CC1D6D5.7010505@gmail.com>
Date: Fri, 22 Oct 2010 20:24:21 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/8] Removal of dead code from arch/m68knommu/kernel/setup.c
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ff74ba3dc19fa616a87803af756911d4997fcd76
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:46:01 2010 +0200

    Removal of dead code from
    arch/m68knommu/kernel/setup.c
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
index ba92b90..c684adf 100644
--- a/arch/m68knommu/kernel/setup.c
+++ b/arch/m68knommu/kernel/setup.c
@@ -54,9 +54,6 @@ void (*mach_reset)(void);
 void (*mach_halt)(void);
 void (*mach_power_off)(void);
 
-#ifdef CONFIG_M68000
-	#define CPU "MC68000"
-#endif
 #ifdef CONFIG_M68328
 	#define CPU "MC68328"
 #endif

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3AJHj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:39:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab3AJHj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:39:56 -0500
X-IronPort-AV: E=Sophos;i="4.84,443,1355068800"; 
   d="scan'208";a="6557889"
Message-ID: <50EE6FA5.3030703@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 15:37:09 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mchehab@redhat.com,
        joe@perches.com, davem@davemloft.net, b-cousson@ti.com, paul@pwsan.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: fix arch/arm/plat-omap/include/plat/omap_hwmod.h
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 15:39:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 15:39:19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to arch/arm/mach-omap2/omap_hwmod.h by commit
2a296c8 (ARM: OMAP: Make plat/omap_hwmod.h local to mach-omap2).

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 915564e..c4f15a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5507,8 +5507,7 @@ M:	Benoît Cousson <b-cousson@ti.com>
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-F:	arch/arm/mach-omap2/omap_hwmod.c
-F:	arch/arm/plat-omap/include/plat/omap_hwmod.h
+F:	arch/arm/mach-omap2/omap_hwmod.*
 
 OMAP HWMOD DATA FOR OMAP4-BASED DEVICES
 M:	Benoît Cousson <b-cousson@ti.com>
-- 
1.7.1

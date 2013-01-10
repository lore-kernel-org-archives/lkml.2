Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3AJHmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:42:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab3AJHmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:42:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,443,1355068800"; 
   d="scan'208";a="6557910"
Message-ID: <50EE702E.2030309@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 15:39:26 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mchehab@redhat.com,
        joe@perches.com, davem@davemloft.net
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: fix a status pattern
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 15:41:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 15:41:35,
	Serialize complete at 2013/01/10 15:41:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change MAINTAINED to Maintained.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c4f15a1..33d8f95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -648,7 +648,7 @@ F:	arch/arm/
 
 ARM SUB-ARCHITECTURES
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	MAINTAINED
+S:	Maintained
 F:	arch/arm/mach-*/
 F:	arch/arm/plat-*/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
-- 
1.7.1

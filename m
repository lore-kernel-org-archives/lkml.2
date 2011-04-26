Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1DZBpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:45:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42016 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1DZBpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:45:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: m32r lost maintainer (was Re: [PATCH 1/3] m32r: convert cpumask api)
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20110425183810.268B.A69D9226@jp.fujitsu.com>
References: <20110425183810.268B.A69D9226@jp.fujitsu.com>
Message-Id: <20110426104641.F352.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 10:44:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(remove m32r maintainer and ml)

> We plan to remove cpus_xx() old cpumask APIs later. Also, we plan
> to change mm_cpu_mask() implementation, allocate only nr_cpu_ids,
> thus *mm_cpu_mask() is dangerous operation.
> 
> Then, this patch convert them.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: linux-m32r@ml.linux-m32r.org

linux-m32r.org no longer exist and my last mail got returned. We should
change MAINTAINERS file. :-/


btw, now m32r can finished compile and link, but can't make correct
compressed image.

  CHK     include/generated/compile.h
make[2]: *** No rule to make target `arch/m32r/boot/compressed/vmlinux.bin.', needed by `arch/m32r/boot/compressed/piggy.o'.  Stop.
make[1]: *** [arch/m32r/boot/compressed/vmlinux] Error 2
make: *** [zImage] Error 2



>From 47a386e8c09f1838ccce56fea027a798dd0d7ab3 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 10:23:09 +0900
Subject: [PATCH] m32r: change MAINTAINERS file

linux-m32r.org domain doesn't exist and the e-mail address also
no longer exist.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 MAINTAINERS |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ba7918e..b515336 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3988,11 +3988,7 @@ T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
 M32R ARCHITECTURE
-M:	Hirokazu Takata <takata@linux-m32r.org>
-L:	linux-m32r@ml.linux-m32r.org
-L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
-W:	http://www.linux-m32r.org/
-S:	Maintained
+S:	Orphan
 F:	arch/m32r/
 
 M68K ARCHITECTURE
-- 
1.7.3.1




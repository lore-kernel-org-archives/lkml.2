Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0F3Ihc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:37:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0F3Iha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:37:30 -0400
Subject: [PATCH] init: Fix comment
From: Peter Zijlstra <peterz@infradead.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100630123249.ce966c83.isloginov@gmail.com>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	 <1277385096.1875.974.camel@laptop>
	 <20100624172334.ca7e9bef.isloginov@gmail.com>
	 <1277715689.1875.1104.camel@laptop> <1277725997.3561.6.camel@laptop>
	 <20100628141927.GA9306@elte.hu> <1277736661.3561.110.camel@laptop>
	 <20100630123249.ce966c83.isloginov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 10:37:11 +0200
Message-ID: <1277887031.1868.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 12:32 +0400, Ilya Loginov wrote:
> I have tested patch v3. All works fine for me.
> 
> I agree with Randy. The commentary should be fixed.
> 

By popular request..

---
Subject: init: Fix comment

Apparently "pid-1" confuses people...

Requested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9eed0f3..4ab5124 100644
--- a/init/main.c
+++ b/init/main.c
@@ -431,7 +431,7 @@ static noinline void __init_refok rest_init(void)
 
 	rcu_scheduler_starting();
 	/*
-	 * We need to spawn init first so that it obtains pid-1, however
+	 * We need to spawn init first so that it obtains pid 1, however
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */


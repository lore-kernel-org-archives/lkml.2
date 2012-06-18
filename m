Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab2FRKbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:31:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23159 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab2FRKbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:31:14 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v4 08/25] memcg: change defines to an enum
Date: Mon, 18 Jun 2012 14:28:01 +0400
Message-Id: <1340015298-14133-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340015298-14133-1-git-send-email-glommer@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a cleanup patch for clarity of expression.
In earlier submissions, people asked it to be in a separate
patch, so here it is.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b6cb075..cc1fdb4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -374,9 +374,12 @@ enum charge_type {
 };
 
 /* for encoding cft->private value on file */
-#define _MEM			(0)
-#define _MEMSWAP		(1)
-#define _OOM_TYPE		(2)
+enum res_type {
+	_MEM,
+	_MEMSWAP,
+	_OOM_TYPE,
+};
+
 #define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
-- 
1.7.10.2


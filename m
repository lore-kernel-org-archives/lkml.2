Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0H3PqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:46:15 -0400
Received: from s318.xrea.com ([125.53.25.46]:43429 "HELO s318.xrea.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754920Ab0H3PqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:46:14 -0400
From: Naohiro Aota <naota@elisp.net>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Naohiro Aota <naota@elisp.net>, Jiri Kosina <jkosina@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
References: <m27hj8cdsw.fsf@elisp.net>
Date: Tue, 31 Aug 2010 00:39:26 +0900
In-Reply-To: <m27hj8cdsw.fsf@elisp.net> (Naohiro Aota's message of "Tue, 31
	Aug 2010 00:37:03 +0900")
Message-ID: <m2pqx0az4h.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (darwin)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was unclear in original kernel-doc how nextidp worked in
idr_get_next(). Let's describe it.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 lib/idr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index fb86a67..cf8c46b 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -589,7 +589,8 @@ EXPORT_SYMBOL(idr_for_each);
  * @nextidp:  pointer to lookup key
  *
  * Returns pointer to registered object with id, which is next number to
- * given id.
+ * given id. The id pointed by nextidp will be updated
+ * appropriately for next iteration.
  */
 
 void *idr_get_next(struct idr *idp, int *nextidp)
-- 
1.7.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0IKFps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0IKFpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZVHkE8EdNJ/tB+x9PjGCC+8elLPSHwUOMiVeSaJ9tnLxNmecQD+mkoSbtj7ZSZlEIV
         +Sf+9lY50UHv7B/btBgErj+wGQw6A1u52XFFVvqakI6iLq+eEuqildc1D1owmNOKDVhw
         eDa05oVILSnxDniMAhB5OA1r9zJdYPJOIKG6w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/11]net/ipv4/fib_trie.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:45:58 -0700
Message-Id: <1284183963-8474-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
References: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/ipv4/fib_trie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 79d057a..059ac6f 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -16,7 +16,7 @@
  *
  * An experimental study of compression methods for dynamic tries
  * Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
- * http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
+ * http://www.nada.kth.se/
  *
  *
  * IP-address lookup using LC-tries. Stefan Nilsson and Gunnar Karlsson
-- 
1.7.2.1


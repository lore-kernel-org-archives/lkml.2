Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2LaCrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:47:39 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52423 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2LaCrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:47:33 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/2] Document default load and interval values in synchro-test module
Date: Sun, 30 Dec 2012 18:47:14 -0800
Message-Id: <1356922034-25165-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1356922034-25165-1-git-send-email-walken@google.com>
References: <1356922034-25165-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The synchro-test module default parameters are to keep the lock for 2uS
and wait 2uS between release and the next attempted acquisition. Having the
documentation wrong on this point was quite confusing !

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 Documentation/synchro-test.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/synchro-test.txt b/Documentation/synchro-test.txt
index 3d6cdda7bb79..554709478e1f 100644
--- a/Documentation/synchro-test.txt
+++ b/Documentation/synchro-test.txt
@@ -42,12 +42,12 @@ The available arguments are:
 
  (*) load=N
 
-	Each thread delays for N uS whilst holding the lock. The default is 0.
+	Each thread delays for N uS whilst holding the lock. The default is 2.
 
  (*) interval=N
 
 	Each thread delays for N uS whilst not holding the lock. The default
-	is 0.
+	is 2.
 
  (*) do_sched=1
 
-- 
1.7.7.3

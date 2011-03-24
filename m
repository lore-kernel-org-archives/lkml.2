Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab1CXTau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:30:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60296 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974Ab1CXT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rcjfxAt4qf6osZeLf6shVanW8QzU/HZ4sUkDYhSC5rcmM2iPJyvfSLWZESWyguV0sO
         ObdBCMS6SGwWczZS1t8c6BaE9EOlRkJKfwvn3ZSEr9h6iEQxtsgVPPg8naTlEBQMAtkc
         6L9MOSponeMLWQLNRU1J+9D1eI3cV7jrEDu/A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 08/21]drivers:tty:serial:mrst_max3110.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:46 -0700
Message-Id: <1300994819-30930-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/tty/serial/mrst_max3110.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 37e13c3..8890612 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -56,7 +56,7 @@ struct uart_max3110 {
 	wait_queue_head_t wq;
 	struct task_struct *main_thread;
 	struct task_struct *read_thread;
-	struct mutex thread_mutex;;
+	struct mutex thread_mutex;
 
 	u32 baud;
 	u16 cur_conf;
-- 
1.7.4.1


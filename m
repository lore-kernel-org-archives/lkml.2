Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271Ab0GUE57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51532 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab0GUE4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g8EMrPYrmf74SIHwFKl+3vkUrO/BabemLQUaIl34SF4kTU0lOuVN7kRov1QnSxROj7
         tujrc1X0kj4vb7OhGzsfAQ2IRtRlBt0Y++nyzHvLL6m5LFUDS81Koaxgvihd8KGLWVJI
         wTsyXUcqpYHhqJcNh7BqClRKN3FOA7gtYFvcM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 94/94]Documentation/s390/Debugging390.txt update web address.
Date: Tue, 20 Jul 2010 21:56:44 -0700
Message-Id: <1279688215-29628-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/s390/Debugging390.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/s390/Debugging390.txt b/Documentation/s390/Debugging390.txt
index 1eb576a..86f9f74 100644
--- a/Documentation/s390/Debugging390.txt
+++ b/Documentation/s390/Debugging390.txt
@@ -2531,5 +2531,5 @@ Special Thanks
 ==============
 Special thanks to Neale Ferguson who maintains a much
 prettier HTML version of this page at
-http://penguinvm.princeton.edu/notes.html#Debug390
+http://linuxvm.org/penguinvm/
 Bob Grainger Stefan Bader & others for reporting bugs
-- 
1.7.1.rc1.21.gf3bd6


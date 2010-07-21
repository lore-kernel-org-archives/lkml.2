Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab0GUE5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762149Ab0GUEzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DdP5uQKUD6mSanxXo2RBTbWCqXVvOdgbiRtZtTqu6/9ebc1XQzZS2etHHhn0RuO+ez
         HgD4PWvSR3sqK48A8bJ1Fs2XdEsz8hV/urJsLO1/7BqDx5KiMlYN6Dqz5XY6z56XExZw
         Q76Lv0H+lsKC8x8yGdtcXIHSU0Jt/Rwoyei1Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 78/78]Documentation/networking/arcnet.txt update web addresses.
Date: Tue, 20 Jul 2010 21:55:41 -0700
Message-Id: <1279688153-29571-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/arcnet.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/arcnet.txt b/Documentation/networking/arcnet.txt
index 7960125..9ff5795 100644
--- a/Documentation/networking/arcnet.txt
+++ b/Documentation/networking/arcnet.txt
@@ -68,7 +68,7 @@ REAL NAME" to listserv@tichy.ch.uj.edu.pl.  Then, to submit messages to the
 list, mail to linux-arcnet@tichy.ch.uj.edu.pl.
 
 There are archives of the mailing list at:
-	http://tichy.ch.uj.edu.pl/lists/linux-arcnet
+	http://epistolary.org/mailman/listinfo.cgi/arcnet
 
 The people on linux-net@vger.kernel.org have also been known to be very
 helpful, especially when we're talking about ALPHA Linux kernels that may or
@@ -79,7 +79,7 @@ Other Drivers and Info
 ----------------------
 
 You can try my ARCNET page on the World Wide Web at:
-	http://www.worldvisions.ca/~apenwarr/arcnet/
+	http://www.qis.net/~jschmitz/arcnet/	
 
 Also, SMC (one of the companies that makes ARCnet cards) has a WWW site you
 might be interested in, which includes several drivers for various cards
-- 
1.7.1.rc1.21.gf3bd6


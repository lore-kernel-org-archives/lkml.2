Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0GUEwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0GUEwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C2suZJ6tEVqaz/tSY2mg6ftcBmEP5P8nutQQHZBKmtYr7hfr3wi8hdfyNnQOIIcUnq
         QBmmjQC5Uyh8zPnABmPaLk6kYMbU2U+EenH/72iSOwJGbbid5ZID55oDphticEkFDfkG
         0LzWfRsYtVZaR6wW1PH+FcnqFLFjwHav/sfzo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 17/17]Documentation/blockdev/paride.txt update web address.
Date: Tue, 20 Jul 2010 21:51:53 -0700
Message-Id: <1279687926-29360-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a web address due to me being unable
to locate this at all. If anybody knows the location let
me know and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/blockdev/paride.txt |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/Documentation/blockdev/paride.txt b/Documentation/blockdev/paride.txt
index e431267..11c4e3f 100644
--- a/Documentation/blockdev/paride.txt
+++ b/Documentation/blockdev/paride.txt
@@ -409,9 +409,4 @@ the list manager is a robot that will subscribe you using the reply
 address in your mail headers.  REMOVE any anti-spam gimmicks you may
 have in your mail headers, when sending mail to the list server.
 
-You might also find some useful information on the linux-parport
-web pages (although they are not always up to date) at
-
-	http://www.torque.net/parport/
-
 
-- 
1.7.1.rc1.21.gf3bd6


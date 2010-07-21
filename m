Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0GUEvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:51:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0GUEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hWzAqRME1mzUAtGHpu2ZuTmoX0t+F78uE6XXTveFevL8zNB42UCW4qVkMP+7hYQ8YJ
         VcNtxbXYjRYimPYk4O/RSJZcFB4b/C1HEJmRb3VVyv1HnYfPwlZSM81qviWXdgoCFr6B
         qoYBDOM8xaG9WHSq1Cqez05IrwodWcfr5p6jE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 7/7]Documentation/arm/SA1100/Victor update web address.
Date: Tue, 20 Jul 2010 21:50:53 -0700
Message-Id: <1279687861-29282-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address pointing it
too the company site due to me being unable to locate
the original location. If anybody know where this might be
let me know and I'll resend this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/SA1100/Victor |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/arm/SA1100/Victor b/Documentation/arm/SA1100/Victor
index f938a29..1126279 100644
--- a/Documentation/arm/SA1100/Victor
+++ b/Documentation/arm/SA1100/Victor
@@ -3,7 +3,7 @@ VisuAide, Inc. to be used by blind people.
 
 For more information related to Victor, see:
 
-	http://www.visuaide.com/victor
+	http://www.visuaide.com/
 
 Of course Victor is using Linux as its main operating system.
 The Victor implementation for Linux is maintained by Nicolas Pitre:
-- 
1.7.1.rc1.21.gf3bd6


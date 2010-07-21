Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0GUFXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:23:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0GUEvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WAPVEMK/T2W1HIGZg5zDGI594ih1hKfQtTU1pGq/I+K+PpmF8ho9Fg3e6lfLiBfQfn
         O2p6ttNHp0f0e7cE99o6p2gTyL4K//Bd2ea6cAXP7qHD7YM0RMmGNdvG8ApVKaRPoE6L
         6AfrNA0JrJoFZX4dtx6YkqxZU3Ofa87BxxCs4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 11/11]Documentation/arm/SA1100/Itsy update web address.
Date: Tue, 20 Jul 2010 21:50:57 -0700
Message-Id: <1279687861-29282-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates the web address to the company site
due to me being unable to locate the original content. If 
anybody know the location let me know and I'll resend 
an updated patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/SA1100/Itsy |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/arm/SA1100/Itsy b/Documentation/arm/SA1100/Itsy
index 3b59453..43c74ea 100644
--- a/Documentation/arm/SA1100/Itsy
+++ b/Documentation/arm/SA1100/Itsy
@@ -4,7 +4,7 @@ research projects at Compaq that are related to pocket computing.
 
 For more information, see:
 
-	http://www.research.digital.com/wrl/itsy/index.html
+	http://research.digital.com/	
 
 Notes on initial 2.4 Itsy support (8/27/2000) :
 The port was done on an Itsy version 1.5 machine with a daughtercard with
-- 
1.7.1.rc1.21.gf3bd6


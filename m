Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0IGDnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:43:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64687 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0IGDmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vsh1BRkZ/H1iqhBJbcyipEzKOwiTX8m+/HVOJ+rJQksfGSdfiREk4MKgHowXONVZQh
         eTqRIMsYlAOteU43eZIo1o3OYhGG1RtHXExOEbeNhXLySNicpB4FfEbj882oKrG90t0s
         DjdQX0rmsNi05JRa0yKsu+n6njFcHc0GnRZmI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4]Documentation/fb/framebuffer.txt Update web address to the proper one.
Date: Mon,  6 Sep 2010 20:42:58 -0700
Message-Id: <1283830980-25750-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
References: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one missed the boat after the initial commit. Thanks to Geert Uytterhoeven
for pointing this out. So update the web address to the proper address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/fb/framebuffer.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/fb/framebuffer.txt b/Documentation/fb/framebuffer.txt
index 58c5ae2..d1fa777 100644
--- a/Documentation/fb/framebuffer.txt
+++ b/Documentation/fb/framebuffer.txt
@@ -330,7 +330,7 @@ and on its mirrors.
 
 The latest version of fbset can be found at
 
-    http://www.linux-fbdev.org/ 
+    http://users.telenet.be/geertu/Linux/fbdev/ 
 
   
 10. Credits                                                       
-- 
1.7.2.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584Ab0GUFTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:19:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0GUEwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LwqXjsk9OPjRx7ov4xhESxDXJYrbYhsXhxEZ3ePi8Nsqj3Iw4SNwAIkRTaIX9novyh
         7RnnwVwheehiRFqFOpPdU+pyhopyJKadQ5YT+bR74fSKxpv3H42QfhILIiBoPbOoRk2C
         th1ymT0AoiYh0hRkehRptC/7/De8y/BuFUtSs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 30/30]Documentation/filesystems/befs.txt update web address.
Date: Tue, 20 Jul 2010 21:52:06 -0700
Message-Id: <1279687926-29360-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates some broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/filesystems/befs.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/befs.txt b/Documentation/filesystems/befs.txt
index 67391a1..6e49c36 100644
--- a/Documentation/filesystems/befs.txt
+++ b/Documentation/filesystems/befs.txt
@@ -31,7 +31,7 @@ Current maintainer: Sergey S. Kostyliov <rathamahata@php4.ru>
 
 WHAT IS THIS DRIVER?
 ==================
-This module implements the native filesystem of BeOS <http://www.be.com/>
+This module implements the native filesystem of BeOS http://www.beincorporated.com/ 
 for the linux 2.4.1 and later kernels. Currently it is a read-only
 implementation.
 
@@ -61,7 +61,7 @@ step 2.  Configuration & make kernel
 
 The linux kernel has many compile-time options. Most of them are beyond the
 scope of this document. I suggest the Kernel-HOWTO document as a good general
-reference on this topic. <http://www.linux.com/howto/Kernel-HOWTO.html>
+reference on this topic. http://www.linuxdocs.org/HOWTOs/Kernel-HOWTO-4.html 
 
 However, to use the BeFS module, you must enable it at configure time.
 
-- 
1.7.1.rc1.21.gf3bd6


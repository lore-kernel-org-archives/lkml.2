Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0GUExk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:53:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab0GUExD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FhiMpvnn0WOb+v4wOKlS7EzEROn8gwzbNuCDGH2eBCcpTF88ff+ECSN48PirDkpakk
         KuPfqSfV7Cn11qUKznN0iT246ztFng0xUUqEHJmYQqY2rjGkNJ2pq8fwnGAGhL8+gZN2
         Uw/LJQx+EyFBsHHQbbF4h1rx4Jv2Sj44R/UXo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 35/35]Documentation/HOWTO update web address.
Date: Tue, 20 Jul 2010 21:52:52 -0700
Message-Id: <1279687982-29413-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates some borken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/HOWTO |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 40ada93..365bda9 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -187,7 +187,7 @@ apply a patch.
 If you do not know where you want to start, but you want to look for
 some task to start doing to join into the kernel development community,
 go to the Linux Kernel Janitor's project:
-	http://janitor.kernelnewbies.org/
+	http://kernelnewbies.org/KernelJanitors	
 It is a great place to start.  It describes a list of relatively simple
 problems that need to be cleaned up and fixed within the Linux kernel
 source tree.  Working with the developers in charge of this project, you
@@ -315,7 +315,7 @@ process is tracked with the tool patchwork.  Patchwork offers a web
 interface which shows patch postings, any comments on a patch or
 revisions to it, and maintainers can mark patches as under review,
 accepted, or rejected.  Most of these patchwork sites are listed at
-http://patchwork.kernel.org/ or http://patchwork.ozlabs.org/.
+http://patchwork.kernel.org/.
 
 2.6.x -next kernel tree for integration tests
 ---------------------------------------------
@@ -595,7 +595,7 @@ start exactly where you are now.
 
 ----------
 Thanks to Paolo Ciarrocchi who allowed the "Development Process"
-(http://linux.tar.bz/articles/2.6-development_process) section
+(http://lwn.net/Articles/94386/) section
 to be based on text he had written, and to Randy Dunlap and Gerrit
 Huizenga for some of the list of things you should and should not say.
 Also thanks to Pat Mochel, Hanna Linder, Randy Dunlap, Kay Sievers,
-- 
1.7.1.rc1.21.gf3bd6


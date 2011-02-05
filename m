Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1BEOXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:23:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1BEOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f/xurQupFcS7EwdfDzN8S6PeG5SoLKv0YX5LjBzX/83sm0J/pqPnF88zC7owJBphln
         FK3nrYvpqSjdgIuzjBsFIzRnIy/sz4pvl7u9R7khJnVyYmqmY60cRPtMP2C4oikDdNn2
         uWSG4cspLHxs9npK+0NdN+M5X6UeR8da1rdcs=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 46/52] kstrtox: convert microblaze
Date: Sat,  5 Feb 2011 16:20:49 +0200
Message-Id: <1296915654-7458-46-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/microblaze/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index ba034d4..ac81870 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -27,7 +27,7 @@ static unsigned long kstack_depth_to_print;	/* 0 == entire stack */
 
 static int __init kstack_setup(char *s)
 {
-	return !strict_strtoul(s, 0, &kstack_depth_to_print);
+	return !kstrtoul(s, 0, &kstack_depth_to_print);
 }
 __setup("kstack=", kstack_setup);
 
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1FJHJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:09:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59808 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1FJHJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Vrgkhlky/cVXoDbbvpg9Bs9f1E4+4wTOPZeazfds//2o8y0ZVL1AkkdQ9khd3bQJd7
         PvGH68rxxnIhBN2UZP/BoPM8E97e7iLx4uUkcqhi471BqTi/KCBfnHawUj+yn1zXkh0d
         BZ++66CCnGyuPd8oa9tCCJs5PcMFG/Ctvlhow=
Date: Fri, 10 Jun 2011 10:09:37 +0300
From: Maxin B John <maxin.john@gmail.com>
To: dbaluta@ixiacom.com
Cc: nux-doc@vger.kernel.org, catalin.marinas@arm.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update kmemleak architecture support
 info
Message-ID: <20110610070937.GA2802@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am fine with this. What do you say about having
> something generic like:
>
> "Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug
> for supported platforms"
>
> In this way, there's no need to update kememleak.txt everytime
> when a new platform is supported.

I think it looks better. I have updated the Documentation as per your
suggestion. Please find the modified patch below:

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 090e6ee..0915667 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -11,7 +11,9 @@ with the difference that the orphan objects are not freed but only
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
-Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
+Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, tile,
+s390 and mips.Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug
+for supported platforms.
 
 Usage
 -----

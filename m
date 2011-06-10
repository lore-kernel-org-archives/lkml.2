Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab1FJTKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:10:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59629 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1FJTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PGXXbKNopyfqYkImUbZbBY52WFq/IMqo1PGOKLghBBseep1HzekC/lf7Ffa0r3fJuw
         Q8v9uIsLzwHdOof1LVNjEJY9+qHSHV+nU53CY07i2zJhfG1PZ9EtkHtFkFbIjHiiuip5
         TJmLt4lruLtPH+wLNqBa92Y3ev1mdP0nwSW98=
Date: Fri, 10 Jun 2011 22:09:56 +0300
From: Maxin B John <maxin.john@gmail.com>
To: rdunlap@xenotime.net
Cc: catalin.marinas@arm.com, dbaluta@ixiacom.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update kmemleak architecture support
 info
Message-ID: <20110610190956.GA2742@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think Daniel's suggestion is better, we don't have to worry about
>> changing the documentation every time we add a new architecture.
I agree with that.

> Please send an updated patch without the currently-supported list
> of architectures.
Please find the updated patch below: 

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 090e6ee..51063e6 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -11,7 +11,9 @@ with the difference that the orphan objects are not freed but only
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
-Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
+
+Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug for supported
+architectures.
 
 Usage
 -----


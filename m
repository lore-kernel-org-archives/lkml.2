Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1FITAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:00:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43973 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1FITAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HmERQ8Mm6UlmXmzt0Fti8L0CkONJ0XIhOr7AaPgfAlCiq4/B78eYpPQErzSiJuC6X2
         wEapHxvBwnGCWvf6fyZs9S3kYd7CMZOXWVajiIaQ94SQdvGKeilfvEaWGVtBATy+UbRs
         fGC488XLUnrT0TJwylrhcxBU7xu3Ms06Cw0Io=
Date: Thu, 9 Jun 2011 21:59:58 +0300
From: Maxin B John <maxin.john@gmail.com>
To: linux-doc@vger.kernel.org
Cc: catalin.marinas@arm.com, rdunlap@xenotime.net, dbaluta@ixiacom.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: update kmemleak architecture support info
Message-ID: <20110609185957.GA3250@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemleak now supports s390 and mips too.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 090e6ee..82833ff 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -11,7 +11,8 @@ with the difference that the orphan objects are not freed but only
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
-Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
+Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, tile,
+s390 and mips.
 
 Usage
 -----

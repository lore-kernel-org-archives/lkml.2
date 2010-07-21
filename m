Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0GUEvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:51:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63473 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0GUEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wpqdy3hWclREKPAAsDMkT0HGtexqwpVp5FsYS1CrvdtLTeOyYfHsn3nVVP8XOTax4/
         mhVJfq3vXoC/8GO99yNV90QnH5T0j2kC+iVkLGhhCpmY4Zq939YMoXr6ncidNK0LxP/b
         d78kqzf5ecuBDkERw4Kq6EAu4l8pJVDfShGIY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/6]Documentation/arm/README update web addresses.
Date: Tue, 20 Jul 2010 21:50:52 -0700
Message-Id: <1279687861-29282-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/README |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm/README b/Documentation/arm/README
index d98783f..aea3409 100644
--- a/Documentation/arm/README
+++ b/Documentation/arm/README
@@ -41,12 +41,12 @@ Bug reports etc
 ---------------
 
   Please send patches to the patch system.  For more information, see
-  http://www.arm.linux.org.uk/patches/info.html  Always include some
+  http://www.arm.linux.org.uk/developer/patches/info.php Always include some
   explanation as to what the patch does and why it is needed.
 
   Bug reports should be sent to linux-arm-kernel@lists.arm.linux.org.uk,
   or submitted through the web form at
-  http://www.arm.linux.org.uk/forms/solution.shtml
+  http://www.arm.linux.org.uk/developer/ 
 
   When sending bug reports, please ensure that they contain all relevant
   information, eg. the kernel messages that were printed before/during
-- 
1.7.1.rc1.21.gf3bd6


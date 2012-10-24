Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239Ab2JXRW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:22:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59362 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965173Ab2JXRW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:22:57 -0400
Date: Wed, 24 Oct 2012 10:22:43 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Michael Witten <mfwitten@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] README: document "make olddefconfig"
Message-ID: <20121024172243.GA6707@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While "olddefconfig" was documented in "make help", it was not mentioned
in the README.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 README |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README b/README
index f32710a..a24ec89 100644
--- a/README
+++ b/README
@@ -180,6 +180,10 @@ CONFIGURING the kernel:
                         with questions already answered.
                         Additionally updates the dependencies.
 
+     "make olddefconfig"
+                        Like above, but sets new symbols to their default
+                        values without prompting.
+
      "make defconfig"   Create a ./.config file by using the default
                         symbol values from either arch/$ARCH/defconfig
                         or arch/$ARCH/configs/${PLATFORM}_defconfig,
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2JWNp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:45:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053Ab2JWNpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:45:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] UAPI: Fix tools/vm/page-types.c
To: fengguang.wu@intel.com, dshadowwolf@gmail.com
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Oct 2012 14:20:07 +0100
Message-ID: <20121023132007.32177.42349.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix tools/vm/page-types.c to use the UAPI variant of linux/kernel-page-flags.h
lest the following error appear:

	In file included from page-types.c:38:0:
	../../include/linux/kernel-page-flags.h:4:42: fatal error:
	uapi/linux/kernel-page-flags.h: No such file or directory

Reported-by: Daniel Hazelton <dshadowwolf@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Fengguang Wu <fengguang.wu@intel.com>
---

 tools/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index cd1b03e..b76edf2 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -35,7 +35,7 @@
 #include <sys/mount.h>
 #include <sys/statfs.h>
 #include "../../include/uapi/linux/magic.h"
-#include "../../include/linux/kernel-page-flags.h"
+#include "../../include/uapi/linux/kernel-page-flags.h"
 
 
 #ifndef MAX_PATH


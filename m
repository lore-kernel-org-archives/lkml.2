Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab1FFS65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:58:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab1FFS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o+1KqjDlAOVXDyNdw0uL9B0VUNwDRR8zFcNyFg9yjcnReN+OrBS6Be45GwOxkdjSFd
         64E12TmXSEXZ+KVzk3RbDZxto8reo7U3e+QNS/71bXButIYHRj6QfqZv+mMsZV0+TbIH
         9VM6SKn9yN/kowSLOezqDA7cybdIztaVADLXI=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 5/9] kconfig: add missing <stdlib.h> inclusion
Date: Mon,  6 Jun 2011 14:58:27 -0400
Message-Id: <1307386711-8866-6-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header is needed when using {m,re}alloc(3) and free(3) function family.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index e07d557..d0b8b23 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -6,6 +6,7 @@
  */
 
 #include <stdarg.h>
+#include <stdlib.h>
 #include <string.h>
 #include "lkc.h"
 
-- 
1.7.3.4.574.g608b.dirty


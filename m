Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1APNJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:09:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1APNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hGf378QF5acHUAhekyjVjTFcZDbWZ6b9kiHMz28BW0iWlpxffhT/WFow5KAM1y09lI
         KUQBgzifFq/Ea0cjcD7tVMcX5VcI3KlM+tx4+mzRPG/upsbN2JpXJuKyLYSFg+l0qvqT
         /D+YBbuPiy/W/PQ7JE529eQhGwknbuv4q77Dk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v4 10/24] rds: stop including asm-generic/bitops/le.h
Date: Sun, 16 Jan 2011 22:08:39 +0900
Message-Id: <1295183333-13802-11-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to include asm-generic/bitops/le.h as all architectures provide
little-endian bit operations now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - No change

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 net/rds/cong.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/rds/cong.c b/net/rds/cong.c
index 566d1b7..9171074 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -34,8 +34,6 @@
 #include <linux/types.h>
 #include <linux/rbtree.h>
 
-#include <asm-generic/bitops/le.h>
-
 #include "rds.h"
 
 /*
-- 
1.7.3.4


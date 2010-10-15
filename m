Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0JOJrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:47:35 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37656 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754757Ab0JOJos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:48 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andy Grover <andy.grover@oracle.com>, rds-devel@oss.oracle.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 08/22] rds: stop including asm-generic/bitops/le.h
Date: Fri, 15 Oct 2010 18:46:07 +0900
Message-Id: <1287135981-17604-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to include asm-generic/bitops/le.h as all architectures
provide little endian bit operations now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: rds-devel@oss.oracle.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/rds/cong.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/rds/cong.c b/net/rds/cong.c
index c6784d5..15a65f0 100644
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
1.7.1.231.gd0b16


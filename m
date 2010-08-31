Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0HaMMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:12:50 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:44477 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755334Ab0HaMMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:12:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/12] DMAENGINE: fetch tasklet struct for PL08X include file
Date: Tue, 31 Aug 2010 14:12:05 +0200
Message-ID: <1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PL08X include file is using struct tasklet so let us bring this
in apropriately.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 include/linux/amba/pl08x.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 8435f4a..2bb7ac4 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -20,6 +20,7 @@
 
 /* We need sizes of structs from this header */
 #include <linux/dmaengine.h>
+#include <linux/interrupt.h>
 
 /**
  * struct pl08x_channel_data - data structure to pass info between
-- 
1.6.3.3


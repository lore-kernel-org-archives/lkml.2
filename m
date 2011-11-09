Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1KIWLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:11:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41871 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab1KIWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:10:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=M8oYePhstbPnrBCjFrd3sBhsAT7U/hGC8D/PoXjXMHzHaGD7X+10W43FhKJS9xh3I
	3xrnbhpIoLzpl0AciBmFA==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v1 9/9] forcedeth: whitespace/indentation fixes
Date: Wed,  9 Nov 2011 14:09:23 -0800
Message-Id: <9bd6b5433ed16ce2f7e5b1af92850272da61567b.1320875577.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 2e45a45..669578f 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -65,7 +65,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/prefetch.h>
-#include  <linux/io.h>
+#include <linux/io.h>
 
 #include <asm/irq.h>
 #include <asm/system.h>
-- 
1.7.3.1


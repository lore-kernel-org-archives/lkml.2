Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1KPFRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:17:01 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:51981 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1KPFQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:16:33 -0500
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v5 10/10] forcedeth: whitespace/indentation fixes
Date: Tue, 15 Nov 2011 21:15:58 -0800
Message-Id: <f3c67a24028a8898106ef668b7fc1bfe687f791f.1321420514.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321420513.git.david.decotigny@google.com>
References: <cover.1321420513.git.david.decotigny@google.com>
In-Reply-To: <cover.1321420513.git.david.decotigny@google.com>
References: <cover.1321420513.git.david.decotigny@google.com>
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
index 5d436b5..973cf79 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1I1GUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:20:48 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41108 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1I1GUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:20:47 -0400
Date: Wed, 28 Sep 2011 16:20:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: linux-next: manual merge of the moduleh tree with Linus' tree
Message-Id: <20110928162040.f22c4eb1f63b5ae7e4a13a34@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c between commit
124d770a6459 ("pch_gbe: added the process of FIFO over run error") from
Linus' tree and commit c3c292bec445 ("drivers/net: Add module.h to
drivers who were implicitly using it") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 5dc61b4,848dce1..0000000
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@@ -20,6 -20,8 +20,7 @@@
  
  #include "pch_gbe.h"
  #include "pch_gbe_api.h"
 -#include <linux/prefetch.h>
+ #include <linux/module.h>
  
  #define DRV_VERSION     "1.00"
  const char pch_driver_version[] = DRV_VERSION;

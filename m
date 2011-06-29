Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1F2Mlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:41:36 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:53620 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1F2Mld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:41:33 -0400
Date: Wed, 29 Jun 2011 14:41:32 +0200
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] xen/netback: Add module alias for autoloading
Message-ID: <20110629124132.GD31038@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	xen-devel@lists.xensource.com,
	virtualization@lists.linux-foundation.org,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xen-backend:vif module alias to the xen-netback module. This allows
automatic loading of the module.

Signed-off-by: Bastian Blank <waldi@debian.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/net/xen-netback/netback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 0e4851b..fd00f25 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1743,3 +1743,4 @@ failed_init:
 module_init(netback_init);
 
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_ALIAS("xen-backend:vif");
-- 
1.7.5.4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0GNMkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:40:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43554 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366Ab0GNMkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:40:00 -0400
Date: Wed, 14 Jul 2010 14:39:58 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 03/11] Removing dead CASSINI_QGE_DEBUG
Message-ID: <f44daaa9771dd77f0d351aac327436ebad005fa3.1279110894.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279110894.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CASSINI_QGE_DEBUG doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/net/cassini.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/cassini.h b/drivers/net/cassini.h
index fd17a00..dbc4787 100644
--- a/drivers/net/cassini.h
+++ b/drivers/net/cassini.h
@@ -2844,10 +2844,6 @@ struct cas {
 	atomic_t		reset_task_pending_all;
 #endif
 
-#ifdef CONFIG_CASSINI_QGE_DEBUG
-	atomic_t interrupt_seen; /* 1 if any interrupts are getting through */
-#endif
-
 	/* Link-down problem workaround */
 #define LINK_TRANSITION_UNKNOWN 	0
 #define LINK_TRANSITION_ON_FAILURE 	1
-- 
1.7.0.4


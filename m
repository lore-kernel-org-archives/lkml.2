Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1BHTgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:36:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:45656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab1BHTfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:35:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="885571370"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 12/12] n_tracerouter and n_tracesink Makefile addition.
Date: Tue,  8 Feb 2011 11:34:57 -0800
Message-Id: <1297193697-5417-13-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297193697-5417-12-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-11-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-12-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This allows n_tracerouter and n_tracesink to be compiled in the
Linux kernel.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/tty/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index c43ef48..8c56ffd 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -7,5 +7,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
 obj-$(CONFIG_N_GSM)		+= n_gsm.o
 obj-$(CONFIG_R3964)		+= n_r3964.o
+obj-$(CONFIG_TRACE_ROUTER)      += n_tracerouter.o
+obj-$(CONFIG_TRACE_SINK)        += n_tracesink.o
 
 obj-y				+= vt/
-- 
1.6.6.1


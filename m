Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1BIASA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:18:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:58012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab1BIARX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:17:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,444,1291622400"; 
   d="scan'208";a="705558329"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 12/12] n_tracerouter and n_tracesink Makefile addition.
Date: Tue,  8 Feb 2011 16:17:17 -0800
Message-Id: <1297210637-5934-12-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297210637-5934-11-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297210637-5934-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-8-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-9-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-10-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-11-git-send-email-james_p_freyensee@linux.intel.com>
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


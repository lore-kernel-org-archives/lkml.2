Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab1BHTg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:36:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:14403 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab1BHTfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:35:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="385927884"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 07/12] n_tracerouter and n_tracesink additions.
Date: Tue,  8 Feb 2011 11:34:52 -0800
Message-Id: <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch adds line discipline numbers to n_tracerouter and
n_tracesink line disciplines for the Intel-Atom PTI implementation
for mobile devices.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 include/linux/tty.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 54e4eaa..c507f53 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -50,6 +50,8 @@
 #define N_CAIF		20      /* CAIF protocol for talking to modems */
 #define N_GSM0710	21	/* GSM 0710 Mux */
 #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
+#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
+#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.6.6.1


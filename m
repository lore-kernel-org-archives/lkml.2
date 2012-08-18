Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2HRRb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:35714 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab2HRRa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="204520310"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/31] sections: Fix section conflicts in drivers/char
Date: Sat, 18 Aug 2012 10:30:03 -0700
Message-Id: <1345311022-26328-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/char/mbcs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 47ff7e4..0c7d340 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -799,7 +799,7 @@ static int mbcs_remove(struct cx_dev *dev)
 	return 0;
 }
 
-static const struct cx_device_id __devinitdata mbcs_id_table[] = {
+static const struct cx_device_id __devinitconst mbcs_id_table[] = {
 	{
 	 .part_num = MBCS_PART_NUM,
 	 .mfg_num = MBCS_MFG_NUM,
-- 
1.7.7.6


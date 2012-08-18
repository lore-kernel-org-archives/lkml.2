Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2HRRdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:8308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2HRRa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354046"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/31] sections: Fix section conflicts in drivers/atm
Date: Sat, 18 Aug 2012 10:30:02 -0700
Message-Id: <1345311022-26328-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/atm/eni.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 2059ee4..81e44f7 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1567,7 +1567,7 @@ tx_complete++;
 /*--------------------------------- entries ---------------------------------*/
 
 
-static const char *media_name[] __devinitdata = {
+static char * const media_name[] __devinitconst = {
     "MMF", "SMF", "MMF", "03?", /*  0- 3 */
     "UTP", "05?", "06?", "07?", /*  4- 7 */
     "TAXI","09?", "10?", "11?", /*  8-11 */
-- 
1.7.7.6


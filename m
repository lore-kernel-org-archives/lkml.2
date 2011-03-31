Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1CaGov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:44:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46352 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1CaGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FFaYmzdl7kZcaiC8nulfgfMxA7LduY2BiikCiYmKkGjm88VEjF3MyiZIs9Xl6pW9x2
         QHdUAO5n18OJDL2F00ovWNi0QNBtw5UBqw9GbRXd7JM8QWj3C+wxNzLYdQFG6ccmj9X/
         NLbHxdCg3XCblRLd0muZago5AL5KcBrlJ+2Tw=
From: Pan Weiping <panweiping3@gmail.com>
Cc: Pan Weiping <panweiping3@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (maintainer:STAGING SUBSYSTEM 
	,commit_signer:4/5=80%),
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com> (commit_signer:3/5=60%),
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es> (commit_signer:1/5=20%),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] rt2860:typo in comment
Date: Thu, 31 Mar 2011 14:45:46 +0800
Message-Id: <1301553947-29058-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use accumulated instead of acumulated.
Signed-off-by: Pan Weiping <panweiping3@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index d9c3fd5..0b59073 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1825,7 +1825,7 @@ void MlmeSetTxRate(struct rt_rtmp_adapter *pAd,
 /*
 	==========================================================================
 	Description:
-		This routine calculates the acumulated TxPER of eaxh TxRate. And
+		This routine calculates the accumulated TxPER of eaxh TxRate. And
 		according to the calculation result, change CommonCfg.TxRate which
 		is the stable TX Rate we expect the Radio situation could sustained.
 
-- 
1.7.4


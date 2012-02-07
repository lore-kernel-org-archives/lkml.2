Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2BGO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:26:53 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34159 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2BGO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:49 -0500
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/6] MCE, AMD: Correct VB data error description
Date: Tue,  7 Feb 2012 15:26:04 +0100
Message-Id: <1328624767-7956-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1328624767-7956-1-git-send-email-bp@amd64.org>
References: <1328624767-7956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Sync with latest BKDG error types.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/edac/mce_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 5626e17..bf6dd99 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -104,7 +104,7 @@ static const char * const f15h_cu_mce_desc[] = {
 	"WCC Tag ECC error",
 	"WCC Data ECC error",
 	"WCB Data parity error",
-	"VB Data/ECC error",
+	"VB Data ECC or parity error",
 	"L2 Tag ECC error",				/* xec = 0x10 */
 	"Hard L2 Tag ECC error",
 	"Multiple hits on L2 tag",
-- 
1.7.8.rc0


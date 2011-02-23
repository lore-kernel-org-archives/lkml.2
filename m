Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1BWNZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:25:48 -0500
Received: from cernmx32.cern.ch ([137.138.144.178]:52024 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1BWNZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:25:46 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <wfp5p@virginia.edu>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/2] staging: vme: remove unreachable code
Date: Wed, 23 Feb 2011 14:25:27 +0100
Message-ID: <1298467528-26472-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
References: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed some unreachable code from vme_register_bridge

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index d9fc864..88bf455 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1363,7 +1363,6 @@ int vme_register_bridge(struct vme_bridge *bridge)
 
 	return retval;
 
-	i = VME_SLOTS_MAX;
 err_reg:
 	while (i > -1) {
 		dev = &bridge->dev[i];
-- 
1.7.1


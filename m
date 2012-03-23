Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2CWEAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:00:15 -0400
Received: from hermod.sentelic.com ([203.69.18.19]:12544 "EHLO
	hermod.sentelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2CWEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:00:11 -0400
From: Tai-hwa Liang <avatar@sentelic.com>
To: Oskari Saarenmaa <os@ohmu.fi>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] Input: sentelic - minor code cleaning up
Date: Fri, 23 Mar 2012 11:52:20 +0800
Message-Id: <1332474741-19426-5-git-send-email-avatar@sentelic.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
References: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improving code readability by converting yet another magic number into a
pre-defined constant.

Signed-off-by: Tai-hwa Liang <avatar@sentelic.com>
---
 drivers/input/mouse/sentelic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 0b57fe4..4fe9474 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -767,7 +767,7 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 	case FSP_PKT_TYPE_NORMAL_OPC:
 		/* on-pad click, filter it if necessary */
 		if ((ad->flags & FSPDRV_FLAG_EN_OPC) != FSPDRV_FLAG_EN_OPC)
-			packet[0] &= ~BIT(0);
+			packet[0] &= ~FSP_PB0_LBTN;
 		/* fall through */
 
 	case FSP_PKT_TYPE_NORMAL:
-- 
1.7.9.1


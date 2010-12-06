Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0LFWF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:28 -0500
Received: from mail.perches.com ([173.55.12.10]:2332 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/29] drivers/scsi/fcoe: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:03 -0800
Message-Id: <a9de52cf89232dde4be1e591a2531818d4346fd1.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index bc17c71..58ad3c7 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -2475,7 +2475,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 	case FIP_ST_LINK_WAIT:
 		goto unlock;
 	default:
-		WARN(1, "unexpected state %d", fip->state);
+		WARN(1, "unexpected state %d\n", fip->state);
 		goto unlock;
 	}
 	mod_timer(&fip->timer, next_time);
-- 
1.7.3.2.245.g03276.dirty


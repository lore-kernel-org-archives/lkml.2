Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0J3VOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:14:00 -0400
Received: from mail.perches.com ([173.55.12.10]:3753 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab0J3VJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:38 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/39] drivers/scsi/fcoe: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:37 -0700
Message-Id: <c4ae487c4fa53a98962db358ad1cb6eb18f6b369.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index aa503d8..49f4edb 100644
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
1.7.3.1.g432b3.dirty


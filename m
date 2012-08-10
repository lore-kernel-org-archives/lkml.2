Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2HJLrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:47:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab2HJLrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:47:21 -0400
From: Petr Uzel <petr.uzel@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH] [SCSI] fix typo in scsi documentation
Date: Fri, 10 Aug 2012 13:47:02 +0200
Message-Id: <1344599224-4074-1-git-send-email-petr.uzel@suse.cz>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 Documentation/scsi/scsi_eh.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 6ff16b6..128348e 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -53,7 +53,7 @@ does the following.
  1. Delete timeout timer.  If it fails, it means that timeout timer
     has expired and is going to finish the command.  Just return.
 
- 2. Link scmd to per-cpu scsi_done_q using scmd->en_entry
+ 2. Link scmd to per-cpu scsi_done_q using scmd->eh_entry
 
  3. Raise SCSI_SOFTIRQ
 
-- 
1.7.7


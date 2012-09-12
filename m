Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2ILRDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:03:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34282 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760759Ab2ILRDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:35 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/15] fs/dlm/rcom.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:08 +0200
Message-Id: <1347469402-27557-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 fs/dlm/rcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 9d61947..73d3715 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -577,7 +577,7 @@ void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		lock = 1;
 		reply = 1;
 		break;
-	};
+	}
 
 	spin_lock(&ls->ls_recover_lock);
 	status = ls->ls_recover_status;


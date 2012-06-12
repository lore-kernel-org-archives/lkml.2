Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2FLPju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:39:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59313 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2FLPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:47 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 03/16] Export get_random_int()
Date: Tue, 12 Jun 2012 08:39:09 -0700
Message-Id: <1339515562-14638-4-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4ec04a7..78ff2f6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1362,6 +1362,7 @@ unsigned int get_random_int(void)
 
 	return ret;
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
-- 
1.7.9.3.327.g2980b


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620Ab2ILRFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:05:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58044 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760781Ab2ILRDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:40 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: John McCutchan <john@johnmccutchan.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] fs/notify/inotify/inotify_fsnotify.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:19 +0200
Message-Id: <1347469402-27557-12-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 871569c..0cd3919 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -63,7 +63,7 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 			else if (old->mask & FS_IN_IGNORED)
 				return false;
 			return true;
-		};
+		}
 	}
 	return false;
 }


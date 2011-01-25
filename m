Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1AYOqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:46:10 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42667 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753419Ab1AYOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:46:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=TOpBvPPuAU5EoIbUVhFY6BiaQbLapCpirybz9hI+MbjyNgZ3fw6pJjR6LvTN74m+h3ZRmIf9xZjS2G0Fqt7s7eoR1VeIoWJVRwHsAPh0mTL0K9mRe5Fbjn8p8FNpQpVf;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] block/trivial: Fix comment typo "iff".
Date: Tue, 25 Jan 2011 22:45:37 +0800
Message-Id: <1295966737-4111-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.42.200 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Change "iff" to "if".

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/genhd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6a5b772..4a93d31 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1403,7 +1403,7 @@ static unsigned long disk_events_poll_jiffies(struct gendisk *disk)
 
 	/*
 	 * If device-specific poll interval is set, always use it.  If
-	 * the default is being used, poll iff there are events which
+	 * the default is being used, poll if there are events which
 	 * can't be monitored asynchronously.
 	 */
 	if (ev->poll_msecs >= 0)
-- 
1.7.1


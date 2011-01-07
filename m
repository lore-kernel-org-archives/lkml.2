Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1AGMKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:10:02 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:3144 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1AGMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:10:00 -0500
X-Greylist: delayed 1745 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2011 07:10:00 EST
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@landau.phys.spbu.ru>
Subject: [RESEND PATCH 2/2] do_mounts: Small style cleanup in match_dev_by_uuid
Date: Fri,  7 Jan 2011 14:42:42 +0300
Message-Id: <88a134a43594a67cd759f8dbfce45606ef6f295a.1294400351.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.7.4.rc1
In-Reply-To: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
References: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
References: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 init/do_mounts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 1dda439..5da7c7a 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -75,7 +75,7 @@ static int match_dev_by_uuid(struct device *dev, void *data)
 		goto no_match;
 
 	if (memcmp(uuid, part->info->uuid, sizeof(part->info->uuid)))
-			goto no_match;
+		goto no_match;
 
 	return 1;
 no_match:
-- 
1.7.4.rc1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1DJQF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 12:05:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10143 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1DJQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 12:05:55 -0400
Date: Sun, 10 Apr 2011 18:06:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>, trivial@kernel.org
Subject: [PATCH][Trivial] md, raid5: Fix spelling error in comment ('Ofcourse'
 --> 'Of course').
Message-ID: <alpine.LNX.2.00.1104101757100.17454@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a small typo in a comment in drivers/md/raid5.c - 'Of course' is 
misspelled as 'Ofcourse'. This patch fixes the spelling error.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e867ee4..304b506 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3976,7 +3976,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 			/* spinlock is needed as reshape_progress may be
 			 * 64bit on a 32bit platform, and so it might be
 			 * possible to see a half-updated value
-			 * Ofcourse reshape_progress could change after
+			 * Of course reshape_progress could change after
 			 * the lock is dropped, so once we get a reference
 			 * to the stripe that we think it is, we will have
 			 * to check again.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


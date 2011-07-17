Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1GQTP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 15:15:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21481 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab1GQTPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 15:15:55 -0400
Date: Sun, 17 Jul 2011 21:15:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, trivial@kernel.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: [PATCH][TRIVIAL] uwb: Fix misspelling of neighbourhood in comment
Message-ID: <alpine.LNX.2.00.1107172113410.32359@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/uwb/uwbd.c, the word 'neighbourhood' is misspelled as
'neighboorhood' in a comment. Fix that.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/uwb/uwbd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/uwbd.c b/drivers/uwb/uwbd.c
index 001c8b4..bdcb13c 100644
--- a/drivers/uwb/uwbd.c
+++ b/drivers/uwb/uwbd.c
@@ -256,7 +256,7 @@ static void uwbd_event_handle(struct uwb_event *evt)
  * UWB Daemon
  *
  * Listens to all UWB notifications and takes care to track the state
- * of the UWB neighboorhood for the kernel. When we do a run, we
+ * of the UWB neighbourhood for the kernel. When we do a run, we
  * spinlock, move the list to a private copy and release the
  * lock. Hold it as little as possible. Not a conflict: it is
  * guaranteed we own the events in the private list.
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


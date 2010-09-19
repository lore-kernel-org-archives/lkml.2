Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0ISKE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 06:04:26 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58466 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0ISKEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 06:04:25 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH] w35und: Add locking problems to TODO list
Date: Sun, 19 Sep 2010 13:04:21 +0300
Message-Id: <1284890661-14221-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The w35und uses atomics such as "ThreadCount" and "FireCount" to emulate
locking in the TX paths, for example. Document this bug in the TODO list.

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/TODO |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/winbond/TODO b/drivers/staging/winbond/TODO
index 43bee56..b4c592a 100644
--- a/drivers/staging/winbond/TODO
+++ b/drivers/staging/winbond/TODO
@@ -6,6 +6,7 @@ TODO:
 	- remove unused ioctls
 	- use cfg80211 for regulatory stuff
 	- fix 4k stack problems
+	- fix locking problems (it's done using atomics...)
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 Pavel Machek <pavel@ucw.cz>
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1BNXGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:06:45 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:47899 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1BNXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:06:43 -0500
Subject: [PATCH] [TRIVIAL] fix comment typo initilaization
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 15 Feb 2011 00:05:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297724802.1793.36.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 fs/fuse/cuse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 3e87cce..7c39b88 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -458,7 +458,7 @@ static void cuse_fc_release(struct fuse_conn *fc)
  * @file: file struct being opened
  *
  * Userland CUSE server can create a CUSE device by opening /dev/cuse
- * and replying to the initilaization request kernel sends.  This
+ * and replying to the initialization request kernel sends.  This
  * function is responsible for handling CUSE device initialization.
  * Because the fd opened by this function is used during
  * initialization, this function only creates cuse_conn and sends
-- 
1.7.4




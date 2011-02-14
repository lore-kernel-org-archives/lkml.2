Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1BNXFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:05:38 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35248 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1BNXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:05:36 -0500
Subject: [PATCH] [TRIVIAL] hvcs: fix typo in comment
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 15 Feb 2011 00:05:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297724735.1793.34.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/char/hvcs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index bedc6c1..af4e650 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -292,7 +292,7 @@ struct hvcs_struct {
 	/*
 	 * Any variable below the kref is valid before a tty is connected and
 	 * stays valid after the tty is disconnected.  These shouldn't be
-	 * whacked until the koject refcount reaches zero though some entries
+	 * whacked until the kobject refcount reaches zero though some entries
 	 * may be changed via sysfs initiatives.
 	 */
 	struct kref kref; /* ref count & hvcs_struct lifetime */
-- 
1.7.4




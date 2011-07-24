Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab1GXP7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 11:59:42 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:37227 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1GXP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 11:59:36 -0400
Subject: [PATCH] [TRIVIAL] Fix comment typo 'evenpoll'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 24 Jul 2011 17:58:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.3 (3.1.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311523175.2098.13.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..5e480d5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -700,7 +700,7 @@ static const struct file_operations eventpoll_fops = {
 	.llseek		= noop_llseek,
 };
 
-/* Fast test to see if the file is an evenpoll file */
+/* Fast test to see if the file is an eventpoll file */
 static inline int is_file_epoll(struct file *f)
 {
 	return f->f_op == &eventpoll_fops;
-- 
1.7.6




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1LAVlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:41:32 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43633 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754723Ab1LAVla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:41:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH 03/11] fs/splice: export splice_to_pipe to GPL modules
Date: Thu,  1 Dec 2011 16:41:15 -0500
Message-Id: <1322775683-8741-4-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LTTng driver needs this symbol exported because it implements its
own splice actor.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
---
 fs/splice.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index fa2defa..9eb15b5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -263,6 +263,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(splice_to_pipe);
 
 void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 {
-- 
1.7.5.4


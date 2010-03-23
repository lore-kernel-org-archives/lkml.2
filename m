Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0CWAcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:45244 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0CWAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:13 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/18] block: Generate blktrace trace points only if blktrace is enabled
Date: Tue, 23 Mar 2010 01:32:04 +0100
Message-Id: <1269304340-25372-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/block.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 5fb7273..6412165 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM block
+#define TRACE_CONFIG CONFIG_BLK_DEV_IO_TRACE
 
 #if !defined(_TRACE_BLOCK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_BLOCK_H
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0CWAcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab0CWAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:13 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org
Subject: [PATCH 03/18] mm: Generate kmemtrace trace points only if they are enabled
Date: Tue, 23 Mar 2010 01:32:05 +0100
Message-Id: <1269304340-25372-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-mm@kvack.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/kmem.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 3adca0c..1f93693 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM kmem
+#define TRACE_CONFIG CONFIG_KMEMTRACE
 
 #if !defined(_TRACE_KMEM_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_KMEM_H
-- 
1.6.4.2


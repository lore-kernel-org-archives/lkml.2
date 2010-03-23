Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0CWAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:33:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:45260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab0CWAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:15 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, x86@kernel.org, sparclinux@vger.kernel.org,
       linux-s390@vger.kernel.org, Alexander Schulz <alex@shark-linux.de>
Subject: [PATCH 16/18] Generate empty tracepoints if syscall tracing is disabled
Date: Tue, 23 Mar 2010 01:32:18 +0100
Message-Id: <1269304340-25372-17-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: x86@kernel.org
CC: sparclinux@vger.kernel.org
CC: linux-s390@vger.kernel.org
CC: Alexander Schulz <alex@shark-linux.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/syscalls.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index fb726ac..6f0ad30 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -1,6 +1,8 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM raw_syscalls
 #define TRACE_INCLUDE_FILE syscalls
+#define TRACE_CONFIG CONFIG_FTRACE_SYSCALLS
 
 #if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_EVENTS_SYSCALLS_H
-- 
1.6.4.2


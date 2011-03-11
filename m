Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CKJqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:46:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:45975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab1CKJqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:46:36 -0500
Date: Fri, 11 Mar 2011 09:46:16 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1291421609-14665-3-git-send-email-dhsharp@google.com>
References: <1291421609-14665-3-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer: Remove unused #include <linux/trace_irq.h>
Message-ID: <tip-de29be5e712dc8b7eef2bef9417af3bb6a88e47a@git.kernel.org>
Git-Commit-ID: de29be5e712dc8b7eef2bef9417af3bb6a88e47a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:46:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de29be5e712dc8b7eef2bef9417af3bb6a88e47a
Gitweb:     http://git.kernel.org/tip/de29be5e712dc8b7eef2bef9417af3bb6a88e47a
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:16 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Mar 2011 13:52:28 -0500

ring-buffer: Remove unused #include <linux/trace_irq.h>

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-3-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 269db80..3237d96 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5,7 +5,6 @@
  */
 #include <linux/ring_buffer.h>
 #include <linux/trace_clock.h>
-#include <linux/ftrace_irq.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>

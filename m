Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0LDAOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:14:02 -0500
Received: from smtp-out.google.com ([74.125.121.35]:17053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0LDAOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:14:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=cCBgO7E6V8jsvNXruds6AcEzWBIpKECGLtiS3TGxYp2RBrgxIdO0ncJ7MRpKmBkYt
	WClQsn9g1sK+SUIASRvVg==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 02/15] ring_buffer.c: Remove unused #include <linux/trace_irq.h>
Date: Fri,  3 Dec 2010 16:13:16 -0800
Message-Id: <1291421609-14665-3-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/ring_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3207147..8ef7cc4 100644
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
-- 
1.7.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1CXE7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:59:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:37418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1CXE7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:59:13 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Documentation/atomic_ops.txt: avoid volatile in sample code
Date: Thu, 24 Mar 2011 10:25:59 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241025.59776.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As declaring counter as volatile is discouraged, it is best not to use it in
sample code as well.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index ac4d471..3bd585b 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -12,7 +12,7 @@ Also, it should be made opaque such that any kind of cast to a normal
 C integer type will fail.  Something like the following should
 suffice:
 
-	typedef struct { volatile int counter; } atomic_t;
+	typedef struct { int counter; } atomic_t;
 
 Historically, counter has been declared volatile.  This is now discouraged.
 See Documentation/volatile-considered-harmful.txt for the complete rationale.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1DYAgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:36:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37415 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab1DYAfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JvWeCTDr5GR/SHHeF4f4DFzu6BPCzx8ibYGo9qFPj56AU+blYG53jPQFabH+FIzfpC
         DHBHyRuIFOn8LqxLYCC/GqVULh+IQsHTDiFru68KstYKPBEwgZeA+EIM8IcB96QbEF87
         5jI+ktn3/JxhTRd04RkofDDY5z/o5JxJ3na8c=
From: Aaron Faanes <dafrito@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Faanes <dafrito@gmail.com>
Subject: [PATCH 2/3] Documentation: Correct a couple missing words in inotify.txt
Date: Sun, 24 Apr 2011 19:35:03 -0500
Message-Id: <1303691704-5726-3-git-send-email-dafrito@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
References: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aaron Faanes <dafrito@gmail.com>
---
 Documentation/filesystems/inotify.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/inotify.txt b/Documentation/filesystems/inotify.txt
index f00c435..8d8cba1 100644
--- a/Documentation/filesystems/inotify.txt
+++ b/Documentation/filesystems/inotify.txt
@@ -248,9 +248,9 @@ A: An fd-per-watch quickly consumes more file descriptors than are allowed,
 
    When you talk about designing a file change notification system that
    scales to 1000s of directories, juggling 1000s of fd's just does not seem
-   the right interface.  It is too heavy.
+   to be the right interface.  It is too heavy.
 
-   Additionally, it _is_ possible to more than one instance and
+   Additionally, it _is_ possible to have more than one instance and
    juggle more than one queue and thus more than one associated fd.  There
    need not be a one-fd-per-process mapping; it is one-fd-per-queue and a
    process can easily want more than one queue.
-- 
1.7.4.4


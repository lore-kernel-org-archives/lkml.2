Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab1DYAf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:35:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43569 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab1DYAfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kP1vw9x/xld86s2qzXj2PA3uxNVESTrtNfYt8VUdNKLeA+A1uvgpADPSzeJrrsuMZ4
         wI2DT7FJmsJ8++sQMlMCCiHAYfqB5ZdluuO9zKHbd1XNp3lqf1ekKBYziSW4qlQSg8BE
         HrAO7yAyRhDyr0J/rgjgfyLzRJiqQKTelJPa4=
From: Aaron Faanes <dafrito@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Faanes <dafrito@gmail.com>
Subject: [PATCH 1/3] Documentation: remove some spurious spaces in inotify.txt
Date: Sun, 24 Apr 2011 19:35:02 -0500
Message-Id: <1303691704-5726-2-git-send-email-dafrito@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
References: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aaron Faanes <dafrito@gmail.com>
---
 Documentation/filesystems/inotify.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/inotify.txt b/Documentation/filesystems/inotify.txt
index 59a919f..f00c435 100644
--- a/Documentation/filesystems/inotify.txt
+++ b/Documentation/filesystems/inotify.txt
@@ -250,7 +250,7 @@ A: An fd-per-watch quickly consumes more file descriptors than are allowed,
    scales to 1000s of directories, juggling 1000s of fd's just does not seem
    the right interface.  It is too heavy.
 
-   Additionally, it _is_ possible to  more than one instance  and
+   Additionally, it _is_ possible to more than one instance and
    juggle more than one queue and thus more than one associated fd.  There
    need not be a one-fd-per-process mapping; it is one-fd-per-queue and a
    process can easily want more than one queue.
-- 
1.7.4.4


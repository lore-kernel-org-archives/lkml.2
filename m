Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab1DYAgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:36:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63843 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab1DYAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Xf6koqXIiKXVR1DFNrFTm4mpyuBOYhn46uGeuJLizPaaWq1UQpohcjb239JT8DPh4t
         qRm+00l/oeEViEPwqnptcwZCq4uJZSBG+vg2eqYNmtXRYrwuO2n+AkiRDfN3huI1bNUF
         tLx0KPNLDD3x9vHrfDk14QYKt/CUhxDS3cVZU=
From: Aaron Faanes <dafrito@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Faanes <dafrito@gmail.com>
Subject: [PATCH 3/3] Documentation: Reword example about inotify's fd-per-instance design
Date: Sun, 24 Apr 2011 19:35:04 -0500
Message-Id: <1303691704-5726-4-git-send-email-dafrito@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
References: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Made the final example read more clearly by splitting it into a
couple more sentences.

Signed-off-by: Aaron Faanes <dafrito@gmail.com>
---
 Documentation/filesystems/inotify.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/inotify.txt b/Documentation/filesystems/inotify.txt
index 8d8cba1..fbb50ad 100644
--- a/Documentation/filesystems/inotify.txt
+++ b/Documentation/filesystems/inotify.txt
@@ -246,9 +246,9 @@ A: An fd-per-watch quickly consumes more file descriptors than are allowed,
 
    - 1024 is still too low.  ;-)
 
-   When you talk about designing a file change notification system that
-   scales to 1000s of directories, juggling 1000s of fd's just does not seem
-   to be the right interface.  It is too heavy.
+   For example, consider the design of a file change notification system that
+   scales to 1000s of directories.  Juggling 1000s of fd's in this case is just
+   not the right interface.  It is too heavy.
 
    Additionally, it _is_ possible to have more than one instance and
    juggle more than one queue and thus more than one associated fd.  There
-- 
1.7.4.4


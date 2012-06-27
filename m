Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2F0JeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:34:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38304 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2F0JeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:34:11 -0400
From: Chad Williamson <chad@dahc.us>
To: wad@chromium.org
Cc: james.l.morris@oracle.com, keescook@chromium.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH] samples: seccomp: add .gitignore for untracked executables
Date: Wed, 27 Jun 2012 04:33:40 -0500
Message-Id: <1340789620-15762-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git status should be clean following make allmodconfig && make. Add
a .gitignore file to the samples/seccomp directory to ignore binaries
produced there.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 samples/seccomp/.gitignore |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 samples/seccomp/.gitignore

diff --git a/samples/seccomp/.gitignore b/samples/seccomp/.gitignore
new file mode 100644
index 0000000..78fb781
--- /dev/null
+++ b/samples/seccomp/.gitignore
@@ -0,0 +1,3 @@
+bpf-direct
+bpf-fancy
+dropper
-- 
1.7.7


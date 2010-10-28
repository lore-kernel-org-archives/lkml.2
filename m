Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab0J1Vbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818Ab0J1Vbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:31:47 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 01/20] fanotify: allow fanotify to be built
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:31:39 -0400
Message-ID: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We disabled the ability to build fanotify in commit 7c5347733dcc4ba0ba.
This reverts that commit and allows people to build fanotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Kconfig    |    2 +-
 include/linux/Kbuild |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
index b388443..22c629e 100644
--- a/fs/notify/Kconfig
+++ b/fs/notify/Kconfig
@@ -3,4 +3,4 @@ config FSNOTIFY
 
 source "fs/notify/dnotify/Kconfig"
 source "fs/notify/inotify/Kconfig"
-#source "fs/notify/fanotify/Kconfig"
+source "fs/notify/fanotify/Kconfig"
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 831c463..c7fbf29 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -118,6 +118,7 @@ header-y += eventpoll.h
 header-y += ext2_fs.h
 header-y += fadvise.h
 header-y += falloc.h
+header-y += fanotify.h
 header-y += fb.h
 header-y += fcntl.h
 header-y += fd.h


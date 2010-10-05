Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab0JEKXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:23:32 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44728 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab0JEKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:23:29 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V21 09/12] unistd.h: Add new syscalls numbers to asm-generic
Date: Tue,  5 Oct 2010 15:52:17 +0530
Message-Id: <1286274140-26533-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286274140-26533-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1286274140-26533-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/asm-generic/unistd.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index b969770..9469305 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -646,9 +646,19 @@ __SYSCALL(__NR_prlimit64, sys_prlimit64)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_name_to_handle_at		264
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at		265
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_readlink_by_handle		266
+__SYSCALL(__NR_readlink_by_handle, sys_handle_readlink)
+#define __NR_stat64_by_handle		267
+__SYSCALL(__NR_stat64_by_handle, sys_handle_stat64)
+#define __NR_link_by_handle		268
+__SYSCALL(__NR_link_by_handle, sys_handle_link)
 
 #undef __NR_syscalls
-#define __NR_syscalls 264
+#define __NR_syscalls 269
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.0.4


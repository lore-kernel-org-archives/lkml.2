Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab0HTBwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:52:31 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50659 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0HTBw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:52:28 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V18 10/13] unistd.h: Add new syscalls numbers to asm-generic
Date: Fri, 20 Aug 2010 07:21:34 +0530
Message-Id: <1282269097-26166-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/asm-generic/unistd.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index b969770..8e7bd87 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -646,9 +646,13 @@ __SYSCALL(__NR_prlimit64, sys_prlimit64)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_name_to_handle_at	264
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at	265
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 
 #undef __NR_syscalls
-#define __NR_syscalls 264
+#define __NR_syscalls 266
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.0.4


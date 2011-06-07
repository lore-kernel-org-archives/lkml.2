Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1FGKkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:40:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44697 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1FGKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gmeXmx56GrcYKBO8E7sOEFJbubM3n5dclTG4Anwks5byC1CLYucpTURjRoTtuptkTu
         KVddS+OBEVpTj8T0xhs43eGiQ0es7OFFI1623RC7cFwwNzqjTRAO05Ff46Nn853zEPqH
         nyXWgZ5QEiIscTPn5os3hkHp6Dn77SLCzsJPg=
From: Akshay Joshi <me@akshayjoshi.com>
Cc: Akshay Joshi <me@akshayjoshi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Kernel: convert leading spaces to tabs in uid16.c.
Date: Tue,  7 Jun 2011 06:39:37 -0400
Message-Id: <1307443181-22278-4-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
References: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the leading indentations for long function declarations to use
tabs.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 kernel/uid16.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/uid16.c b/kernel/uid16.c
index 51c6e89..8c3fbfc 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -132,7 +132,7 @@ SYSCALL_DEFINE1(setfsgid16, old_gid_t, gid)
 }
 
 static int groups16_to_user(old_gid_t __user *grouplist,
-    struct group_info *group_info)
+	struct group_info *group_info)
 {
 	int i;
 	old_gid_t group;
@@ -147,7 +147,7 @@ static int groups16_to_user(old_gid_t __user *grouplist,
 }
 
 static int groups16_from_user(struct group_info *group_info,
-    old_gid_t __user *grouplist)
+	old_gid_t __user *grouplist)
 {
 	int i;
 	old_gid_t group;
-- 
1.7.4.4


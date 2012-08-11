Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2HKUcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:32:31 -0400
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:49265 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285Ab2HKUc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:32:29 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 16:32:27 EDT
From: Masatake YAMATO <yamato@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 08/15] unix: declaring unix protocols has its own proc entry
Date: Sun, 12 Aug 2012 05:07:11 +0900
Message-Id: <1344715638-22997-8-git-send-email-yamato@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring unix protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/unix/af_unix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e4768c1..7f109e6 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -616,6 +616,7 @@ static struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
+	.has_own_proc_entry= 1,
 };
 
 /*
-- 
1.7.11.2


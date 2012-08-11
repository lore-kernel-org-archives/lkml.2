Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2HKUc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:32:29 -0400
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:49265 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044Ab2HKUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:32:27 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 16:32:27 EDT
From: Masatake YAMATO <yamato@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 05/15] ipv4: declaring raw protocols has its own proc entry
Date: Sun, 12 Aug 2012 05:07:08 +0900
Message-Id: <1344715638-22997-5-git-send-email-yamato@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring raw protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/raw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ff0f071..3980a4a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -901,6 +901,7 @@ struct proto raw_prot = {
 	.compat_getsockopt = compat_raw_getsockopt,
 	.compat_ioctl	   = compat_raw_ioctl,
 #endif
+	.has_own_proc_entry= 1,
 };
 
 #ifdef CONFIG_PROC_FS
-- 
1.7.11.2


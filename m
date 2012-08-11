Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2HKUc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:32:57 -0400
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:49265 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754995Ab2HKUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:32:38 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 16:32:27 EDT
From: Masatake YAMATO <yamato@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 04/15] ipv4: declaring udplite protocols has its own proc entry
Date: Sun, 12 Aug 2012 05:07:07 +0900
Message-Id: <1344715638-22997-4-git-send-email-yamato@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring udplite protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/udplite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 2c46acd..14c9dec 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -62,6 +62,7 @@ struct proto 	udplite_prot = {
 	.compat_getsockopt = compat_udp_getsockopt,
 #endif
 	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+	.has_own_proc_entry= 1,
 };
 EXPORT_SYMBOL(udplite_prot);
 
-- 
1.7.11.2


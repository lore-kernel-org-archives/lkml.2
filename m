Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2HJOHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab2HJOHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:07:12 -0400
Date: Fri, 10 Aug 2012 23:07:11 +0900 (JST)
Message-Id: <20120810.230711.1019359459442877128.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] Declaring raw protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring raw protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ff0f071..b40224d 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -901,6 +901,9 @@ struct proto raw_prot = {
 	.compat_getsockopt = compat_raw_getsockopt,
 	.compat_ioctl	   = compat_raw_ioctl,
 #endif
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 #ifdef CONFIG_PROC_FS
-- 
1.7.11.2


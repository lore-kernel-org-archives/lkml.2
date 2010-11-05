Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0KEVFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:05:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39457 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0KEVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:05:52 -0400
Date: Fri, 5 Nov 2010 17:05:46 -0400 (EDT)
From: Anders Kaseorg <andersk@ksplice.com>
X-X-Sender: andersk@dr-wily.mit.edu
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH] module: Update prototype for ref_module (formerly
 use_module)
Message-ID: <alpine.DEB.2.00.1011051702090.3947@dr-wily.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9bea7f23952d5948f8e5dfdff4de09bb9981fb5f renamed use_module to
ref_module (and changed its return value), but forgot to update this
prototype in module.h.

Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
---
 include/linux/module.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index aace066..caf6105 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -514,7 +514,7 @@ static inline void __module_get(struct module *module)
 #define symbol_put_addr(p) do { } while(0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
-int use_module(struct module *a, struct module *b);
+int ref_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
-- 
1.7.3.1


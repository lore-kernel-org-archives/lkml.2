Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab0ELVPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:15:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34409 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0ELVP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=XZD154/+ycWZGcxFKwgMejBIG+wKu9ZZgb76Fn250hqzWUXvOEdjjXG3VpAX85nv2o
         29kKUsKiH4DSB6XmVk2a9ikf9gpdEXSvy2IrtzOGwyMyBbg4jV59Xpb8KxhIRNexIsnB
         21rIlSud/m4BaWTJHLtPZxudfJYB+5qzUiTIA=
Date: Thu, 13 May 2010 01:17:24 +0400
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
To: joern@logfs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lib/btree: Kill unused MAX macro
Message-ID: <20100512211724.GA5507@coldcone>
Reply-To: kirjanov@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill unused MAX macro

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
diff --git a/lib/btree.c b/lib/btree.c
index 41859a8..f833949 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -45,7 +45,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {

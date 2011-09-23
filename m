Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1IWW4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:56:39 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:2161 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1IWW4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:56:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1316818597!28835354!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] jffs2/security.c: local functions should be static
Date: Fri, 23 Sep 2011 15:56:15 -0700
User-Agent: KMail/1.9.9
CC: linux-mtd <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231556.15973.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiets the sparse noise:

warning: symbol 'jffs2_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/fs/jffs2/security.c b/fs/jffs2/security.c
index 0f20208..aca97f3 100644
--- a/fs/jffs2/security.c
+++ b/fs/jffs2/security.c
@@ -23,8 +23,8 @@
 #include "nodelist.h"
 
 /* ---- Initial Security Label(s) Attachment callback --- */
-int jffs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		     void *fs_info)
+static int jffs2_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array, void *fs_info)
 {
 	const struct xattr *xattr;
 	int err = 0;

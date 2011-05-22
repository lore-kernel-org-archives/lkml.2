Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1EVTgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:36:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36895 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1EVTgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lvquSDHwQUPb7Eun5MrFBQ4cPh8xKJRAbmwIMGLkSG9CzLvCPhoUTzua7GwCok8Src
         pvRn1Ot2zSAv3Q+YjemKk7JQ171j8MgovVBc/LWZpl/xx0N0RjrSKEKtW8Juu9HtQBRQ
         zeKEpli2YiAIvEtvTZo6HPOoouA1EQ90Hm8Vk=
Subject: [PATCH] fs: add missing prefetch header to inode.c
From: Eduardo Silva <edsiper@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 15:34:39 -0400
Message-ID: <1306092879.16902.1.camel@monotop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode.c fails in the compilation process due to the missing
include of linux/prefetch.h.

Signed-off-by: Eduardo Silva <edsiper@gmail.com>
---
 fs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 33c963d..c77081f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,7 @@
 #include <linux/posix_acl.h>
 #include <linux/ima.h>
 #include <linux/cred.h>
+#include <linux/prefetch.h>
 #include "internal.h"
 
 /*
-- 
1.7.4.1




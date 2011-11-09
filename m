Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab1KJD0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934728Ab1KJD0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:10 2011
Message-Id: <20111109212710.298566344@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [097/262] hppfs: missing include
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit d6b722aa383a467a43d09ee38e866981abba08ab upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hppfs/hppfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -16,6 +16,7 @@
 #include <linux/statfs.h>
 #include <linux/types.h>
 #include <linux/pid_namespace.h>
+#include <linux/namei.h>
 #include <asm/uaccess.h>
 #include "os.h"
 



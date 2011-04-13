Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1DMB6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:58:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735Ab1DMB6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:58:45 -0400
Message-ID: <4DA5034F.50203@suse.com>
Date: Tue, 12 Apr 2011 21:58:39 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fhandle: Add <linux/personality.h> for ia64
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 force_o_largefile() on ia64 is defined in <asm/fcntl.h> and
 requires <linux/personality.h>. This patch adds it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/fhandle.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -7,6 +7,7 @@
 #include <linux/exportfs.h>
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
+#include <linux/personality.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
-- 
Jeff Mahoney
SuSE Labs

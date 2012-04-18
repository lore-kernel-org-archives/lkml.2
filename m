Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2DRADB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:03:01 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:50219 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752120Ab2DRAC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:02:59 -0400
Message-ID: <4F8E04D8.5040403@xenotime.net>
Date: Tue, 17 Apr 2012 17:03:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kmod.c: fix kernel-doc warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning in kmod.c:

Warning(kernel/kmod.c:419): No description found for parameter 'depth'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-34-rc3.orig/kernel/kmod.c
+++ lnx-34-rc3/kernel/kmod.c
@@ -410,7 +410,7 @@ EXPORT_SYMBOL_GPL(usermodehelper_read_un
 
 /**
  * __usermodehelper_set_disable_depth - Modify usermodehelper_disabled.
- * depth: New value to assign to usermodehelper_disabled.
+ * @depth: New value to assign to usermodehelper_disabled.
  *
  * Change the value of usermodehelper_disabled (under umhelper_sem locked for
  * writing) and wakeup tasks waiting for it to change.

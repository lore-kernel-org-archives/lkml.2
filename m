Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2FKXrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:47:11 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:51178 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752841Ab2FKXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:47:09 -0400
Message-ID: <4FD6836F.1020406@xenotime.net>
Date: Mon, 11 Jun 2012 16:46:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, osd-dev@open-osd.org
CC: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] exofs: fix sparse non-ANSI function warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix sparse non-ANSI function warning:

fs/exofs/sys.c:112:28: warning: non-ANSI function declaration of function 'exofs_sysfs_dbg_print'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 fs/exofs/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-35-rc2.orig/fs/exofs/sys.c
+++ lnx-35-rc2/fs/exofs/sys.c
@@ -109,7 +109,7 @@ static struct kobj_type odev_ktype = {
 static struct kobj_type uuid_ktype = {
 };
 
-void exofs_sysfs_dbg_print()
+void exofs_sysfs_dbg_print(void)
 {
 #ifdef CONFIG_EXOFS_DEBUG
 	struct kobject *k_name, *k_tmp;

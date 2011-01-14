Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab1ANImE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:42:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1ANIlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:41:55 -0500
Message-ID: <4D300BA8.80000@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 16:39:04 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre
MIME-Version: 1.0
To: bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: [PATCH] nfsd: kill unused ENT_HASHMASK definition
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 16:41:15,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 16:41:21,
	Serialize complete at 2011-01-14 16:41:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro definition has not been using since v2.6.12-rc2.
So, remove it now.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 fs/nfsd/nfs4idmap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index f0695e8..ce0f6b9 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -62,7 +62,6 @@ struct ent {
 
 #define ENT_HASHBITS          8
 #define ENT_HASHMAX           (1 << ENT_HASHBITS)
-#define ENT_HASHMASK          (ENT_HASHMAX - 1)
 
 static void
 ent_init(struct cache_head *cnew, struct cache_head *citm)
-- 
1.6.3.3

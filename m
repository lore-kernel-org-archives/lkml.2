Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1J0B1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 21:27:04 -0400
Received: from natasha.panasas.com ([67.152.220.90]:41112 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1J0B1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 21:27:03 -0400
Message-ID: <4EA8B359.9040007@panasas.com>
Date: Wed, 26 Oct 2011 18:26:49 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>, NFS list <linux-nfs@vger.kernel.org>
Subject: [PATCH] fs/Makefile: Stupid TYPO breakage of exofs inclusion
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In my last patch I did a stupid mistake and broke the exofs
compilation completely. Fix it ASAP.

Instead of obj-y I did obj-$(y)

Really Really sorry. Me totally blushing :-{|

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index 5c30a13..d2c3353 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -120,6 +120,6 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
-obj-$(y)          		+= exofs/ # Multiple mods, used by nfs/objlayout
+obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
-- 
1.7.6.4


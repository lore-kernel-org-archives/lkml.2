Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0DPGjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:39:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65336 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab0DPGjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:39:07 -0400
Message-ID: <4BC805C9.8020802@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 14:38:01 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] io-controller: including "linux/sched.h"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include sched.h explicitly since sched_clock() is called.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 83930f6..ed6590e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include "blk-cgroup.h"
 #include <linux/genhd.h>
+#include <linux/sched.h>
 
 #define MAX_KEY_LEN 100
 
-- 
1.5.4.rc3


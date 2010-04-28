Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0D1NzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:55:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64002 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0D1NzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=k8e2S5c6sf9uqNahC6SIVW95/9LrD3Lh3YW95Nt0yryecmg8ltn5OT4srgJXfB4P9D
         jAT9sxR8nAJGNd+K971L9BpUjgejCnUd31lJfGaq70lcK8eRT6tp82fOLOZyNno5pkBh
         NhQ9lFaHHiwGrMfIu6XQBNeVW9Rc9GQa17iA0=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v3
Date: Wed, 28 Apr 2010 17:55:05 +0400
Message-Id: <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100426172651.GT27497@kernel.dk>
References: <20100426172651.GT27497@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Convert all blkdev_issue_xxx function to common set of flags
- move common helper functions to block/blk-lib.c
- Add generic zeroout helper

Tested configuration: ext4 w -odiscard over raw_bdisk and dm-linear
changes from V2
Fix flag names, and rearange patches according to Christoph's comments.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index fa1db90..285a0fa 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 34
-EXTRAVERSION = -rc5
+EXTRAVERSION = -rc5-
 NAME = Sheep on Meth
 
 # *DOCUMENTATION*
-- 
1.6.6.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2JVPo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:44:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51407 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2JVPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:44:24 -0400
Date: Mon, 22 Oct 2012 08:44:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.48
Message-ID: <20121022154420.GB21144@kroah.com>
References: <20121022154408.GA21144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022154408.GA21144@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 82f6dfe..8dc65e0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 0
-SUBLEVEL = 47
+SUBLEVEL = 48
 EXTRAVERSION =
 NAME = Sneaky Weasel
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 2f49f43..35ae52d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -524,7 +524,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
-	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
+	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 
 	/* Override internal queue lock with supplied lock pointer */
 	if (lock)

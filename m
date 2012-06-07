Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab2FGGQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 02:16:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33440 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759931Ab2FGGQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 02:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8uedHZ81JpY2jb0j9FLE3Uxibc=mSDFp496ChQLzkQqQdMw@mail.gmail.com>
References: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
	<CAOS58YOf0m5WUcn3b2f_PGr=P+DH1-0EHBy_fHw3xmccHW+zRA@mail.gmail.com>
	<CAFR8uedYpEX+9RiK11G-KvcEU7mYrt58OAFWs4mgoUpLQMowTQ@mail.gmail.com>
	<CAOS58YPAOYcHYkXu7hW-DeGRXkFqoF1cLarJFfh0eNfFaVHyBg@mail.gmail.com>
	<CAFR8uedHZ81JpY2jb0j9FLE3Uxibc=mSDFp496ChQLzkQqQdMw@mail.gmail.com>
Date: Thu, 7 Jun 2012 15:16:20 +0900
X-Google-Sender-Auth: 5QoOw4mWg_WEEH5XD9GUiH14lp4
Message-ID: <CAOS58YNgatwyCApNg=sSNAzOSPR-QSqQwnYy562QcaUTcz8aOg@mail.gmail.com>
Subject: Re: [PATCH] blk-exec-assign-endio-before-queue-dead-check
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Jun 7, 2012 at 3:13 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
> done() routine is not made. That will result in blk_execute_rq() stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to
> done() routine before we check for dead queue.

Sorry to be nit-picky but Jens would appreciate proper subject and it
would also be nice to mention the locking change (or even separate
that into a separate patch).

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab1BKPNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:13:24 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:40569 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab1BKPNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:13:23 -0500
X-ASG-Debug-ID: 1297437202-03d6a50f0954be0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D55525C.3080705@fusionio.com>
Date: Fri, 11 Feb 2011 16:14:36 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: revert: loop: queue_lock NULL pointer derefence in blk_throtl_exit
  V1
References: <20110211125941.GA4271@swordfish.minsk.epam.com>
X-ASG-Orig-Subj: Re: revert: loop: queue_lock NULL pointer derefence in blk_throtl_exit
  V1
In-Reply-To: <20110211125941.GA4271@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1297437202
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.55031
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-11 13:59, Sergey Senozhatsky wrote:
> Hello Jens, Andrew
> 
> We have accidentally commit "loop: queue_lock NULL pointer 
> derefence in blk_throtl_exit V1" applied: ee71a968672a9951aee6014c55511007596425bc
> 
> It's not a huge problem, but I think, it's better to have V3 applied 
> https://lkml.org/lkml/2011/1/21/158
> 
> since V3 targets all the throttle users, not only loop (by moving 
> `fall-back' from loop_free to blk_release_queue).
> 
> V3 is in Andrew's mmotm as for now 
> loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3.patch
> 
> Could we please revert ee71a968672a9951aee6014c55511007596425bc when 
> loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3 will land 
> in the kernel?

Send an incremental patch if there's overlap, otherwise we'll do the
revert. I'm on my way out the door and I'll be away from the computer
all of next week, so perhaps Andrew can assist you in upstreaming such a
patch?

-- 
Jens Axboe


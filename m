Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1EPNVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:21:08 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33470 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1EPNVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:21:07 -0400
X-ASG-Debug-ID: 1305552065-01de28096b3bd40001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD124BE.6050104@fusionio.com>
Date: Mon, 16 May 2011 15:21:02 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Li Zefan <lizf@cn.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-throttle: Use task_subsys_state() to determine a
  task's blkio_cgroup
References: <20110509134915.GC5975@redhat.com> <20110516131608.GA8237@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] blk-throttle: Use task_subsys_state() to determine a
  task's blkio_cgroup
In-Reply-To: <20110516131608.GA8237@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305552065
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.63904
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-16 15:16, Vivek Goyal wrote:
> On Mon, May 09, 2011 at 09:49:15AM -0400, Vivek Goyal wrote:
>> Currentlly we first map the task to cgroup and then cgroup to
>> blkio_cgroup. There is a more direct way to get to blkio_cgroup
>> from task using task_subsys_state(). Use that.
>>
> 
> Hi Jens,
> 
> Can you please apply this patch. I was hoping to get this fixed in 2.6.39.
> If it is too late, then we can queue it up for 2.6.40.

Yep will do, I have a few things for .39 and still one pending item for
.39 as well that isn't completely resolved yet.

-- 
Jens Axboe


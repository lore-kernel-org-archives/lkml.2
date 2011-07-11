Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1GKL15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:27:57 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:60359 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1GKL15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:27:57 -0400
X-ASG-Debug-ID: 1310383675-03d6a510a8142d50001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1ADE39.6090609@fusionio.com>
Date: Mon, 11 Jul 2011 13:27:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/3]CFQ: add think time check for service tree and group
References: <1309757789.15392.236.camel@sli10-conroe> <CANejiEXryM=hawNjQZPYEM2L97+gUYqHQ_YQJ5p5gLTvBkC25Q@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 0/3]CFQ: add think time check for service tree and group
In-Reply-To: <CANejiEXryM=hawNjQZPYEM2L97+gUYqHQ_YQJ5p5gLTvBkC25Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310383675
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68605
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-11 07:44, Shaohua Li wrote:
> 2011/7/4 Shaohua Li <shaohua.li@intel.com>:
>> Hi,
>>  Currently when the last queue of a service tree/group is empty, CFQ
>> doesn't expire the queue. This is to allow requests from the tree/group
>> come soon, so tree/group doesn't miss its share. But if the think time
>> is big, the assumption isn't correct. idling the queue is just wasting
>> bandwidth.
>>
>> Originally I was hoping this can resolve Vivek's fsync issue, but it
>> doesn't. The fsync issue is caused by queue idling. But since think time
>> check only helps for think time above default queue idle time (8ms),
>> think time check doesn't help.
>>
>> On the other hand, think time check is still helpful for queues with
>> think time. I had test case in follow patches show throughput
>> improvement without sacrifice tree/group shares.
>>
> Jens,
> can you look at the patches? I refreshed some patches in replying
> Vivek, I can resend if required.

Please resend the series after a refresh like that, otherwise I tend to
lose track of the various things flying around.

-- 
Jens Axboe


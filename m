Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2E3TSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:18:33 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:36611 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2E3TSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:18:31 -0400
X-ASG-Debug-ID: 1338405511-0421b516ea361e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC67253.1080700@fusionio.com>
Date: Wed, 30 May 2012 21:17:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Block driver bits for 3.5
References: <4FC6189B.9080909@fusionio.com>  <1338402812.2760.413.camel@edumazet-glaptop>  <4FC66D3D.6080509@fusionio.com> <1338404902.2760.451.camel@edumazet-glaptop>
X-ASG-Orig-Subj: Re: [GIT PULL] Block driver bits for 3.5
In-Reply-To: <1338404902.2760.451.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338405511
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98464
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 09:08 PM, Eric Dumazet wrote:
> On Wed, 2012-05-30 at 20:55 +0200, Jens Axboe wrote:
>> On 05/30/2012 08:33 PM, Eric Dumazet wrote:
>>> On Wed, 2012-05-30 at 14:54 +0200, Jens Axboe wrote:
>>>> Hi Linus,
>>>>
>>>> On top of the for-3.5/core pull request, here are the driver related
>>>> changes for 3.5. It contains:
>>>
>>> Hi Jens
>>>
>>> Not sure if this is related, but latest Linus tree cannot boot anymore
>>> here...
>>>
>>> BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
>>
>> Hrmpf, can you attach your .config?
>>
> 
> I can do a bisection pretty fast I think

Thanks, that'd help a lot.

-- 
Jens Axboe


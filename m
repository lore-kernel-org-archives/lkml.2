Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1CYQBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:01:25 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:34994 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1CYQBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:01:24 -0400
X-ASG-Debug-ID: 1301068874-01de284cf8bcac0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8CBC45.7020002@fusionio.com>
Date: Fri, 25 Mar 2011 17:01:09 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de> <4D8C8E1C.1020304@fusionio.com> <20110325130959.GA1698@gentoo.trippels.de> <4D8CA263.9090006@fusionio.com> <20110325141413.GA1725@gentoo.trippels.de> <4D8CA498.8060403@fusionio.com> <20110325142827.GA1739@gentoo.trippels.de> <4D8CBA0A.9040105@fusionio.com> <20110325155821.GA1661@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325155821.GA1661@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301068874
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58940
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 16:58, Markus Trippelsdorf wrote:
> On 2011.03.25 at 16:51 +0100, Jens Axboe wrote:
>> On 2011-03-25 15:28, Markus Trippelsdorf wrote:
>>> On 2011.03.25 at 15:20 +0100, Jens Axboe wrote:
>>>> On 2011-03-25 15:14, Markus Trippelsdorf wrote:
>>>>> On 2011.03.25 at 15:10 +0100, Jens Axboe wrote:
>>>>>> On 2011-03-25 14:09, Markus Trippelsdorf wrote:
>>>>>>> On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
>>>>>>>> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
>>>>>>>>>
>>>>>>>>> Reverting it solves all problems here.
>>>>>>>>
>>>>>>>> Can you try this one?
>>>>>>>
>>>>>>> This one doesn't help; I still get the same BUG.
>>>>>>>
>>>>>>> BTW if you're having trouble reproducing this, here is the only non
>>>>>>> stock xfs option that I use on the affected partitions:
>>>>>>>
>>>>>>> noatime,logbsize=262144
>>>>>>
>>>>>> This?
>>>>>
>>>>> No.
>>>>
>>>> Lets expand the scope a bit, this one?
>>>
>>> No. And setting CONFIG_PREEMPT_NONE also doesn't help.
>>>
>>
>> Does this work? I'm actually relieved that the preempt was a red
>> herring. I had earlier convinced myself that it was all safe without
>> that mucking around with preempt counts.
> 
> Finally: YES. 
> Many thanks Jens.

Awesome. And thanks goes to you for doing tons of testing and having a
rapid turn-around time, and to Sergey for finding the right commit that
allowed a genuine fix.

I'll prepare a pull for Linus immediately.

-- 
Jens Axboe


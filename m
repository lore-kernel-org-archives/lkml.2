Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1DLOAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:00:55 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:58632 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab1DLOAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:00:53 -0400
X-ASG-Debug-ID: 1302616850-01de284cf81342b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA45B12.2090506@fusionio.com>
Date: Tue, 12 Apr 2011 16:00:50 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: regression - slow git rebase performance with 2.6.39-rcX kernel
References: <BANLkTimAY2YTFE1_uFJg=XVtV_ww2jdJrw@mail.gmail.com>	<BANLkTimAvqT0MxPWvQH6ga698TYhCXF3CQ@mail.gmail.com>	<4DA44E8B.9040101@fusionio.com> <BANLkTimJDxZ4qBRNnwE9L=3bfEU0WOhd6A@mail.gmail.com>
X-ASG-Orig-Subj: Re: regression - slow git rebase performance with 2.6.39-rcX kernel
In-Reply-To: <BANLkTimJDxZ4qBRNnwE9L=3bfEU0WOhd6A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302616850
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60643
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 15:59, Zdenek Kabelac wrote:
> 2011/4/12 Jens Axboe <jaxboe@fusionio.com>:
>> On 2011-04-12 14:51, Pekka Enberg wrote:
>>> Hi,
>>>
>>> [ Fixed your empty CC list. ]
>>>
>>> On Tue, Apr 12, 2011 at 3:45 PM, Zdenek Kabelac
>>> <zdenek.kabelac@gmail.com> wrote:
>>>> I'm noticing quite slower speed of my git rebase commands on my git
>>>> tree compared with 2.6.38 kernel.
>>>> I've  T61 with SSD disc drive, ext4 fs, and by default deadline disk
>>>> io scheduler
>>>> The counter showing the number of 'rebased' patches on top of master
>>>> is going much slower.
>>>> When I boot 2.6.38 kernel it's much faster.
>>>>
>>>> Is it a known problem - or do I need to make a bisect ?
>>>
>>> No, I don't think it's a known problem. Git bisect would be helpful,
>>> obviously.
>>
>> Definitely, interesting. Bisect would help. I'll try a similar workload
>> here and see if I see any differences. How big is your rebase, and what
>> are the runtimes (approximately) on .38 vs .39-rc?
>>
> 
> I've made just quick build with the small kernel without debug options
> enable - and the time is then equal with 2.6.38. So the difference is
> probably somewhere in debug build  -  I assume some debug option
> slowed down between 2.6.38 - 2.6.39 significantly.

Good, so it's down to debug. Thanks for testing.

-- 
Jens Axboe


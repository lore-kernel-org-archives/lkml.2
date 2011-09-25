Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab1IYPCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 11:02:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1IYPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 11:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110925094222.GA11289@liondog.tnic>
References: <CAOkaeLJTeewFWpHCVBqNwmuL7nEbFYnrQ86SQOO7fVg_Uc3Q4Q@mail.gmail.com>
	<20110925094222.GA11289@liondog.tnic>
Date: Sun, 25 Sep 2011 23:02:47 +0800
Message-ID: <CAOkaeLJHE-BVM+KOpB5hd0Jd_wyk0-XY=Qhzk+0j_U9opCbr-g@mail.gmail.com>
Subject: Re: Seems the comment of find_next_system_ram() is not exact
From: Wizard <wizarddewhite@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Wizard <wizarddewhite@gmail.com>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav

Thanks for your reply and for your suggestion to use "git annotate".
I learned a lot from you.

I see the commit by KAMEZAWA. While still not know why he change
code this way to cover the overlap case.

I find the function is introduced in 2842f11419704f8707fffc82e10d2263427fc130.
While the mm/memory_hotplug.c is chaged during this period.
If I want to view the code at that moment, I should use git checkout
2842f11419704f8707fffc82e10d2263427fc130?



2011/9/25, Borislav Petkov <bp@alien8.de>:
> On Sat, Sep 24, 2011 at 09:40:52PM +0800, Wizard wrote:
>> Hi, Experts
>>
>> I am a newbie for linux kernel. I just read the code of
>> find_next_system_ram() in kernel/resource.c
>>
>> I think the comment of this function is not exact. This says "Finds
>> the lowest memory reosurce exists within [res->start.res->end)".
>>
>> While I think the code is to find the lowest memory resource overlaps
>> [res->start, res->end).
>>
>> 308:      if ((p->end >= start) && (p->start < end))
>>
>> If I am not correct, please let me know. :)
>
> Right,
>
> hint for the future, do a "git annotate" on the file containing that
> code - the patch adding the piece of code might (err, and should!) have
> a verbose commit message explaining the situation. And it seems it does
> have something to a degree, here's another hint:
>
> 58c1b5b079071
>
> :-)
>
> But I agree that the comment over the function could use some more
> verbosity on why the function needs to handle overlapping resources and
> sections. Let's ask the author.
>
>> BTW, I find the "reosurce" is a typo.
>
> Yes, he could fix it while explaining the overlap :-).
>
> HTH.
>
> --
> Regards/Gruss,
>     Boris.
>


-- 
Wizard

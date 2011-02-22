Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1BVCGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:06:25 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:49902 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1BVCGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:06:23 -0500
Message-ID: <4D6319E0.9080907@snapgear.com>
Date: Tue, 22 Feb 2011 12:05:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
References: <4D5DB83D.80205@snapgear.com> <alpine.LFD.2.00.1102212216540.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102212216540.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2011 02:05:41.0713 (UTC) FILETIME=[01E5D410:01CBD235]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 22/02/11 07:18, Thomas Gleixner wrote:
> On Fri, 18 Feb 2011, Greg Ungerer wrote:
>> Inside of the new arch/m68k is a little messy in the kernel and mm
>> directories. There is plenty of scope for cleanup and merge on the
>> files in here - but I want to leave that for follow up patches after
>> this initial directory merge. As a data point, when we merged the
>> m68k and m68knommu include files we had something like 70 or 80
>> duplicate but separate files, after some cleanups that is now down to
>> 10. Ongoing cleanup will merge some of these remaining ones as well.
>>
>> Thoughts?
>
> Hmm, how are you going to deal with the fact, that m68knommu uses
> genirq, m68k not? I guess there are some more points like this
> (clockevents, clocksource ...)

Initially it has no impact. This first step pretty much just
combines the 2 directories, it doesn't attempt to do a fine
grained merge of each file. (It does factor out identical
files - quite a few in arch/m68k/lib for example).


> Is there a plan to move m68k to the generic facilities as well ?

I'll look at doing what I can as I work through merging all the
underlying pieces :-)

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

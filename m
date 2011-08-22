Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HVTDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:03:48 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1219 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1HVTDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:03:45 -0400
Message-ID: <4E52A808.20207@cavium.com>
Date: Mon, 22 Aug 2011 12:03:36 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>	 <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com> <1314038740.2531.8.camel@edumazet-laptop>
In-Reply-To: <1314038740.2531.8.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Aug 2011 19:03:45.0001 (UTC) FILETIME=[3724A590:01CC60FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 11:45 AM, Eric Dumazet wrote:
> Le lundi 22 août 2011 à 11:30 -0700, Linus Torvalds a écrit :
>> On Fri, Aug 19, 2011 at 4:15 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>>>
>>> Reposting due to popular demand. Several other people are running
>>> into the same problem with all kinds of software.
>>
>> I have heard this several times now, but nobody actually ever says
>> *what* is broken.
>>
>> The Fedora people seem to have done the 2.6.40 thing without any
>> actual reason, for example (the two programs they claim were broken
>> were things that they had already fixed in rawhide, afaik).
>>
>> I'm not at all interested in these kinds of "all kinds of software" reports.
>>
>> Details. Examples. Name the f&*cking names already. Shame them publicly.
>
> For example, all kind of management software from HP doesnt work, unless
> we pretend to run a 2.6 kernel.
>
> $ uname -a
> Linux svivoipvnx001 3.0.0-08107-g97cd98f #1062 SMP Fri Aug 12 18:11:45
> CEST 2011 i686 i686 i386 GNU/Linux
>
> $ hpacucli ctrl all show
>
> Error: No controllers detected.
>

Perhaps the 3.x version change patch should be reverted on the 
never-ever-break-userspace grounds. :-)  It would appear that the 2.6 
version information has become a de facto part of the kernel's ABI.

David Daney

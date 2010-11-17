Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0KQNYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:24:14 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:35242 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390Ab0KQNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:24:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=sCxzq8f4e9SgcpMKkRxr1Dv/FsVy3pBYP7J/zSwZO5ha6G/KWJ5AYqOrZqIIBN2e;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4CE3D763.9020904@earthlink.net>
Date: Wed, 17 Nov 2010 08:23:47 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
References: <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com> <alpine.DEB.2.00.1011161058180.3718@asgard.lang.hm> <20101116203306.GE27235@tango.0pointer.de> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de>
In-Reply-To: <20101116211431.GA15211@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79160a541a2d7b296c80d18cdac53540d3350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 04:14 PM, Lennart Poettering wrote:
> On Tue, 16.11.10 12:38, Linus Torvalds (torvalds@linux-foundation.org) wrote:
>
>    
>> On Tue, Nov 16, 2010 at 12:33 PM, Lennart Poettering
>> <mzxreary@0pointer.de>  wrote:
>>      
>>> No you don't. Because that is not a desktop use case.
>>>        
>> See my other response. You don't care AT ALL, because by your
>> judgement, all desktop is is a web browser and a word processor.
>>      
> Well, I do care. But I care more about *real* problems. For example the
> fact that "updatedb" makes your system sluggish while it runs. Or
> "man-db". Or anything else that runs from cron in the background.
>
> Doing this tty dance won't help you much with background tasks such as
> man-db, updatedb and cron and its jobs, will it? They don't have
> ttys. Sorry for you. meh! Meh! meh! meh! meh!
>
> (And along comes systemd, which actually handles this properly, since it
> actually has a proper notion of what a service is, and what a session
> is, and what an app is. And which hence can control all this sanely.)
>
> Binding this to a tty is just solves a tiny bit of the real problem:
> i.e. your own use of make -j. End of story.
>
> Lennart
>
>    
Oh, you mean real problems like systemd can boot 10 seconds faster. What 
is 10 seconds when your system is up days or weeks?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)




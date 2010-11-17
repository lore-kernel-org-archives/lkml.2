Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0KQNWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:22:42 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:38175 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab0KQNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:22:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=j9fIuuoG1Ul9cT42/XnKkh/HoATgiWWZmWaCMlybTCrn2o17+h+YWfvQ1i42jLlY;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4CE3D6EF.2050009@earthlink.net>
Date: Wed, 17 Nov 2010 08:21:51 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
References: <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com> <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com> <20101116203103.GD27235@tango.0pointer.de>
In-Reply-To: <20101116203103.GD27235@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec797e199746df63fbf53d25af4fc18550d3350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 03:31 PM, Lennart Poettering wrote:
> On Tue, 16.11.10 21:03, Pekka Enberg (penberg@kernel.org) wrote:
>
>    
>> On Tue, Nov 16, 2010 at 8:49 PM, Linus Torvalds
>> <torvalds@linux-foundation.org>  wrote:
>>      
>>> User-level configuration for something that should just work is
>>> annoying. We can do better.
>>>        
>> Completely agreed. Desktop users should not be required to fiddle with
>> kernel knobs from userspace to fix interactivity problems. Having sane
>> defaults applies to the kernel as much as it does to userspace.
>>      
> Jeez. Don't mentione the desktop. On the desktop this is compleltely
> irrelevant. There are not TTYs on the desktop. There's no "make -j" of
> the kernel tree on the desktop.
>
> The kernel patch discussed here *has* *no* *relevance* for normal users.
>
> The kernel patch discussed here is only relevant for people which start
> mplayer from one terminal, and "make -j" from another.
>
> Lennart
>
>    
Really, who uses Linux that is not a geek?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)




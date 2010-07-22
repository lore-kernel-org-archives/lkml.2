Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab0GVWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:23:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:54167 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab0GVWXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:23:17 -0400
Date: Thu, 22 Jul 2010 15:22:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] floppy: use single threaded workqueue
In-Reply-To: <AANLkTinffggNzVWn0sZ78wF3nwbEehoEuiVdxUP8MoE4@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007221507180.16657@asgard.lang.hm>
References: <20100609183449.110905403@vyatta.com> <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>  <20100609115403.75ebb6cb@nehalam> <alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>  <20100611103223.799d3ce0@nehalam>
 <20100721195547.GA3448@amt.cnet> <AANLkTinffggNzVWn0sZ78wF3nwbEehoEuiVdxUP8MoE4@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't use floopies much anymore, but I've got a fair number of machines 
around that have floppy drives (purchased across about 6 years with from a 
couple vendors and a variety of motherboards)

If someone can go to the effort of documenting what testing you want done 
I may be able to do it.

I would be installing new builds onto the machines to test them, so 
you can do testing that locks up the boxes without impacting anything.

the easier it is to do the tests, the more machines I can test on 
(bootable CD images that I could just pop in and then check the screen 
later would be ideal ;-)

these systems will not have network access.

David Lang


  On Thu, 22 Jul 2010, Linus 
Torvalds wrote:

> On Wed, Jul 21, 2010 at 12:55 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>
>> Can confirm this fixes the following oops seen under KVM guests.
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000035
>
> Hmm. That does make me want to merge it early, but at the same time I
> suspect it has gotten almost no testing on real hardware. So despite
> looking "obvious" and fixing one bug, I'm a bit nervous and I suspect
> that the prudent thing to do is still to take it early in the 2.3.36
> merge window, and just mark it for stable.
>
> Is anybody a big floppy user (on _real_ hardware, preferably with more
> than a couple machines) and could test it? I do feel kind of stupid
> for not taking it, but I don't have the hardware or the interest in
> really installing any in my current machines, and even if it looks
> fine and fixes some issue, I just don't feel safe enough without some
> more confirmation... As far as I know, the floppy oops thing has
> _only_ been seen on KVM (likely due to timing that just doesn't happen
> on real hardware), and while the KVM floppy emulation is probably
> fairly good, it also clearly isn't equivalent to hardware.
>
>                               Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

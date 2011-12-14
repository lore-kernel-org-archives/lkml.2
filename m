Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1LNLHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:07:53 -0500
Received: from furry1.cpalmer.me.uk ([91.84.39.42]:42175 "EHLO
	furry1.cpalmer.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1LNLHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:07:51 -0500
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 06:07:51 EST
Message-ID: <4EE87F47.7020500@pobox.com>
Date: Wed, 14 Dec 2011 10:49:43 +0000
From: Chris Palmer <chris.palmer@pobox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Edward Donovan <edward.donovan@numble.net>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] ASUS Sandybridge motherboards + PCI not working (IRQ
 n: nobody cared)
References: <CADLC3L3wZuS-1oNoOkkU5uEDhmUio3edL05Cy4EDapfG-Y202w@mail.gmail.com> <4EE72C4D.9080207@pobox.com> <CADdbW+E9=DKZ-839yPW_R4JM1omXEzqGqT=ae7Txu4Jikyw2=A@mail.gmail.com>
In-Reply-To: <CADdbW+E9=DKZ-839yPW_R4JM1omXEzqGqT=ae7Txu4Jikyw2=A@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Edward
Thanks for the reply. See below...
Regards
Chris

On 14/12/2011 00:06, Edward Donovan wrote:
> Hi Chris -
>
> I will certainly take a look.  I don't have the hardware,
> unfortunately.  And
> this is kinda my first rodeo, kernel-wise, so don't let me sound too
> expert. :)
> Let me ask a couple questions, anyway.
>
> - Later, I'll have time to look for Andrew's message, but do you know
> -- did he
>   mean a firmware ACPI bug, or a Linux bug?

He didn't say.

>
> - Does 2.6.38 behave the same as 3.1.5 or the other newest kernels? 
> (If the
>   hardware doesn't require something newer than .38.)  There was an
> IRQ overhaul
>   in 2.6.39, and the two bugs I fixed were regressions from that
> work.  As of
>   now, the bad-irq handling seems equivalent to 2.6.38, but I should
> make sure
>   that goes for your problem, too.

I was on 2.6.39.2 when I purchased the motherboard, so can't personally
vouch for anything earlier. However other posters, who were on earlier
kernels, referred to the behaviour that I am now experiencing on 3.1.5 -
i.e. that the "nobody cared" fault occurs and the device then continues
to "work" but extremely slowly (from 2.6.39.2-3.1.4 it stops working
completely).

>
> I think I'll cc LKML, too, if you don't mind.  I've seen this topic
> going by,
> but don't know what's been said.  And maybe tomorrow I can get some
> pondering
> time -
>
> Ed
>

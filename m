Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0FCQxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:53:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58135 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0FCQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:53:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43213750"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 09:53:23 -0700
Message-ID: <1275584003.23384.2.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 07:48 -0700, Linus Torvalds wrote:
> [ Continuation on the "ARM MSM updates" thread ]
> 
> On Thu, 3 Jun 2010, Russell King wrote:
> >
> > It'd be nice if you'd copy me...
> 
> Yeah, the thread started out as a "I got really bored with lots of msm 
> patches", and then just expanded into what I think is wrong with the 
> sub-architectures. 
> 
> > On the defconfig files, you may not like them - I don't like the
> > proliferation of them either.  What I've always wanted to see is
> > one defconfig per class of machines - in other words, one mach-XXX.
> 
> I can understand that, but at the same time, I do think that the 
> "defconfig" file concept as it is now is just broken. To the point of 
> being unfixable. It's obviously just a copy of the final .config, and it's 
> fundamentally not really readable (and especially not writable) by humans.
> 
> And that all actually made some sense way-back-when, back when it was 
> originally done - back when our config files were tiny (compared to what 
> they are now), and when it ended up being the default input for the 
> config. It just doesn't make much sense any more. The Kconfig files 
> themselves end up having defaults for the core things, and the non-core 
> things are too many to list/edit sanely in that format.
> 
> So the original reason I want to remove them is that they are very 
> annoying, but the reasoning that then takes that annoyance and makes me 
> think seriously about removing them despite the inevitable pain factor is 
> that I really don't think we can even use the concept for any better 
> model.
> 
> Anything better would _have_ to be totally different. And no, I don't 
> think your "diffs against a base" model work either, because while it 
> would make them smaller, it would still make them basically unreadable and 
> uneditable by any human, which means that it's not something we should 
> check in - it's a generated file!

Have you noticed this ..

http://ktrap.org/mailarchive/linux-kernel/2010/5/17/4571130

I'm not sure of the goals, but it sounds like it might be relevant.

Daniel


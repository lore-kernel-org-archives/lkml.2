Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0JNVug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:50:36 -0400
Received: from borg.medozas.de ([188.40.89.202]:58287 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab0JNVuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:50:35 -0400
Date: Thu, 14 Oct 2010 23:50:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, agruen@suse.de, davem@davemloft.net,
        andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
In-Reply-To: <20101014143723.ffea0d8c.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <20101014125458.9e51ac58.akpm@linux-foundation.org> <alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr> <20101014143723.ffea0d8c.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2010-10-14 23:37, Andrew Morton wrote:
>> >The usual approach here is someone sends it to me and I send it to
>> >Linus ;)
>> 
>> We tinkered on types.h before, with the change originating in the Netfilter
>> subtree, and nobody, not even Dave, complained.
>
>It doesn't matter much at all what tree a change goes through.  What
>matters more is that the appropriate people know about and see the
>change.
>
>For example, I never even knew that aligned_u64 and friends existed (it
>got secretly merged via the netfilter tree, apparently).

I would be interested in knowing whether you - in whichever subsystems
you happen to be active - would even need aligned_u64. Right now,
the only users seem to be PPP and scsi_tgt besides Netfilter.

>So when I review code (and I review a lot of code), I don't think to nag
>people if they open-code it. <greps>. That doesn't seem to have happened yet.

When these typedefs were introduced, I am sure that any open-coded
invocations that the new type sought to replace was adjusted.

>> (See v2.6.24-6165-gc82a5cb)
>
>hm, what does that mean.

Eh, it's a git commit identifier. When people throw around with these
(or their longer, 40-char variants), it is suggested to use `git log
-1 -p v2.6.24-6165-gc82a5cb` to see the details.
Or equivalent ways, such as visiting
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=v2.6.24-6165-gc82a5cb

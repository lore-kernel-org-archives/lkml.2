Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0JNVh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:37:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691Ab0JNVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:37:50 -0400
Date: Thu, 14 Oct 2010 14:37:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, agruen@suse.de, davem@davemloft.net,
        andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
Message-Id: <20101014143723.ffea0d8c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
	<20101014125458.9e51ac58.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 23:26:34 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Thursday 2010-10-14 21:54, Andrew Morton wrote:
> >
> >> A patch was posted a bit ago by agruen which made a change to
> >> include/linux/types.h changing aligned_u64 to __aligned_u64 and exposing
> >> this new type to userspace.
> >> [...]
> >> I'm a little stuck as to the right path forward.  I normally would have
> >> had no qualms about adding __aligned_u64 to types.h in the notification
> >> tree and pushing it to Linus next go-round and then the net tree could
> >> convert and potentially drop the old aligned_u64 type (but again that
> >> would be outside the net tree).  Since Dave isn't willing to add the
> >> type and I don't want to get called too many bad names
> >
> >The usual approach here is someone sends it to me and I send it to
> >Linus ;)
> 
> We tinkered on types.h before, with the change originating in the Netfilter
> subtree, and nobody, not even Dave, complained.

It doesn't matter much at all what tree a change goes through.  What
matters more is that the appropriate people know about and see the
change.

For example, I never even knew that aligned_u64 and friends existed (it
got secretly merged via the netfilter tree, apparently).  So when I
review code (and I review a lot of code), I don't think to nag people
if they open-code it.  <greps>.  That doesn't seem to have happened yet.

> (See v2.6.24-6165-gc82a5cb)

hm, what does that mean.

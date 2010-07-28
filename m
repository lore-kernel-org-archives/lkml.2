Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0G1GOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:14:32 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56865 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0G1GO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:14:29 -0400
Date: Tue, 27 Jul 2010 23:14:27 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34.1+hacks:  kernel deadlock related to file-IO?
Message-ID: <20100727231427.1f3eb97b@nehalam>
In-Reply-To: <4C4F767D.4020002@candelatech.com>
References: <4C4F67B3.50101@candelatech.com>
	<20100727165146.71e46170@nehalam>
	<4C4F767D.4020002@candelatech.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 17:14:53 -0700
Ben Greear <greearb@candelatech.com> wrote:

> On 07/27/2010 04:51 PM, Stephen Hemminger wrote:
> > On Tue, 27 Jul 2010 16:11:47 -0700
> > Ben Greear<greearb@candelatech.com>  wrote:
> >
> >> NOTE:  This is from a hacked 2.6.34.1 kernel, with
> >> a module of my own devising loaded and in active use.
> >
> > Ben please don't ask LKML for help with problems when
> > you have a binary only module loaded...
> 
> Yeah, I know..but I spent all day hacking .34 enough to
> run lockdep and get those backtraces..and they *might* be
> valid.  There's a small chance someone else has seen similar
> things but not reported it for whatever reason, so maybe
> they will chime in.
> 
> And finally, I will attempt to reproduce with some official
> kernels, and will report what I find one way or another.
> 
> The .34 kernel has been a real bitch to get stable  (You
> know things must be bad when my name's on -stable patches),
> so I wouldn't be surprised if I'm hitting another real bug.

Understand your pain. The hardest problem is often finding a reproducible case.
If the problem is not reproducible it is hard to add trace info
or use bisection.

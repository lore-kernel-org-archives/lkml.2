Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1HQWRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 18:17:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37569 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab1HQWRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 18:17:30 -0400
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110817170152.GA22499@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <20110811160358.GA7989@redhat.com>
	 <1313523659.3436.184.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110817170152.GA22499@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 23:17:26 +0100
Message-ID: <1313619446.2311.52.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 19:01 +0200, Oleg Nesterov wrote:
> On 08/16, Matt Fleming wrote:
> >
> > Did you want me to send just the updated
> > versions of patches or the entire series again? It would seem over the
> > top to send the entire series.
> 
> This is up to you. Just in case, feel free to add my acked-by or
> reviewed-by to any patch I didn't comment explicitly. Or may be
> 
> > Also, are you going to pull these patches into your tree and send them
> > to Linus or would it be better to route them through -mm?
> 
> This is the question ;)
> 
> I simply do not know what should we do. I think this should be
> routed via maintainers.

Yeah, that seems like the best solution.

> Or I can push this into the poor ptrace branch... but I am
> thinking with horror about the possible conflicts in arch/ code...
> 
> What do you think?

I'll let all the maintainers take it through their trees.

> Damn. And I can't relax. This is very minor, but I still think
> it would be nice to have a common helper which plays sa_mask /
> SA_NODEFER to set ->blocked. But in this case, you probably need
> to resend the whole series ;)
> 
> I mean something like the patch below. OK, nevermind. Probably
> this factorization doesn't buy too much, but it will complicate
> the merging.

This does look like a decent clean up, especially because so many
architectures got this sequence wrong in the past. But yeah, it will
require me to rewrite half my series ;-)

Is it worth rewriting the series? Dunno. I'm not convinced that the
wrapper buys us enough for that, plus it'd increase the number of
patches.

Maybe it'd be better to do it as a separate set of patches?

-- 
Matt Fleming, Intel Open Source Technology Center


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1KAVSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:18:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31688 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1KAVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:18:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6517"; a="133171679"
Date: Tue, 1 Nov 2011 16:17:59 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [PATCH v5 33/36] Hexagon: Add configuration and makefiles for
 the Hexagon architecture.
Message-ID: <20111101211759.GB3035@codeaurora.org>
References: <093448$3uejv7@wolverine01.qualcomm.com>
 <1320139846.14409.129.camel@x61.thuisdomein>
 <20111101172709.GA3035@codeaurora.org>
 <1320173992.14409.193.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320173992.14409.193.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 07:59:52PM +0100, Paul Bolle wrote:
> So, you'll move it up a line?
>  
> > > > +#config ZONE_DMA
> > > > +#	bool
> > > > +#	default y
> > > 
> > > Why is this added commented out?
> > 
> > We were using it before, but not anymore.
> 
> So, please drop it.

Yes to both of these.

> But "config TRACING" (in kernel/trace/Kconfig) also selects it if
> STACKTRACE_SUPPORT is set. It seems GENERIC_TRACER is the hidden magic
> here. GENERIC_TRACER is selected by the various tracer options - see
> kernel/trace/Kconfig again, I'm unfamiliar with this stuff - and will
> itself select TRACING. So if an arch has STACKTRACE_SUPPORT set it
> doesn't have to select STACKTRACE itself. (Note that - except for tile -
> no other arch selects STACKTRACE.) 
> 
> But hopefully someone who doesn't have to grep the Kconfig files to
> understand this, can tell us for sure.

Ah...  Well, if nothing else, I'll just try not setting it and see if it
works as it seems to be intended.
 
> If you really feel you need to add it, but commented out, perhaps a
> comment can be added to keep people like me from submitting patches to
> remove it.

Sounds reasonable.  I'll either add a comment or just remove it
altogether (which is the long term goal).

Not that I mind getting patches, of course.

I'll have all these fixed in my tree and push them out when I can.


Thanks,
Richard Kuo

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

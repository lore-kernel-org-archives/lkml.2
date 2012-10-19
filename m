Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2JSQ0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:26:04 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:20410 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759409Ab2JSQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:26:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LoS95bdTbTbAhLIRszBN3FjhM0oPAVHg=
Date: Fri, 19 Oct 2012 12:25:08 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PULL REQ] IXP4xx changes for Linux 3.7
Message-ID: <20121019162508.GJ14395@titan.lakedaemon.net>
References: <m3bog6m5iz.fsf@intrepid.localdomain>
 <201210142002.55841.arnd@arndb.de>
 <m3a9vkahci.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3a9vkahci.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:01:17AM +0200, Krzysztof Halasa wrote:
...
> Unfortunately, as I already explained to you in
> https://lkml.org/lkml/2012/9/29/37, my resources for IXP4xx are very
> limited (and this isn't a paid job) and I'm in no way able to do what
> you require. This, coupled with my inability to make the patches end
> up upstream any other way, will make me post relevant MAINTAINERS
> changes shortly.
> 
> Don't get me wrong. If I had time for this it could be different.
> Unfortunately IXP4xx is a legacy arch, and for me it's simply a hobby
> at this point. Given the raised barriers to participate, probably
> aimed at paid maintainers, I have to quit doing this.

Krzysztof, please reconsider.  I'm also a hobbyist maintainer
(kirkwood,orion5x,mv78xx0,dove,mvebu).  I'd hate to see the community
lose a valuable maintainer because arch/arm/ has grown so much.

If you would like, I could pull your patches through my tree and send
them on to arm-soc.  I'm already familiar with arm-soc process, and I'll
admit I have a soft spot for mach-ixp4xx.  It was my first experience
with embedded Linux (nslu2, gateworks boards).

This way, you could see the process first hand without having to do the
labor.

We could do this for a few release cycles so you can see how it goes.
After that, we can reassess things.  If you still don't wish to lend
your experience, so be it.  But I hope we can change your mind.

thx,

Jason.

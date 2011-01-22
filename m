Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab1AVTtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 14:49:36 -0500
Received: from relais.videotron.ca ([24.201.245.36]:32428 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1AVTte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 14:49:34 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 22 Jan 2011 14:49:33 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Nexus One Support
In-reply-to: <AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1101221432360.8580@xanadu.home>
References: <20110121094827.41818a55@jbarnes-desktop>
 <20110121095658.1ab623fe@jbarnes-desktop> <1295632828.19880.22.camel@m0nster>
 <20110121100441.06a94482@jbarnes-desktop> <1295633882.19880.31.camel@m0nster>
 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
 <1295642995.19880.42.camel@m0nster> <1295643762.25868.31.camel@Joe-Laptop>
 <1295645098.22882.1.camel@m0nster>
 <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
 <20110122122018.GC5194@n2100.arm.linux.org.uk>
 <AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Brian Swetland wrote:

> All we ask is that some reasonable acknowledgement of original
> authorship is maintained for non-trivial work.  A 5-10 line patch that
> deals with mechanical issues of board files or cleans stuff up is no
> big deal.  100s of lines that represent some real work is something
> else.

So... What about http://article.gmane.org/gmane.linux.ports.arm.msm/167 ?
Is that good enough for you?  If no, then could you please propose an 
alternative?  If that is indeed good enough, then could we please move on?

> What would be useful would be a reasonable convention for
> acknowledging multiple authors, perhaps something along the lines of:
> 
> Author: Awesome Upstreamer <au@example.com>  or  Main Author <main@example.com>
> Committer: Awesome Upstreamer <au@example.com>
> Subject: arm: msm8k: acpu clock management
> 
> ... summary of the patch ...
> 
> Original-Author: Joe Firmware Guy <joe@oem.com>
> Original-Author: Kernel Droid <droid@android.com>
> Signed-off-by: ...
> 
> Though I'm not sure "Original-Author" is the best phrasing here...  Or
> perhaps just having the patch description end with "This patch is
> based on original code by Joe Firmware Guy, Kernel Droid, etc is the
> way to go.  I do think that for work where there is one clear original
> author, it's nice to leave them as the Author, but at the end of the
> day, provided the code's heading in the right direction and the
> contributors are acknowledged, that's a detail.

I think a free form list of contributors in the commit log should be 
fine, possibly adding them in CC to the patch submission as well.

There is a _huge_ value in the action of making code palatable for 
mainline inclusion and actually pushing that code into mainline. If you 
do it yourself next time instead of letting your code rot then no one 
might be tempted to stump on your authorship.


Nicolas

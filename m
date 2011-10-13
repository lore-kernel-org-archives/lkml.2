Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1JMVwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:52:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:61277 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab1JMVwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:52:05 -0400
Date: Thu, 13 Oct 2011 17:51:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rusty Russell <rusty@ozlabs.org>
CC: <mingo@elte.hu>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
Message-ID: <20111013215142.GB28189@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <87botlej9o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87botlej9o.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 13/10/2011 (Thu 12:37) Rusty Russell wrote:

> On Thu, 28 Jul 2011 01:16:07 -0400, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > I don't think there really is any rocket science or contentious stuff here.
> > It is a sensible cleanup that adds organization and speeds up compiles.
> > The RFC I'm hoping for is more about how/when we want to get this in tree.
> 
> In future, when you're ripping into module.h, please CC the module
> maintainer.  It's not just a courtesy, it helps everyone avoid redundant
> work.

Sorry about that.  I think I'd created the original module.h patch in
the context of the thread that Ingo started, and it never crossed my
mind at the time to run get_maintainer.pl on module.h itself.  And
that patch hasn't changed since.  An oversight on my part.  :(

> 
> You may insert your own sarcastic comment about "rocket science" here.

Yeah, fair enough -- remembering to CC maintainers isn't rocket science.
I hope you'll accept that it was an honest oversight caused by
circumstance and that it wasn't an intentional exclusion.

> 
> As to the patch: it's marginal improvement, but it's neater and I'm
> happy you're doing it.

Thanks -- I'm glad at least the end result is OK with you.

Paul.

> 
> Thanks,
> Rusty.

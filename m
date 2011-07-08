Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1GHPVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:21:14 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63594 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1GHPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:21:13 -0400
Date: Fri, 8 Jul 2011 19:21:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [rfc] perf p4 events aliases
Message-ID: <20110708152103.GG23657@sun>
References: <20110707152849.GV5485@sun>
 <20110708151307.GA6710@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708151307.GA6710@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 11:13:07AM -0400, Don Zickus wrote:
> On Thu, Jul 07, 2011 at 07:28:49PM +0400, Cyrill Gorcunov wrote:
> > Hi Don, if you have a chance could you please check if this
> > patch does a trick for nmi-watchdog and perf top? The idea
> > is to use aliases as being proposed early.
> 
> Hmm, didn't work for me.  The watchdog seems to work but 'perf top' showed
> nothing (even after 30 seconds).  I tried this on Linus's latest -tip and
> Ingo's perf/core -tip.  No luck.
> 
> Cheers,
> Don
> 

Thanks, Don, Steven reported me the same thing. I'll ping you back
as only handle this. Thanks again!

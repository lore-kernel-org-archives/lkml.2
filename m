Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0DUXpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:45:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:51741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0DUXpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:45:07 -0400
Date: Wed, 21 Apr 2010 16:22:00 -0700
From: Greg KH <gregkh@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100421232200.GA22877@suse.de>
References: <4BCE579C.5070100@sgi.com>
 <4BCE5A73.3000904@sgi.com>
 <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
 <20100421165934.GN16427@zorg.emea.sgi.com>
 <4BCF336B.1050706@redhat.com>
 <19407.20109.308816.104856@stoffel.org>
 <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org>
 <20100421222414.GA26241@suse.de>
 <4BCF80F2.2010906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF80F2.2010906@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 06:49:22PM -0400, Rik van Riel wrote:
> On 04/21/2010 06:24 PM, Greg KH wrote:
> 
> >Tejun's work has much better long term potential, but this is still an
> >issue for large #cpu systems, which we want Linux to support well.  This
> >isn't a "specialized niche" for Linux, at all, Linux pretty much
> >dominates this hardware area, and it would be nice to ensure that this
> >continues.
> 
> Yes, the pid_max patch seems like a decent stop gap for
> distro kernels right now.  However, Tejun's work is
> probably a more appropriate path forward.

Distros don't want to take a patch that adds a new boot param that is
not accepted upstream, otherwise they will be stuck forward porting it
from now until, well, forever :)

As this solves a problem that people are having today, on the kernel.org
kernel, on a known machine, and we really don't know when the "reduce
the number of processes per cpu" work will be done, or if it really will
solve this issue, then why can't we take it now?  If the work does solve
the problem in the future, then we can take the command line option out,
and everyone is happy.

Sound reasonable?

thanks,

greg k-h

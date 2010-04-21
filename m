Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0DUWhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:37:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:50431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0DUWha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:37:30 -0400
Date: Wed, 21 Apr 2010 15:24:14 -0700
From: Greg KH <gregkh@suse.de>
To: John Stoffel <john@stoffel.org>
Cc: Hedi Berriche <hedi@sgi.com>, Rik van Riel <riel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100421222414.GA26241@suse.de>
References: <4BCE579C.5070100@sgi.com>
 <4BCE5A73.3000904@sgi.com>
 <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
 <20100421165934.GN16427@zorg.emea.sgi.com>
 <4BCF336B.1050706@redhat.com>
 <19407.20109.308816.104856@stoffel.org>
 <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19407.23456.469074.256306@stoffel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 04:10:08PM -0400, John Stoffel wrote:
> >>>>> "Hedi" == Hedi Berriche <hedi@sgi.com> writes:
> 
> Hedi> On Wed, Apr 21, 2010 at 20:15 John Stoffel wrote:
> Hedi> | >>>>> "Rik" == Rik van Riel <riel@redhat.com> writes:
> Hedi> | 
> Hedi> | Rik> That is 15 kernel threads per CPU.
> Hedi> | 
> Hedi> | Rik> Reducing the number of kernel threads sounds like a
> Hedi> | Rik> useful thing to do.
> Hedi> | 
> Hedi> | Isn't that already a project? 
> 
> Hedi> Yes, thanks to Alan's probing I looked it up 
> 
> Hedi>     http://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
> 
> Hedi> but we're definitely talking long term solution vs. something
> Hedi> that can ease pain now.
> 
> It seems to me that running Linux on such a large machine is such a
> specialized niche, the putting in your change to the regular kernel
> isn't a near term need either.  And from the sounds of it, Tejun's
> work has better long term potential.

Tejun's work has much better long term potential, but this is still an
issue for large #cpu systems, which we want Linux to support well.  This
isn't a "specialized niche" for Linux, at all, Linux pretty much
dominates this hardware area, and it would be nice to ensure that this
continues.

thanks,

greg k-h

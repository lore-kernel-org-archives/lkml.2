Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0CYFgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:36:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:53293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab0CYFgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:36:10 -0400
Date: Thu, 25 Mar 2010 16:36:08 +1100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm: lockdep page lock
Message-ID: <20100325053608.GB7493@laptop.nomadix.com>
References: <20100315155859.GE2869@laptop>
 <20100315180759.GA7744@quack.suse.cz>
 <20100316022153.GJ2869@laptop>
 <1269437291.5109.238.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269437291.5109.238.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 02:28:11PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-03-16 at 13:21 +1100, Nick Piggin wrote:
> > 
> > 
> > Agreed (btw. Peter is there any way to turn lock debugging back on?
> > it's annoying when cpufreq hotplug code or something early breaks and
> > you have to reboot in order to do any testing).
> 
> Not really, the only way to do that is to get the full system back into
> a known (zero) lock state and then fully reset the lockdep state.
> 
> It might be possible using the freezer, but I haven't really looked at
> that, its usually simpler to simply fix the offending code or simply not
> build it in your kernel.

Right, but sometimes that is not possible (or you don't want to
turn off cpufreq). I guess you could have an option to NOT turn
it off in the first place. You could just turn off warnings, but
leave everything else running, couldn't you?

And then the option would just be to turn the printing back on.


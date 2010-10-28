Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934568Ab0J1U7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:59:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:64790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934535Ab0J1U67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:58:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,254,1286175600"; 
   d="scan'208";a="621316162"
Date: Thu, 28 Oct 2010 22:58:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [GIT PULL] battery-2.6.git (a last minute fix)
Message-ID: <20101028205605.GB3116@sortiz-mobl>
References: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
 <20101028065457.GA29856@elte.hu>
 <20101028000710.2039c2f4.akpm@linux-foundation.org>
 <20101028090953.GA28283@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028090953.GA28283@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Thu, Oct 28, 2010 at 01:09:53PM +0400, Anton Vorontsov wrote:
> On Thu, Oct 28, 2010 at 12:07:10AM -0700, Andrew Morton wrote:
> [...]
> > > The new driver does not build at its own commit point either, as the missing symbol 
> > > definition is simply not there. It appears that commit 2e727f1 could not have been 
> > > build-tested by anyone before it got upstream (let alone boot and functionality 
> > > tested). As a temporary workaround i'm disabling it in -tip.
> > > 
> > 
> > Those definitions get added by the MFD tree and used by the battery
> > tree.  Things arrived in the wrong order (and, yes, didn't get tested).
> 
> My bad. :-/
>
> > The fix is for Samuel to get a wiggle on with his merge?  The -rc1
> > window is about to slam shut on his fingers anyway.
> 
> I guess the best thing for now would be to be safe and to disable
> the new driver via 'depends on BROKEN', so it won't scare testers
> away from -rc1.
I'm about to send my pull request to Linus. Should I send this commit revert
as part of the pull request, or do you want to do it ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

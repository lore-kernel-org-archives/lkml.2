Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab0J1VRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:17:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33909 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab0J1VRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jqHJ0tarNPq3JIE3NAKmtQJoIyKBaqL4SuqUDGUX6WFVE1hRqGn8FkSc7VZU+k/cQ8
         iIAGCDyWP0wiBRTwMV+S78+GhOrHa9kp/3NAHFF4EY3c0O7tmf5IxJ7oB2ZwbDrmx+Wi
         QSDdZHJI5L1VAqXXBV021CRpoUfGyCkd9ZtOw=
Date: Fri, 29 Oct 2010 01:17:00 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [GIT PULL] battery-2.6.git (a last minute fix)
Message-ID: <20101028211700.GA32299@oksana.dev.rtsoft.ru>
References: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
 <20101028065457.GA29856@elte.hu>
 <20101028000710.2039c2f4.akpm@linux-foundation.org>
 <20101028090953.GA28283@oksana.dev.rtsoft.ru>
 <20101028205605.GB3116@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101028205605.GB3116@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:58:55PM +0200, Samuel Ortiz wrote:
> Hi Anton,
> 
> On Thu, Oct 28, 2010 at 01:09:53PM +0400, Anton Vorontsov wrote:
> > On Thu, Oct 28, 2010 at 12:07:10AM -0700, Andrew Morton wrote:
> > [...]
> > > > The new driver does not build at its own commit point either, as the missing symbol 
> > > > definition is simply not there. It appears that commit 2e727f1 could not have been 
> > > > build-tested by anyone before it got upstream (let alone boot and functionality 
> > > > tested). As a temporary workaround i'm disabling it in -tip.
> > > > 
> > > 
> > > Those definitions get added by the MFD tree and used by the battery
> > > tree.  Things arrived in the wrong order (and, yes, didn't get tested).
> > 
> > My bad. :-/
> >
> > > The fix is for Samuel to get a wiggle on with his merge?  The -rc1
> > > window is about to slam shut on his fingers anyway.
> > 
> > I guess the best thing for now would be to be safe and to disable
> > the new driver via 'depends on BROKEN', so it won't scare testers
> > away from -rc1.
> I'm about to send my pull request to Linus. Should I send this commit revert
> as part of the pull request, or do you want to do it ?

Would be great if you do it. Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

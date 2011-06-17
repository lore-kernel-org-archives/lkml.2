Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab1FQVYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:24:35 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55471 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755379Ab1FQVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:24:34 -0400
Date: Fri, 17 Jun 2011 23:24:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Add x86 RAS people
Message-ID: <20110617212450.GA2577@elf.ucw.cz>
References: <1308067734-6156-1-git-send-email-bp@amd64.org>
 <20110617132757.GA9659@localhost.ucw.cz>
 <20110617135056.GE18054@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617135056.GE18054@aftab>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2011-06-17 15:50:56, Borislav Petkov wrote:
> On Fri, Jun 17, 2011 at 09:27:58AM -0400, Pavel Machek wrote:
> > On Tue 2011-06-14 18:08:54, Borislav Petkov wrote:
> > > Announce the new RAS infrastructure maintainers. The file patterns below
> > > will change after we start the restructuring.
> > > 
> > > Signed-off-by: Borislav Petkov <bp@amd64.org>
> > > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > >  
> > > +X86 RAS INFRASTRUCTURE
> > > +M:	Tony Luck <tony.luck@intel.com>
> > 
> > this would be great place to explain "ras"...
> 
> Wikipedia has a basic overview: http://en.wikipedia.org/wiki/Reliability,_Availability_and_Serviceability
>

This is what I was looking for. Can we modify MAINTAINERS to say

X86 RELIABILITY AVAILABILITY AND SERVICEABILITY (RAS) INFRASTRUCTURE
M:	Tony Luck <tony.luck@intel.com>

?
 
> Our idea is to make error collection and reporting much more easy to
> configure and much easily manageable now that reliability features are
...
> So things like that, I'm pretty sure I'm leaving something out but you
> should be getting the idea...

Actually I got the idea when I saw "mcelog" in file paths, but... :-)

									pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

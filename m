Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab0EDHzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:55:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756402Ab0EDHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:55:38 -0400
Date: Tue, 4 May 2010 06:18:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: 2.6.33-2.6.34-rc5 suspend issues
Message-ID: <20100504041849.GA1262@ucw.cz>
References: <20100427074609.GA3261@ikn.schottelius.org>
 <20100427083202.GA3143@ikn.schottelius.org>
 <20100428160935.GA4010@schottelius.org>
 <20100429191241.GA3407@schottelius.org>
 <20100501122441.GA3273@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501122441.GA3273@schottelius.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-05-01 14:24:41, Nico Schottelius wrote:
> Nico Schottelius [Thu, Apr 29, 2010 at 09:12:42PM +0200]:
> > Nico Schottelius [Wed, Apr 28, 2010 at 06:09:36PM +0200]:
> > > Nico Schottelius [Tue, Apr 27, 2010 at 10:32:02AM +0200]:
> > > > 
> > > > Nico Schottelius [Tue, Apr 27, 2010 at 09:46:09AM +0200]:
> > > > > [..] 
> > > > > - suspend & resume works once
> > > > > - second time system
> > > > >   b) suspends, but comes up with the bios screen after resume
> > > > >      and hangs there forever (2.6.34-*)
...
> Same happens on 2.6.34-rc5-00340-g79dba2e, now testing
> 2.6.34-rc6-00063-gbe1066b.

There's one bit that needs to be set to stay in the acpi mode, and
there's blacklist somewhere...?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

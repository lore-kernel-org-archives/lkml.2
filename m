Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2BCVmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:42:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928Ab2BCVm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:42:29 -0500
Date: Fri, 3 Feb 2012 22:42:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
In-Reply-To: <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1202032241380.25026@pobox.suse.cz>
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net> <1326661784.7642.140.camel@gandalf.stny.rr.com> <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jan 2012, Jesper Juhl wrote:

> > > -/* This code will be removed after deprecation time exceeded (2.6.41) */
> > > +/* This code will be removed after deprecation time exceeded (3.1) */
> > 
> > Shouldn't the real fix be to remove this code? What's the use of
> > changing the version number that this code will be removed from, when
> > the change won't get in until after the version that this code should
> > have been removed?
> > 
> > This is like updating 2014 calendars to say the world will end in 2012.
> > 
> Heh, yeah, in a way you are right. But we have lots of code in the kernel 
> that says it will be removed at <some date in the past>, so I just figured 
> that if this code ends up hanging around it should at least display the 
> correct version number for when it /should/ have been removed.
> The actual removal I'll leave up to others.

Funny thing. Okay, this doesn't seem to be in linux-next, so I am taking 
it.

Steven, planning to drop the code in a near future? :)

-- 
Jiri Kosina
SUSE Labs

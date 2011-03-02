Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab1CBWDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:03:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40825 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab1CBWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:03:10 -0500
Date: Wed, 2 Mar 2011 15:03:05 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] gpio: add trace events for setting direction and value
Message-ID: <20110302220305.GB22854@angua.secretlab.ca>
References: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1297876371.26768.7235.camel@fedora>
 <20110218095803.GY22310@pengutronix.de>
 <1298044086.26768.7242.camel@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298044086.26768.7242.camel@fedora>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:48:06AM -0500, Steven Rostedt wrote:
> On Fri, 2011-02-18 at 10:58 +0100, Uwe Kleine-König wrote:
> > Hi Steven, hi Grant,
> > 
> > On Wed, Feb 16, 2011 at 12:12:51PM -0500, Steven Rostedt wrote:
> > > Note: to save the memory footprint of these tracepoints, you can use
> > > DEFINE_EVENT_PRINT(). You can see the usage for this in the
> > > include/trace/events/kmem.h.
> > > But to do this, you will need to have a single TP_STRUCT__entry() for
> > > both. Not sure if this is what you want.
> > > 
> > > 	TP_STRUCT__entry(
> > > 		__field(unsigned, gpiq)
> > > 		__field(int, get_in)
> > > 		__field(int, value_err)
> > > 
> > > ??
> > > 
> > > Just a suggestion, but may not be worth it.
> > Yeah, I saw that, still I think it's sane to keep them seperated.
> > Or how much would we save?  Can you estimate that?
> 
> You can do it :)   Especially since it can vary by archs.
> 
> Just compile the kernel once this way, and then try it with
> DEFINE_EVENT_PRINT(), compile the kernel and run size on the two.
> 
> Then you can see the difference it makes. It may end up not being worth
> the difference. But as embedded uses gpio the most, I'll leave that up
> to you.

Uwe, any update on this?  Are you going to spin a new patch, or should
I take this one?

g.

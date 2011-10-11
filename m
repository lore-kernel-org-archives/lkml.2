Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1JKOYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:24:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab1JKOYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:24:35 -0400
Date: Tue, 11 Oct 2011 08:24:23 -0600
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: Commits missed for stable
Message-ID: <20111011142423.GB31776@suse.de>
References: <1318337139.7904.170.camel@gandalf.stny.rr.com>
 <20111011142006.GA18281@suse.de>
 <20111011142331.GA31776@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011142331.GA31776@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:23:31AM -0600, Greg KH wrote:
> On Tue, Oct 11, 2011 at 08:20:06AM -0600, Greg KH wrote:
> > On Tue, Oct 11, 2011 at 08:45:38AM -0400, Steven Rostedt wrote:
> > > It's come to my attention that a bug that was fixed by:
> > > 
> > > 43dd61c9a09bd413e837df829e6bfb42159be52a
> > > ftrace: Fix regression of :mod:module function enabling
> 
> Wait, that patch causes a TON of warnings to the build, so either I drop
> it, or is there some other follow-on patch that I can apply to fix these
> warnings?

Ah, I think I want 04da85b86188f224cc9b391b5bdd92a3ba20ffcf, right?

I'll go try that...

greg k-h

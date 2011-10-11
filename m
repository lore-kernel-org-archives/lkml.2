Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1JKOYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:24:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1JKOYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:24:31 -0400
Date: Tue, 11 Oct 2011 08:23:31 -0600
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: Commits missed for stable
Message-ID: <20111011142331.GA31776@suse.de>
References: <1318337139.7904.170.camel@gandalf.stny.rr.com>
 <20111011142006.GA18281@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011142006.GA18281@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:20:06AM -0600, Greg KH wrote:
> On Tue, Oct 11, 2011 at 08:45:38AM -0400, Steven Rostedt wrote:
> > It's come to my attention that a bug that was fixed by:
> > 
> > 43dd61c9a09bd413e837df829e6bfb42159be52a
> > ftrace: Fix regression of :mod:module function enabling

Wait, that patch causes a TON of warnings to the build, so either I drop
it, or is there some other follow-on patch that I can apply to fix these
warnings?

greg k-h

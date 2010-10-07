Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab0JGWA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:00:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:56178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab0JGWA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:00:57 -0400
Date: Thu, 7 Oct 2010 14:52:21 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Ben Dooks <ben-linux@fluff.org>, Alan Cox <alan@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Mike Frysinger <vapier@gentoo.org>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
Message-ID: <20101007215221.GA11478@suse.de>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
 <20101007211513.GB26660@suse.de>
 <1286488038.23836.101.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286488038.23836.101.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 02:47:18PM -0700, Daniel Walker wrote:
> On Thu, 2010-10-07 at 14:15 -0700, Greg KH wrote:
> > On Thu, Oct 07, 2010 at 01:51:18PM -0700, Daniel Walker wrote:
> > > Your making too many assumptions .. You might be able to modify the
> > > kernel, and not the userspace. So you couldn't tweak the device
> > > creation .. It's much easier in the server world ..
> > 
> > You're saying it's easier to replace an embedded kernel than a userspace
> > file on an embedded system?  Heh, that's funny.
> 
> I'm saying it _can_ happen that it's easier to replace the kernel.. I'm
> not saying it's always the case. We're talking about debugging
> situations in an embedded environment which don't always follow a normal
> path.

Nothing is "normal", so stop trying to say it is easier in the "server"
world please.

> > > > We've said no over a period of about ten years to a lot of attempts to
> > > > just borrow the ttyS0 range. If we'd said yes it would have been a
> > > > complete mess by now.
> > > > 
> > > > So the answer is no.
> > > 
> > > Nothing can be unilateral, there's always room for exceptions. You
> > > should say something more like "it's possible, but unlikely".
> > 
> > Hm, how about this, as the TTY and serial driver[1] maintainer, I will
> > not accept this kind of patch at all.
> > 
> > Is that final enough for you?
> 
> So you don't like it, that's fair enough .. <thinks>I wonder what other
> maintainers I can send this too</thinks> ;)
> 
> Can you be more specific about your objections

See everything that Mike and Alan wrote, do I need to repeat it?

greg k-h

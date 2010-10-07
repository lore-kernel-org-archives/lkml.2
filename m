Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0JGVPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:15:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab0JGVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:15:27 -0400
Date: Thu, 7 Oct 2010 14:15:13 -0700
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
Message-ID: <20101007211513.GB26660@suse.de>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 01:51:18PM -0700, Daniel Walker wrote:
> Your making too many assumptions .. You might be able to modify the
> kernel, and not the userspace. So you couldn't tweak the device
> creation .. It's much easier in the server world ..

You're saying it's easier to replace an embedded kernel than a userspace
file on an embedded system?  Heh, that's funny.

And no, it's not easier to repace a kernel on a "server" than a
userspace file, due to all sorts of good reasons (certifications,
support contracts, etc...)

> > We've said no over a period of about ten years to a lot of attempts to
> > just borrow the ttyS0 range. If we'd said yes it would have been a
> > complete mess by now.
> > 
> > So the answer is no.
> 
> Nothing can be unilateral, there's always room for exceptions. You
> should say something more like "it's possible, but unlikely".

Hm, how about this, as the TTY and serial driver[1] maintainer, I will
not accept this kind of patch at all.

Is that final enough for you?

thanks,

greg k-h

[1] http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-06-tty/serial-mark-the-8250-driver-as-maintained.patch

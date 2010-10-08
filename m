Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab0JHQLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:11:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9086 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab0JHQLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:11:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57091533"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Ben Dooks <ben-linux@fluff.org>, Alan Cox <alan@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <20101008154058.GA19202@suse.de>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
	 <1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com>
	 <20101008091331.74871a42@lxorguk.ukuu.org.uk>
	 <1286551434.4153.21.camel@m0nster>  <20101008154058.GA19202@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 09:11:13 -0700
Message-ID: <1286554273.4153.97.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 08:40 -0700, Greg KH wrote:
> On Fri, Oct 08, 2010 at 08:23:54AM -0700, Daniel Walker wrote:
> > > And if your hypothetical user isn't able to do this then maybe instead of
> > > trying to screw up the kernel for everyone they should ask an
> > > undergraduate student who is smart enough to help them.
> > 
> > I don't think the kernel is going to implode if we allow an optional
> > ttyS override for debugging purposes.. I just don't see that "screwing"
> > up the kernel. I can even embedded that inside the C file, and not make
> > it a Kconfig option ..
> 
> I admire your persistence, but perhaps you should take a step back and
> look at the history here.  You just want this override.  Then someone
> else does, and then, someone else.  Eventually we are all overridden.
> 
> Remember, you aren't unique here, as much as you might feel like you are
> :)

It's not that _I_ want it .. If you look at the code it's not that huge
a part of the source .. It's got it's own ttyJ already, and it's
ifdefe'd. It would be pretty easy to remove it. The other thing is that
it's not something I use, so for me it's kind of take it or leave it.

So why am I arguing to keep it? Well the original author added it for a
purpose, which I can't assume was useless .. I can also imagine
situations when it would be helpful to do this.

To me it's more a question of if the override is useful or not .. If
it's useful then it's just about organizing the code so the kernel
doesn't melt down if we allow it.

Thinking about it overrides are actually allowed right now, it's just
that you have to mod the source some to do it.

> Please listen to what Alan and Mike are saying, experience matters, and
> they are trying to impart it to you, despite your most fervent attempts
> to avoid it.

The whole "fervent" thing is kind of funny to me.. I'm just persistent,
that's what it's comes down to. Like I said above I'm not "in love" with
this feature. I am actually taking Mike and Alan's advice by the way, so
it's not like I'm not listening (or reading in this case)..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0JHPlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:41:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab0JHPlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:41:17 -0400
Date: Fri, 8 Oct 2010 08:40:58 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Ben Dooks <ben-linux@fluff.org>, Alan Cox <alan@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
Message-ID: <20101008154058.GA19202@suse.de>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org> <20101007215019.17b4a34a@lxorguk.ukuu.org.uk> <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com> <20101007220538.2294a7e4@lxorguk.ukuu.org.uk> <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com> <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com> <1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com> <20101008091331.74871a42@lxorguk.ukuu.org.uk> <1286551434.4153.21.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286551434.4153.21.camel@m0nster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 08:23:54AM -0700, Daniel Walker wrote:
> > And if your hypothetical user isn't able to do this then maybe instead of
> > trying to screw up the kernel for everyone they should ask an
> > undergraduate student who is smart enough to help them.
> 
> I don't think the kernel is going to implode if we allow an optional
> ttyS override for debugging purposes.. I just don't see that "screwing"
> up the kernel. I can even embedded that inside the C file, and not make
> it a Kconfig option ..

I admire your persistence, but perhaps you should take a step back and
look at the history here.  You just want this override.  Then someone
else does, and then, someone else.  Eventually we are all overridden.

Remember, you aren't unique here, as much as you might feel like you are
:)

Please listen to what Alan and Mike are saying, experience matters, and
they are trying to impart it to you, despite your most fervent attempts
to avoid it.

good luck,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0EOO4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:56:38 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:45472 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753815Ab0EOO4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:56:36 -0400
Date: Sat, 15 May 2010 16:55:58 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: rmk@arm.linux.org.uk
Cc: linux-pcmcia@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, Vincent Sanders <vince@kyllikki.org>
Subject: Re: [PATCH 5/5] pcmcia: disable pcmcia ioctl for !ARM, prepare for
 removal
Message-ID: <20100515145558.GA3184@comet.dominikbrodowski.net>
Mail-Followup-To: rmk@arm.linux.org.uk, linux-pcmcia@lists.infradead.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org, Vincent Sanders <vince@kyllikki.org>
References: <20100303075944.GA23354@comet.dominikbrodowski.net>
 <1267603248-23866-5-git-send-email-linux@dominikbrodowski.net>
 <20100515142409.GB18960@flint.arm.linux.org.uk>
 <20100515143705.GA10617@isilmar-3.linta.de>
 <20100515144639.GA10987@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100515144639.GA10987@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Sat, May 15, 2010 at 03:46:39PM +0100, Russell King wrote:
> On Sat, May 15, 2010 at 04:37:05PM +0200, Dominik Brodowski wrote:
> > Russell,
> > 
> > On Sat, May 15, 2010 at 03:24:10PM +0100, Russell King wrote:
> > > On Wed, Mar 03, 2010 at 09:00:48AM +0100, Dominik Brodowski wrote:
> > > > Furthermore, the last legitimate use of the ioctl to be reported
> > > > relates to the ARM architecture in 2008.[1] Attempts to resolve
> > > > this issue turned out unsuccessful so far.[2] Other usages have only
> > > > been reported as hear-say. If there are any legitiate and necessary
> > > > use-cases remaining, please speak out before the end of the grace
> > > > period until 2.6.3{5,6}(-rc1).
> > > 
> > > What's the point of speaking out?  You don't take any notice of people
> > > who do, and you continue your crusade of wanting to remove it.  Please,
> > > stop giving the impression that you give a damn of what people say about
> > > the ioctl interface.
> > 
> > The _only_ person who really has spoken out is you. All my requests to
> > actually see source code or actual use cases (e.g. which parts of the ioctl
> > do actually get called) did not lead to _anything_.
> 
> See the source code?  You clearly haven't been reading what I've been
> saying to you on the subject if you think I can produce source code.
> I've already explained this to you several times, but it seems to be
> constantly ignored.

That's why there is the _other_ alternative: "actual use cases (e.g. which
parts of the ioctl do actually get called)". For this, you only need to be
able to update/modify the kernel. More than two years ago, you signalised
to do exactly this:

| I'll spend some time this coming weekend working out precisely what it
| requires from the ioctl interface - maybe we can have a cut-down ioctl
| interface that bolts straight on as an "add on" to the new controls
| without being too invasive, while still allowing its PCMCIA bits to
| work.

[ http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005450.html ]

I haven't heard anything about the result of this experiment, even though
asking a number of times (e.g.
http://lists.infradead.org/pipermail/linux-pcmcia/2010-January/006740.html ).

Best,
	Dominik

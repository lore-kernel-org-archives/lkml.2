Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1ACBEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 20:04:07 -0500
Received: from relais.videotron.ca ([24.201.245.36]:26038 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1ACBEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 20:04:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 02 Jan 2011 20:04:02 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-msm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
In-reply-to: <20110103003340.GE17727@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.1101021956250.16090@xanadu.home>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <201012152337.19475.arnd@arndb.de> <20101217001658.GA5880@huya.qualcomm.com>
 <201012241429.28901.arnd@arndb.de>
 <alpine.LFD.2.00.1012251100340.10437@xanadu.home>
 <20110103003340.GE17727@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jan 2011, Russell King - ARM Linux wrote:

> On Sat, Dec 25, 2010 at 11:04:11AM -0500, Nicolas Pitre wrote:
> > On Fri, 24 Dec 2010, Arnd Bergmann wrote:
> > 
> > > On Friday 17 December 2010, David Brown wrote:
> > > > I'm not sure really what to do about PHYS_OFFSET.  This is kind of the
> > > > big thing that has kept us so far from making our SOCs multiply
> > > > selectable.  I could move this into a Kconfig option, but it would
> > > > still need to be selected by the SOC.  It is unfortunate that most of
> > > > our SOCs have different enough memory configurations that these are
> > > > mostly different.  Even 8960/8660 will probably have future variants
> > > > that are at different addresses.
> > > 
> > > I think there are people working on relocatable kernels already,
> > > and we definitely need this for the other work in progress of
> > > doing kernel binaries that work across different SoC families,
> > > as well as for doing a single kernel that can be used both for
> > > booting the system and for kdump.
> > > 
> > > You don't need to worry about PHYS_OFFSET at the platform level,
> > > we'll get there in a few months for all ARM platforms.
> > 
> > ... or in a few days even.  I'm currently working on the patch making 
> > PHYS_OFFSET patched into the kernel at run time.  I'm currently looking 
> > at what is needed to make it work also with Thumb2.
> 
> So where do we stand with:
> 
> http://lists.arm.linux.org.uk/lurker/message/20101110.175549.62a0b058.en.html
> 
> Is this something which should be queued for this merge window?

I'm working on a patch series that includes a slightly modified version 
of the above plus a few fixes for issues that turned up during testing.

I hope to have something for you to queue by tomorrow or tuesday.  This 
is damn close to the merge window, but we don't have to turn it on by 
default.

Nicolas

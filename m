Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1KOWMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:12:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1KOWML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:12:11 -0500
Date: Tue, 15 Nov 2011 14:09:13 -0800
From: Greg KH <gregkh@suse.de>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111115220913.GA17970@suse.de>
References: <20111115212012.GA5467@suse.de>
 <20111115130230.GA23584@mail.gnudd.com>
 <20111115213734.GA5094@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115213734.GA5094@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 10:37:34PM +0100, Alessandro Rubini wrote:
> Hi Greg. Thanks for looking.
> 
> >> +/*
> >> + * The regset32 stuff is used to print 32-bit registers using the
> >> + * seq_file utilities. We offer printing a register set in an already-opened
> >> + * sequential file or create a debugfs file that only prints a regset32.
> >> + */
> > 
> > Can this be part of the kerneldoc below somehow so that people are more
> > aware of it?
> 
> Ok. There's also a file by Jon in Documentation that needs updating, as it
> has all the other debugfs file types.

Ah, yes, that would be good.

> > +int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
> >> +			   int nregs, void __iomem *base, char *prefix)
> 
> > This function also needs to be part of debugfs.h in the "debugfs is not
> > enabled" section of the file, right?
> 
> Not really. The other one makes a regiters-only file, and it's good
> to register it withouth ifdef.
> 
> This one is used to embed a register block in a file with more
> stuff, so it shouldn't be used if debugfs is not selected (btw,
> I compiled my internal stuff with and without CONFIG_DEBUG_FS
> before rebasing to next).

That makes sense, thanks.

> So, I'll post a V2 shortly, unless you refuse it in reply to this.

Nope, a v2 would be great, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0IYRbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:31:10 -0400
Received: from kroah.org ([198.145.64.141]:54970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0IYRbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:31:08 -0400
Date: Sat, 25 Sep 2010 10:29:51 -0700
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] [PATCH v2 0/4] PCI: allocate space top-down, not
	bottom-up
Message-ID: <20100925172951.GA2390@kroah.com>
References: <20100917223109.24687.17697.stgit@bob.kio> <201009241641.40867.bjorn.helgaas@hp.com> <20100924234020.GA20601@kroah.com> <20100925163011.GA26747@helgaas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925163011.GA26747@helgaas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 10:30:11AM -0600, Bjorn Helgaas wrote:
> On Fri, Sep 24, 2010 at 04:40:20PM -0700, Greg KH wrote:
> > On Fri, Sep 24, 2010 at 04:41:39PM -0600, Bjorn Helgaas wrote:
> > > Added cc: stable@kernel.org
> > > See:
> > >   https://patchwork.kernel.org/patch/189182/
> > >   https://patchwork.kernel.org/patch/189232/
> > >   https://patchwork.kernel.org/patch/189242/
> > >   https://patchwork.kernel.org/patch/189252/
> > 
> > Um, why would -stable want them if they aren't in Linus's tree yet?
> > Please, when they are in his tree, _AND_ have gotten a lot of testing,
> > then email the git commit ids of what you want added to the stable tree
> > to stable@kernel.org.
> > 
> > Doing it beforehand like this is a sure way to cause me a lot of work
> > and the patches to be lost.
> 
> Oops, sorry, I'm inexperienced in the ways of -stable.  Akpm reminded me tocc:
> stable, and I thought he meant now, but he probably meant later.  I'll put it
> on my list for later.

Please read the file, Documentation/stable_kernel_rules.txt for how to
get stuff into the stable tree.

thanks,

greg k-h

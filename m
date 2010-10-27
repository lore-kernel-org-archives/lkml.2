Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab0J0OMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:12:16 -0400
Received: from kroah.org ([198.145.64.141]:38395 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab0J0OMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:12:13 -0400
Date: Wed, 27 Oct 2010 07:11:53 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (tty
	tree related)
Message-ID: <20101027141153.GC24938@kroah.com>
References: <20100927153151.9bf66022.sfr@canb.auug.org.au> <20101027110307.e754ef59.sfr@canb.auug.org.au> <20101027101127.6fd49417@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027101127.6fd49417@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:11:27AM +0100, Alan Cox wrote:
> On Wed, 27 Oct 2010 11:03:07 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Greg,
> > 
> > On Mon, 27 Sep 2010 15:31:51 +1000 Stephen Rothwell
> > <sfr@canb.auug.org.au> wrote:
> > >
> > > After merging the final tree, today's linux-next build (x86_64
> > > allmodconfig) produced this warning:
> > > 
> > > drivers/char/nozomi.c: In function 'ntty_ioctl':
> > > drivers/char/nozomi.c:1831: warning: unused variable 'argp'
> > > 
> > > Introduced by commit dd612b1a8edb7fb3a117c388bfb520476e04ed18 ("tty:
> > > icount changeover for other main devices").
> > 
> > This warning is now in Linus' tree ...
> 
> Already re-sent GregKH the fix. Guess it got eaten in the post last
> time.

Sorry, yes, now got it, will pick it up tomorrow when I get back from
vacation.

thanks,

greg k-h

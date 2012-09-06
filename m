Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab2IFRxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab2IFRxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:53:19 -0400
Date: Thu, 6 Sep 2012 13:53:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jim Cromie <jim.cromie@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] dev_<level> and dynamic_debug cleanups
Message-ID: <20120906175313.GC9786@redhat.com>
References: <cover.1345978012.git.joe@perches.com>
 <CAJfuBxyQc-XeNHxw0_XDs0JuCrNArNzcgsmrLya4ncDvSojZxQ@mail.gmail.com>
 <CAJfuBxyToA9-=c3H88GGba3GFX64kdbP4OCEC0f4trnBnjpU-w@mail.gmail.com>
 <20120906161359.GC23641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906161359.GC23641@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 09:13:59AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Aug 30, 2012 at 09:48:12PM -0600, Jim Cromie wrote:
> > On Thu, Aug 30, 2012 at 11:43 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > > On Sun, Aug 26, 2012 at 5:25 AM, Joe Perches <joe@perches.com> wrote:
> > >> The recent commit to fix dynamic_debug was a bit unclean.
> > >> Neaten the style for dynamic_debug.
> > >> Reduce the stack use of message logging that uses netdev_printk
> > >> Add utility functions dev_printk_emit and dev_vprintk_emit for /dev/kmsg.
> > >>
> > >> Joe Perches (5):
> > >>   dev_dbg/dynamic_debug: Update to use printk_emit, optimize stack
> > >>   netdev_printk/dynamic_netdev_dbg: Directly call printk_emit
> > >>   netdev_printk/netif_printk: Remove a superfluous logging colon
> > >>   dev: Add dev_vprintk_emit and dev_printk_emit
> > >>   device and dynamic_debug: Use dev_vprintk_emit and dev_printk_emit
> > >>
> > >
> > > Ive tested this on 2 builds differing only by DYNAMIC_DEBUG
> > > It works for me on x86-64
> > >
> > > However, I just booted a non-dyndbg build on x86-32, and got this.
> > >
> > 
> > Ok, transient error, went away with a clean build.
> > 
> > tested-by: Jim Cromie <jim.cromie@gmail.com>
> 
> Jason, any ACK on these, or any of the other random dynamic debug
> patches floating around?  What am I supposed to be applying here?
> 

Hi Greg,

I just posted some follow up comments to Joe, so let's see where that
discussion goes.

Thanks,

-Jason 

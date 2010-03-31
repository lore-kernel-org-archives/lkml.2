Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0CaWRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:17:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:53621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab0CaWRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:17:00 -0400
Date: Wed, 31 Mar 2010 15:17:24 -0700
From: Greg KH <gregkh@suse.de>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Mike Pagano <mpagano@gentoo.org>, Michael Chan <mchan@broadcom.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [007/116] tg3: Fix 5906 transmit hangs
Message-ID: <20100331221724.GA21767@suse.de>
References: <20100330230600.GA28802@kroah.com> <20100330225600.398306625@linux.site> <20100330211522.2f1658fe@redhat.com> <20100331203926.GA15418@suse.de> <20100331212309.GB16663@xw6200.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331212309.GB16663@xw6200.broadcom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:23:09PM -0700, Matt Carlson wrote:
> On Wed, Mar 31, 2010 at 01:39:26PM -0700, Greg KH wrote:
> > On Tue, Mar 30, 2010 at 09:15:22PM -0400, Chuck Ebbert wrote:
> > > On Tue, 30 Mar 2010 15:54:45 -0700
> > > Greg KH <gregkh@suse.de> wrote:
> > > 
> > > > 2.6.32-stable review patch.  If anyone has any objections, please let
> > > > us know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Matt Carlson <mcarlson@broadcom.com>
> > > > 
> > > > This is a resubmit backport of commit
> > > > 92c6b8d16a36df3f28b2537bed2a56491fb08f11 to kernel version 2.6.32.
> > > > The gentoo bug report can be found at
> > > > https://bugs.gentoo.org/show_bug.cgi?id=301091. Thanks to Matt
> > > > Carlson for his assistance and working me to fix a regression caused
> > > > by the initial patch.  The original description is as follows:
> > > > 
> > > 
> > > I think these two patches should be used instead, as they fix the
> > > bug without needing backports and keep the driver closer to upstream:
> > > 
> > > 0e1406dd404ce55dbe8d68b4b5e2aed7e5c75fdb
> > > "tg3: Assign flags to fixes in start_xmit_dma_bug"
> > > 
> > > 92c6b8d16a36df3f28b2537bed2a56491fb08f11
> > > "tg3: Fix 5906 transmit hangs"
> > 
> > I don't know, I'll defer to Matt here, this patch has gone in and out of
> > the stable queue for a while now as he and some users have tested and
> > had problems lots of times...
> > 
> > Matt?
> 
> I'm O.K. with either path.  I supported Mike's patch because it was
> minimal.  (All the bugs should be shaken out by now.)  If that isn't a
> goal, then I guess I'd rather rubber stamp my own implementation.

I'll live with what we have now as we know it's been tested, and it is
less work for me at the moment :)

thanks,

greg k-h

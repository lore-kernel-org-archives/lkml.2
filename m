Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0HLCHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 22:07:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab0HLCHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 22:07:14 -0400
Date: Wed, 11 Aug 2010 19:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: "Wang, Qi" <qi.wang@intel.com>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        "meego-dev@meego.com" <meego-dev@meego.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-ID: <20100812020027.GA14121@suse.de>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100810171343.GE21220@suse.de>
 <002601cb3926$edaf24d0$66f8800a@maildom.okisemi.com>
 <20100811151510.GB9180@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A28EA26B2@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A28EA26B2@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 09:13:24AM +0800, Wang, Qi wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Wednesday, August 11, 2010 11:15 PM
> > To: Masayuki Ohtake
> > Cc: meego-dev@meego.com; LKML; Wang, Qi; Wang, Yong Y; Khor, Andrew
> > Chih Howe; arjan@linux.intel.com
> > Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
> > 2.6.35
> > 
> > On Wed, Aug 11, 2010 at 04:29:25PM +0900, Masayuki Ohtake wrote:
> > > Hi Greg,
> > >
> > > > Do they all have to be ioctls?  What exactly are they doing?
> > > I think using ioctl is common for this patch.
> > 
> > "Common" is not ok, right?
> > 
> > > Do you think that using ioctl is NOT appropriate for this patch?
> > 
> > Yes.
> > 
> > > Let me know your intension in more detail.
> > 
> > Please express yours.  Why do you feel you need these to be ioctls?
> > What exactly are they doing?  Where is the documentation for them all?

You forgot to answer this.

> > > > And are they 32/64bit safe?
> > > Only 32bit support.
> > 
> > That's an obvious problem that needs to be resolved, right?
> The Tunnelcreak processor (A kind of Atom-based processor) only
> supports 32b, so PCH drivers only support 32b.
> They can make it 32/64 compatible, but it's difficult to test them,
> because there're no 64b Atom-based platform have those PCH devices.

But that does not mean you should not be using the proper types and
other things necessary for proper ioctl usage.

As you failed to describe what any of these ioctls do, I can't recommend
that you have any of them in the driver.

sorry,

greg k-h

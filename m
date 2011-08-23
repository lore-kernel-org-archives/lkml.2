Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1HWPkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:40:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1HWPkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:40:02 -0400
Date: Tue, 23 Aug 2011 08:32:43 -0700
From: Greg KH <gregkh@suse.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110823153243.GB25968@suse.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
 <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
 <4E4937A4.5070204@linutronix.de>
 <CACxGe6sAOYf3r4i1no=+-RgTLuiRbxYkcy+9VFXaCZOXUOi_uw@mail.gmail.com>
 <20110822214154.GB20451@xanatos>
 <20110822215151.GA18397@suse.de>
 <20110823095036.GA23284@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823095036.GA23284@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 11:50:36AM +0200, Sebastian Andrzej Siewior wrote:
> * Greg KH | 2011-08-22 14:51:51 [-0700]:
> 
> >> Greg, do you want to take this patch through your driver core tree, or
> >> would you prefer to have it come through the xHCI tree?
> >
> >I'll take it in my driver-core tree separate, as the others don't depend
> >on this one, right?
> 
> Should the xhci series hit Linus' tree before your driver-core than
> rmmod of the xhci-pci driver will lead to a crash.

That's ok, just don't do that :)

And you can tell me to merge stuff with Linus after one of my other
trees is applied, I can do that as well.

greg k-h

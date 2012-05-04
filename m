Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab2EDWPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:15:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab2EDWPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:15:38 -0400
Date: Fri, 4 May 2012 15:15:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: balbi@ti.com, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
Message-ID: <20120504221534.GA16430@kroah.com>
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
 <4F91D9D9.6020609@xenotime.net>
 <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
 <20120421153402.GA22953@kroah.com>
 <20120422190136.GA31242@linutronix.de>
 <1336102463.22393.121.camel@haakon2.linux-iscsi.org>
 <20120504094141.GC1156@arwen.pp.htv.fi>
 <1336150599.22393.298.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336150599.22393.298.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 09:56:39AM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2012-05-04 at 12:41 +0300, Felipe Balbi wrote:
> > Hi,
> > 
> 
> <SNIP>
> 
> > > 
> > > After the recommended change, the in-kernel config using a single gadget
> > > driver (the target) are able to build.  Thanks for the detailed
> > > explanation btw.. ;)
> > > 
> > > I've made the same change for tcm_usb_gadget in lio-core, and updated
> > > for-next-merge with the following merge patch:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commit;h=0c41520201bc0933d65b8644173802778f426234
> > > 
> > > Please let me know if you have any other changes that should go into
> > > sunday's linux-next build.
> > 
> > It looks ok to me. You can add my Acked-by: Felipe Balbi <balbi@ti.com>
> > 
> 
> Thanks Felipe!
> 
> So with your Ack in place and if there are no more objections, the plan
> is now to take tcm_usb_gadget through target-pending/for-next-merge
> (along with sbp-target) for an initial upstream merge.
> 
> Also, I'm fine if USB folks would prefer to take this via their tree
> now that the gadget target is residing within drivers/usb/gadget/, but
> AFAICT this looks harmless enough to merge directly via the target tree.

That's fine with me as well.

greg k-h

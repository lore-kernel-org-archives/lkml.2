Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab2EDQ4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:56:44 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41864 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2EDQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:56:42 -0400
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: balbi@ti.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org
In-Reply-To: <20120504094141.GC1156@arwen.pp.htv.fi>
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
	 <4F91D9D9.6020609@xenotime.net>
	 <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
	 <20120421153402.GA22953@kroah.com> <20120422190136.GA31242@linutronix.de>
	 <1336102463.22393.121.camel@haakon2.linux-iscsi.org>
	 <20120504094141.GC1156@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 May 2012 09:56:39 -0700
Message-ID: <1336150599.22393.298.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 12:41 +0300, Felipe Balbi wrote:
> Hi,
> 

<SNIP>

> > 
> > After the recommended change, the in-kernel config using a single gadget
> > driver (the target) are able to build.  Thanks for the detailed
> > explanation btw.. ;)
> > 
> > I've made the same change for tcm_usb_gadget in lio-core, and updated
> > for-next-merge with the following merge patch:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commit;h=0c41520201bc0933d65b8644173802778f426234
> > 
> > Please let me know if you have any other changes that should go into
> > sunday's linux-next build.
> 
> It looks ok to me. You can add my Acked-by: Felipe Balbi <balbi@ti.com>
> 

Thanks Felipe!

So with your Ack in place and if there are no more objections, the plan
is now to take tcm_usb_gadget through target-pending/for-next-merge
(along with sbp-target) for an initial upstream merge.

Also, I'm fine if USB folks would prefer to take this via their tree
now that the gadget target is residing within drivers/usb/gadget/, but
AFAICT this looks harmless enough to merge directly via the target tree.

Thanks again for your review,

--nab


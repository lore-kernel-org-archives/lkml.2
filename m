Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1G1WUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:20:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59580 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1G1WUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:20:38 -0400
Date: Thu, 28 Jul 2011 16:20:35 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org, Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v3 0/2] Simple irq_domain implementation
Message-ID: <20110728222035.GE4674@ponder.secretlab.ca>
References: <20110726093141.12508.48108.stgit@ponder>
 <alpine.LFD.2.02.1107281127040.2660@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107281127040.2660@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:31:03AM +0200, Thomas Gleixner wrote:
> On Tue, 26 Jul 2011, Grant Likely wrote:
> 
> > In the interest of getting this infrastructure merged, I've reworked the
> > basic irq_domain patch to implement only what is required for ARM device
> > tree board support.  That means it doesn't affect any architectures other
> > than ARM, and I'll send follow-on patches targeted at v3.2 to migrate
> > MIPS, Microblaze, x86 embedded and PowerPC over to it.
> 
> There is also this GPIO driver pending for quite some time ...
>  
> > Thomas, can you please take a look?  I've got devicetree board support
> > queued up and ready to be merged but for this infrastructure.
> 
> Looks reasonable, please merge them through your tree.
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Thanks,
> 
> 	tglx

Thanks Thomas.  Arnd has sent it as part of his DT board support pull
req to Linus.

g.

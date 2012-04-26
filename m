Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab2DZUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:25:56 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:34007 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2DZUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:25:55 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8OsQsE9PpEYX2TE3bP2DW
Date: Thu, 26 Apr 2012 13:25:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@ti.com>
Cc: NeilBrown <neilb@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC
 interrupts.
Message-ID: <20120426202539.GA3739@atomide.com>
References: <20120425025637.7832.14013.stgit@notabene.brown>
 <20120425030524.7832.52047.stgit@notabene.brown>
 <87sjfq9ryv.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjfq9ryv.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@ti.com> [120426 13:11]:
> NeilBrown <neilb@suse.de> writes:
> 
> > All interrupts can wake-from-sleep (I think) so it should be
> > permissible to call enable_irq_wake().  Setting this flag allows that.
> >
> > It is needed because without this, an interrupt which is delivered
> > during late suspend will get ignored but will not cause suspend to
> > abort.
> > If enable_irq_wake() is called and succeeds, check_wakuep_irqs()
> > will abort the suspend if the interrupt has fired.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Acked-by: Kevin Hilman <khilman@ti.com>
> 
> Tony, should I queue this one in my OMAP PM features for v3.5 branch?
> or do you want to take it?

You can take it since is's PM related.

Tony

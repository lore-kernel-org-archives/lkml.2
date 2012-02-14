Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2BNVBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:01:52 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:15467 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab2BNVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:01:51 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18nOiY6DtL+8sm4h9WgsGs5
Date: Tue, 14 Feb 2012 13:01:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, Anders Kaseorg <andersk@ksplice.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-omap@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] modpost: Fix section warnings for ARM for many
 compilers
Message-ID: <20120214210143.GW1426@atomide.com>
References: <20120213212401.GH1426@atomide.com>
 <20120213222652.GL14173@pengutronix.de>
 <20120213225118.GC31482@n2100.arm.linux.org.uk>
 <878vk6cl5z.fsf@rustcorp.com.au>
 <20120214011228.GM1426@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120214011228.GM1426@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [120213 16:41]:
> * Rusty Russell <rusty@rustcorp.com.au> [120213 16:07]:
> > On Mon, 13 Feb 2012 22:51:18 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > On Mon, Feb 13, 2012 at 11:26:52PM +0100, Uwe Kleine-König wrote:
> > > > On Mon, Feb 13, 2012 at 01:24:01PM -0800, Tony Lindgren wrote:
> > > > Maybe:
> > > > 
> > > > #ifndef R_ARM_CALL
> > > > #warning "you're elf.h include is outdated"
> > > 
> > > "You are elf.h include is outdated" does not make sense.
> > > 
> > > Why are you calling Tony an elf.h include?
> > 
> > Because he knew it would attract the attention of pedants to the patch?
> > :)
> 
> I've been called worse than that :)
>  
> > Just do the #ifndef, and skip the warning.  There's not much the poor
> > user receiving the warning can do about it.
> 
> OK
>  
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Assuming your ack applies for this patch below, let me know if that's
> not the case.  

This is now in Russell's patch tracking system as patch 7324/1.

Tony

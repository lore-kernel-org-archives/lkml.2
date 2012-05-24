Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab2EXCMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:12:17 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60736 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab2EXCMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:12:16 -0400
X-Sasl-enc: ljdyX9+exMQkdGRasggBzQ3FeubzbHJjNTAsElQQBp+o 1337825534
Date: Wed, 23 May 2012 19:12:08 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay@vrfy.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Excessive latency for dev_dbg?
Message-ID: <20120524021208.GA12557@kroah.com>
References: <Pine.LNX.4.44L0.1205231627140.1248-100000@iolanthe.rowland.org>
 <1337805903.1747.0.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337805903.1747.0.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 01:45:03PM -0700, Joe Perches wrote:
> cc'ing Kay.
> 
> On Wed, 2012-05-23 at 16:37 -0400, Alan Stern wrote:
> > I just tried doing some testing of 3.4.  Sequences of literally
> > adjacent dev_dbg() calls -- with local interrupts disabled -- show up
> > in the log buffer spaced at time intervals between 1 and 4
> > milliseconds!
> > 
> > This is with CONFIG_DYNAMIC_DEBUG not enabled, and CONFIG_PRINTK_TIME,
> > CONFIG_PREEMPT, CONFIG_HIGH_RES_TIMERS, and CONFIG_HPET_TIMER all set
> > to y.
> > 
> > What's going on here?  Did printk suddenly slow down a lot?  Or has the
> > timer code gone crazy?

Joe, why ask Kay?  He didn't touch this code until 3.5-rc1, and Alan is
testing 3.4.

confused,

greg k-h

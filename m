Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab2EWUpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:45:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58809 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758666Ab2EWUpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:45:05 -0400
Message-ID: <1337805903.1747.0.camel@joe2Laptop>
Subject: Re: Excessive latency for dev_dbg?
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay@vrfy.org>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <greg@kroah.com>
Date: Wed, 23 May 2012 13:45:03 -0700
In-Reply-To: <Pine.LNX.4.44L0.1205231627140.1248-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1205231627140.1248-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Kay.

On Wed, 2012-05-23 at 16:37 -0400, Alan Stern wrote:
> I just tried doing some testing of 3.4.  Sequences of literally
> adjacent dev_dbg() calls -- with local interrupts disabled -- show up
> in the log buffer spaced at time intervals between 1 and 4
> milliseconds!
> 
> This is with CONFIG_DYNAMIC_DEBUG not enabled, and CONFIG_PRINTK_TIME,
> CONFIG_PREEMPT, CONFIG_HIGH_RES_TIMERS, and CONFIG_HPET_TIMER all set
> to y.
> 
> What's going on here?  Did printk suddenly slow down a lot?  Or has the
> timer code gone crazy?



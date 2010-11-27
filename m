Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0K0DMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 22:12:05 -0500
Received: from jdl.com ([208.123.74.7]:52900 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0K0DME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 22:12:04 -0500
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/11] x86/dtb: add irq host abstraction 
In-reply-to: <4CEFC1EC.7030507@linutronix.de> 
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-5-git-send-email-bigeasy@linutronix.de> <E1PLhWV-0004y7-44@jdl.com> <4CEFC1EC.7030507@linutronix.de>
Comments: In-reply-to Sebastian Andrzej Siewior <bigeasy@linutronix.de>
   message dated "Fri, 26 Nov 2010 15:19:24 +0100."
Date: Fri, 26 Nov 2010 21:11:52 -0600
From: Jon Loeliger <jdl@jdl.com>
Message-Id: <E1PMBCa-0007l1-1V@jdl.com>
X-Spam-Score: -1.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jon Loeliger wrote:
> 
> >> +struct irq_host {
> >> +	int (*xlate)(struct irq_host *h, const u32 *intspec, u32 intsize,
> >> +			u32 *out_hwirq, u32 *out_type);
> >> +	void *priv;
> >> +	struct device_node *controller;
> >> +	struct list_head l;
> >> +};
> > 
> > I thought there was an intent and desire to rename the irq_host
> > as irq_domain.
> > 
> > jdl
> 
> AFAIK Benh was thinking about renaming it. I don't know if this is
> still the case or when he intends to do so.

I submitted a first version of that patch already.
I thought we were waiting on gkh's patches to go upstream
before re-submitting the next version of that patch.
If we're ready to proceed with that, we can rebase it
and re-submit it too.

> Once he does so, this can be renamed as well.

Hrm.  Well, let's ask Ben what order he wants to do...?

jdl

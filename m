Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab1EZUGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:06:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49212 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab1EZUGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:06:06 -0400
Date: Thu, 26 May 2011 14:06:03 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH 1/2] x86/dtb: make irq host list accessible
Message-ID: <20110526200603.GB29060@ponder.secretlab.ca>
References: <20110427143423.GB15211@linutronix.de>
 <20110429222600.GJ7497@ponder.secretlab.ca>
 <20110430090218.GA24750@linutronix.de>
 <20110502215936.GG10097@ponder.secretlab.ca>
 <4DD3A3DE.40501@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD3A3DE.40501@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:47:58PM +0200, Sebastian Andrzej Siewior wrote:
> Grant Likely wrote:
> >>This patch should be obsolete with of_irq_domain beeing generic now.
> >>Could you please take look at the gpio driver? If there is nothing
> >>obvious wrong I would rework it to work with of_irq_domain() and
> >>repost.
> >
> >okay, will do.
> 
> Ping :)

The of_irq_domain patches needed heavy rework after review, and the
rework didn't happen until late last night.  Unfortunately that means
I also didn't get a change to look at the gpio driver, and so it won't
make it into $NEXT_KERNEL (entirely my fault, and I'm sorry).

However, I do hope that the new irq_domain will get finalized quickly
so that I can pick up your patches early in $NEXT_KERNEL stabilization
cycle.

g.


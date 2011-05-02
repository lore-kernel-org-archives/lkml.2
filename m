Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab1EBV7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:59:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43426 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab1EBV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:59:38 -0400
Date: Mon, 2 May 2011 15:59:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH 1/2] x86/dtb: make irq host list accessible
Message-ID: <20110502215936.GG10097@ponder.secretlab.ca>
References: <20110427143423.GB15211@linutronix.de>
 <20110429222600.GJ7497@ponder.secretlab.ca>
 <20110430090218.GA24750@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430090218.GA24750@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 11:02:18AM +0200, Sebastian Andrzej Siewior wrote:
> * Grant Likely | 2011-04-29 16:26:00 [-0600]:
> 
> >On Wed, Apr 27, 2011 at 04:34:23PM +0200, Sebastian Andrzej Siewior wrote:
> >> From: Torben Hohn <torbenh@linutronix.de>
> >> 
> >> There is an gpio irq chip comming which needs this from the outside.
> >> There is no EXPORT_SYMBOL because this does not yet work in modules.
> >> 
> >Can you rework this to sit on top of the of_irq_domain series I sent
> >out yesterday?  I *really* hope to get of_irq_domain merged into .40,
> >but this change would conflict.
> 
> This patch should be obsolete with of_irq_domain beeing generic now.
> Could you please take look at the gpio driver? If there is nothing
> obvious wrong I would rework it to work with of_irq_domain() and
> repost.

okay, will do.

g.


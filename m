Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0IWRwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:52:44 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:61971 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0IWRwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:52:43 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Xd+PHw732gttU1yIOmmon
Date: Thu, 23 Sep 2010 10:52:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] omap3: make coresight register save across OFF
 modes a sysfs option
Message-ID: <20100923175227.GO4211@atomide.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
 <1280077520-7538-8-git-send-email-virtuoso@slind.org>
 <20100806123711.GI28519@shisha.kicks-ass.net>
 <20100806124726.GN23778@atomide.com>
 <4C8209E2.3080803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8209E2.3080803@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cousson, Benoit <b-cousson@ti.com> [100904 01:49]:
> 
> These patches are still using static virtual to physical mapping in
> io.h,  shouldn't we take the opportunity of this series to fix that
> and use ioremap instead?

Hmm, well the amba device should ioremap, but we need the virt address
for sleep34xx.S also. So to me it seems like we're missing the static
ioremap entries for plat-omap/io.c for the virtual addresses.

Alexander, can you please check that and repost the remaining
three patches one more time?

Thanks,

Tony

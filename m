Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198Ab0HFMrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:47:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56270 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0HFMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:47:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18D43bzcEblOC2YvDGVoN4m
Date: Fri, 6 Aug 2010 15:47:26 +0300
From: Tony Lindgren <tony@atomide.com>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] omap3: make coresight register save across OFF
 modes a sysfs option
Message-ID: <20100806124726.GN23778@atomide.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
 <1280077520-7538-8-git-send-email-virtuoso@slind.org>
 <20100806123711.GI28519@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806123711.GI28519@shisha.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Shishkin <virtuoso@slind.org> [100806 15:30]:
> On Sun, Jul 25, 2010 at 08:05:20 +0300, Alexander Shishkin wrote:
> > This adds a sysfs file at /sys/power/coresight_save which is used to
> > control if the ETM and debug components' states should be saved and
> > restored across OFF modes.
> 
> The non-omap patches are merged to Russell's tree, so these three are
> the only remaining.
> 
> This one won't apply to linux-omap master any more because of the pm44xx
> in the makefile, but should be ok otherwise. It would still apply to
> linus' tree.
> 
> So, should I rediff it, resend it or just drop it, because it's not needed?

Patches look OK to me.

Care to refresh and repost the remaining ones one more time to avoid
confusion about which ones remain?

Are you OK if we merge these in the next merge window after this?

I'd rather have these sitting in linux-omap tree for a while first
before we merge them so we can be sure they won't break the idle
code..

Regards,

Tony

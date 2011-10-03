Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1JCSGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:06:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53852 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab1JCSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:06:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19jCeq/umieC/hDuYIOaAFQ
Date: Mon, 3 Oct 2011 11:06:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/30] ARM: omap2+: fix omap_hdq_init compilation
Message-ID: <20111003180624.GX6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-14-git-send-email-arnd@arndb.de>
 <4E8943EA.5060205@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8943EA.5060205@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [111002 21:37]:
> On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> > The definition of the device must depend on the hardware
> > we run on, not on the kernel configuration.
> > 
> > arch/arm/mach-omap2/devices.c:624:13: error: 'OMAP_HDQ_BASE' undeclared here (not in a function)
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

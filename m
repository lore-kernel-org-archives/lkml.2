Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1JCSDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:03:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35651 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932293Ab1JCSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:03:12 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19PsW5uyNC97vCTjU0y4FQM
Date: Mon, 3 Oct 2011 11:03:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/30] ARM: omap2/n8x0: work around modular omap mmc
Message-ID: <20111003180305.GV6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-12-git-send-email-arnd@arndb.de>
 <20111002155331.GA12323@n2100.arm.linux.org.uk>
 <1412062.DNcqS3fczZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412062.DNcqS3fczZ@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111002 11:22]:
> On Sunday 02 October 2011 16:53:31 Russell King - ARM Linux wrote:
> > On Sun, Oct 02, 2011 at 04:45:41PM +0200, Arnd Bergmann wrote:
> > > -#if defined(CONFIG_MENELAUS) &&                                              \
> > > -     (defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE))
> > > +#if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)
> > > +/* || defined(CONFIG_MMC_OMAP_MODULE)) */
> > > +/* FIXME: cannot call omap_mmc_notify_cover_event for ONFIG_MMC_OMAP_MODULE */
> > 
> > #ifdef CONFIG_MMC_OMAP_MODULE
> > #warning FIXME: cannot call omap_mmc_notify_cover_event for CONFIG_MMC_OMAP_MODULE
> > #endif
> > #if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)
> > 
> > So that it can be seen at build time?
> > 
> > Also note the 'ONFIG' typo...
> 
> Ok, good idea. I've updated the patch in the git tree accordingly.

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Depending on what Tony wants, I might send out the entire series
> again once there are no more new comments.

Up to you, I usually prefer to see just updated patches as long
as the mail thread stays readable.

Regards,

Tony

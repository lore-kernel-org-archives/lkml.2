Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1IVWv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:51:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51651 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1IVWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:51:25 -0400
X-Greylist: delayed 1564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 18:51:25 EDT
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mJu6SHARo4C4vJLJcGyOy
Date: Thu, 22 Sep 2011 15:25:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Abhilash K V <abhilash.kv@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com,
        christian.gmeiner@gmail.com, santosh.shilimkar@ti.com, premi@ti.com,
        david.woodhouse@intel.com
Subject: Re: [PATCH v3 3/3] OMAP3: Remove auto-selection of PMICs
Message-ID: <20110922222517.GX2937@atomide.com>
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-2-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-3-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-4-git-send-email-abhilash.kv@ti.com>
 <877h50qlne.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877h50qlne.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@ti.com> [110922 14:30]:
> Abhilash K V <abhilash.kv@ti.com> writes:
> 
> > The current implementation almost assumes that only
> 
> almost?  ;)
> 
> > TWL4030/TWL5030/TWl6030 are (or can be) used with the
> > OMAP processors. This is, however, not true.
> >
> > This patch removes the automatic selection of the PMIC
> > from Kconfig.
> > All currently used PMICs are now added to omap2plus_defconfig;
> 
> I don't think adding them to omap2plus_defconfig is right either, as
> those will get stripped out the next time that file is (re)generated.
> 
> > any new PMIC that gets supported in future could now be
> > enabled here rather than by changing Kconfig for
> > ARCH_OMAP2PLUS_TYPICAL
> 
> IMO, the right fix is to have the board Kconfig entries select the PMIC
> being used on those boards.  That is the only solution that will scale,
> and also work when using 'make randconfig'.

Agreed.

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032002Ab2COROK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:14:10 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:57519 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161170Ab2COROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:14:05 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19DqRZYwVGCqkWIBCkal5R5
Date: Thu, 15 Mar 2012 10:14:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: jean.pihet@newoldbits.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 02/10] ARM: OMAP2+: SmartReflex: move the platform
 specific macros in plat-omap
Message-ID: <20120315171359.GA7276@atomide.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
 <1331829845-9526-3-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331829845-9526-3-git-send-email-j-pihet@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> [120315 09:47]:
> From: Jean Pihet <j-pihet@ti.com>
> 
> Move the platform specific macros from the smartreflex header file
> (arch/arm/mach-omap2/smartreflex.h) in a new header file in plat-omap
> (arch/arm/plat-omap/include/plat/smartreflex.h).
> 
> This change makes the SmartReflex implementation ready for the move
> to drivers/.

Glad to see this happening!

This would be better located in linux/power/smartreflex.h rather than
plat/smartreflex.h.

Regards,

Tony

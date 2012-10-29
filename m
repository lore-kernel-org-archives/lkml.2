Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab2J2Rwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:52:41 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:37801 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759689Ab2J2Rwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:52:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zeRqhVTXV865ke2W2kwwF
Date: Mon, 29 Oct 2012 10:52:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap
 headers
Message-ID: <20121029175228.GD11908@atomide.com>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
 <1351530381-11459-2-git-send-email-omar.luna@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351530381-11459-2-git-send-email-omar.luna@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> --- /dev/null
> +++ b/include/linux/platform_data/omap_mailbox.h
> @@ -0,0 +1,105 @@

This file should only contain pure platform data needed
by the core omap code to pass to the mailbox driver.

The mailbox API header should be somewhere else,
like include/linux/mailbox/mailbox-omap.h or similar.

But shouldn't this all now be handled by using the
remoteproc framework?

Regards,

Tony

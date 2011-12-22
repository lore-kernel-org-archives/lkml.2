Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab1LVSXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:23:19 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22778 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751671Ab1LVSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:23:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Yqdlt7jIYqcI2NjTurOCG
Date: Thu, 22 Dec 2011 10:23:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/10] arm: omap2: fix regulator warnings
Message-ID: <20111222182313.GP24444@atomide.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-5-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324341747-5922-5-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [111219 16:11]:
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MACH_OMAP_4430SDP && MACH_OMAP4_PANDA && TPS6105X) selects REGULATOR_FIXED_VOLTAGE which has unmet direct dependencies (REGULATOR)

Thanks applying into fixes-non-critical-part3.

Tony

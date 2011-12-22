Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1LVUpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:45:51 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14450 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1LVUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:45:49 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2KNgA78PR1pdYQ+LD8jfa
Date: Thu, 22 Dec 2011 12:45:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/10] arm: omap4: fix kconfig warning
Message-ID: <20111222204545.GT24444@atomide.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-2-git-send-email-felipe.contreras@gmail.com>
 <20111222182240.GN24444@atomide.com>
 <CAMP44s2MfdS-woETebYsTHEPZsBuBpP2dfmfBibC+JWZZ2iLKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2MfdS-woETebYsTHEPZsBuBpP2dfmfBibC+JWZZ2iLKQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [111222 11:37]:
> On Thu, Dec 22, 2011 at 8:22 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Felipe Contreras <felipe.contreras@gmail.com> [111219 16:11]:
> >> warning: (ARCH_OMAP4 && ARCH_VEXPRESS_CA9X4) selects ARM_ERRATA_720789 which has unmet direct dependencies (CPU_V7 && SMP)
> >
> > Thanks applying into fixes-non-critical-part3.
> 
> Actually, please disregard this one, it should be handled by this:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/141942

OK dropping.

Tony

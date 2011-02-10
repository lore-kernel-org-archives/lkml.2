Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1BJDOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:14:34 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55461 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1BJDOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:14:32 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19l2ue1Q8ocNe5Mdg9HyvSS
Date: Wed, 9 Feb 2011 19:13:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Julia Lawall <julia@diku.dk>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/w1/masters/omap_hdq.c: Add missing clk_put
Message-ID: <20110210031358.GJ20795@atomide.com>
References: <1296754667-18049-1-git-send-email-julia@diku.dk>
 <20110207075933.GA2723@matterhorn.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207075933.GA2723@matterhorn.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Amit Kucheria <amit.kucheria@canonical.com> [110206 23:58]:
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Makes the code easier to read.
> 
> Acked-by: Amit Kucheria <amit.kucheria@canonical.com>

Acked-by: Tony Lindgren <tony@atomide.com>

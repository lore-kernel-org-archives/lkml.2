Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2FNItO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:49:14 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:32690
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab2FNItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:49:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzzz2dh87h2a8h668h839h944hd25he96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 14 Jun 2012 16:49:06 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
CC: Mike Turquette <mturquette@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <mturquette@linaro.org>, <s.hauer@pengutronix.de>,
        <sboyd@codeaurora.org>, Grant Likely <grant.likely@secretlab.ca>,
        <skannan@codeaurora.org>
Subject: Re: [PATCH v3 0/4] DT clock bindings
Message-ID: <20120614084904.GF31565@S2101-09.ap.freescale.net>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
 <20120612154735.GB19410@gmail.com>
 <4FD76CF6.8090801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FD76CF6.8090801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:23:18AM -0500, Rob Herring wrote:
> Right. This is why I have reposted and copied those whom commented on my
> pull request. I think at least some of Saravana's concerns boiled down
> to not requiring using DT clock bindings and not requiring driver
> changes to move to DT bindings. Both of these are met with this series.
> A platform can still use clkdev tables for binding clocks to devices and
> does not have to use DT for clocks. Drivers generally should not require
> any changes that I'm aware of, but if there are any concrete examples
> I'd like to know.
> 
> Yes, I think this should go thru you.
> 
I still have a little doubt about how this binding will best work for
imx clock.  I'm trying to cook a RFC patch discussing.

-- 
Regards,
Shawn


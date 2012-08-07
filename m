Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2HGMCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:02:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11408 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2HGMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:02:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19kHjsoUb01MYrhqywn0pek
Date: Tue, 7 Aug 2012 05:02:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: In case of dma errors fall back to
 pio
Message-ID: <20120807120227.GA11011@atomide.com>
References: <1343197229-15188-1-git-send-email-shubhrajyoti@ti.com>
 <20120807074740.GR11011@atomide.com>
 <5020FA2C.2020707@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020FA2C.2020707@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shubhrajyoti <shubhrajyoti@ti.com> [120807 04:21]:
> On Tuesday 07 August 2012 01:17 PM, Tony Lindgren wrote:
> >>  };
> > Don't you need to check separately for rx and tx dma? There's a slight
> > chance that you get a channel for one but not for the other..
> In that case I treat it as non usable and fall back to pio.

OK that should work too.
 
> Are you suggesting that let one channel be dma and only the failed one pio?

I guess both are doable. For reduced CPU load using DMA where possible
of course is the best way to go.

Tony

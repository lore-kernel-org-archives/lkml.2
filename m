Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2CZOnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:43:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47498 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932684Ab2CZOnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:43:12 -0400
Date: Mon, 26 Mar 2012 16:43:08 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Axel Lin <axel.lin@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Ralf Baechle <ralf@linux-mips.org>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Make TXX9_WDT select WATCHDOG_CORE
Message-ID: <20120326144308.GA9602@spo001.leaseweb.com>
References: <1332739713.15735.1.camel@phoenix> <20120326063956.GB24023@pengutronix.de> <CAF+7xW=TRcW_2AFtDHBP4Dw3QBf0_mvecMO3g+Hqsk1xV8UC9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xW=TRcW_2AFtDHBP4Dw3QBf0_mvecMO3g+Hqsk1xV8UC9Q@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

> > Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> >
> > Can we simply fold this into the original patch?
> Wim already applied the original patch.
> I found this build error while compiling with today's linux-next.
> So I think this need to be a separate patch.

I folded this into the original patch.

Can you test what is in linux-watchdog-next now?

Thanks,
Wim.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0HTImT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:42:19 -0400
Received: from smtp.nokia.com ([192.100.122.233]:17571 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0HTImR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:42:17 -0400
Subject: Re: [PATCHv2 2/2] omap: rx51: add support for USB chargers
From: Ameya Palande <ameya.palande@nokia.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
Cc: ext Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        "Lehtonen Markus (Nokia-MS/Helsinki)" <markus.lehtonen@nokia.com>,
        "Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
        Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100819130937.GC4363@esdhcp041123.research.nokia.com>
References: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
	 <1282219777-17657-3-git-send-email-ext-heikki.krogerus@nokia.com>
	 <20100819124042.GA15837@oksana.dev.rtsoft.ru>
	 <20100819130937.GC4363@esdhcp041123.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Fri, 20 Aug 2010 11:41:51 +0300
Message-ID: <1282293711.1925.32.camel@chotu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2010 08:42:00.0123 (UTC) FILETIME=[8E19C0B0:01CB4043]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

On Thu, 2010-08-19 at 15:09 +0200, Krogerus Heikki (EXT-Teleca/Helsinki)
wrote:
> On Thu, Aug 19, 2010 at 02:40:42PM +0200, ext Anton Vorontsov wrote:
> > On Thu, Aug 19, 2010 at 03:09:37PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> >> @@ -909,5 +913,6 @@ void __init rx51_peripherals_init(void)
> >>  	spi_register_board_info(rx51_peripherals_spi_board_info,
> >>  				ARRAY_SIZE(rx51_peripherals_spi_board_info));
> >>  	omap2_hsmmc_init(mmc);
> >> +	platform_device_register(&rx51_charger_device);
> > 
> > Maybe
> > 
> >   platform_device_register_simple("isp1704_charger", -1, NULL, 0);
> 
> I guess it's enough in this case. Ameya, Roger, any objections?

Yes, I would have preferred "platform_device_register_simple" instead of
"platform_device_register", but doesn't matter now ;)

Cheers,
Ameya.


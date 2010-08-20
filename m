Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab0HTHZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:25:31 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60189 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0HTHZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:25:29 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gQQHHhENsAJoBNyeKG+8U
Date: Fri, 20 Aug 2010 10:25:26 +0300
From: Tony Lindgren <tony@atomide.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        "Palande Ameya (Nokia-MS/Helsinki)" <ameya.palande@nokia.com>,
        "Lehtonen Markus (Nokia-MS/Helsinki)" <markus.lehtonen@nokia.com>,
        Roger Quadros <roger.quadros@nokia.com>
Subject: Re: [PATCHv2 2/2] omap: rx51: add support for USB chargers
Message-ID: <20100820072525.GJ25742@atomide.com>
References: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
 <1282219777-17657-3-git-send-email-ext-heikki.krogerus@nokia.com>
 <20100819124042.GA15837@oksana.dev.rtsoft.ru>
 <20100819130937.GC4363@esdhcp041123.research.nokia.com>
 <4C6D3EED.7040703@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6D3EED.7040703@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Roger Quadros <roger.quadros@nokia.com> [100819 17:17]:
> On 08/19/2010 04:09 PM, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> >On Thu, Aug 19, 2010 at 02:40:42PM +0200, ext Anton Vorontsov wrote:
> >>On Thu, Aug 19, 2010 at 03:09:37PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> >>>@@ -909,5 +913,6 @@ void __init rx51_peripherals_init(void)
> >>>  	spi_register_board_info(rx51_peripherals_spi_board_info,
> >>>  				ARRAY_SIZE(rx51_peripherals_spi_board_info));
> >>>  	omap2_hsmmc_init(mmc);
> >>>+	platform_device_register(&rx51_charger_device);
> >>
> >>Maybe
> >>
> >>   platform_device_register_simple("isp1704_charger", -1, NULL, 0);
> >
> >I guess it's enough in this case. Ameya, Roger, any objections?
> >
> I'm fine with the current approach. No need to re-spin.

Just checking.. Anton, can you please queue up this 2/2 patch too to
keep them together? Here's my ack:

Acked-by: Tony Lindgren <tony@atomide.com>

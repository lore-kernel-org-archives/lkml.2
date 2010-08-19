Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0HSNKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:10:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58487 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0HSNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:10:19 -0400
Date: Thu, 19 Aug 2010 16:09:37 +0300
From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
To: ext Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        "Palande Ameya (Nokia-MS/Helsinki)" <ameya.palande@nokia.com>,
        "Lehtonen Markus (Nokia-MS/Helsinki)" <markus.lehtonen@nokia.com>,
        "Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv2 2/2] omap: rx51: add support for USB chargers
Message-ID: <20100819130937.GC4363@esdhcp041123.research.nokia.com>
References: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
 <1282219777-17657-3-git-send-email-ext-heikki.krogerus@nokia.com>
 <20100819124042.GA15837@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819124042.GA15837@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Aug 2010 13:09:45.0526 (UTC) FILETIME=[CB69F560:01CB3F9F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:40:42PM +0200, ext Anton Vorontsov wrote:
> On Thu, Aug 19, 2010 at 03:09:37PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
>> @@ -909,5 +913,6 @@ void __init rx51_peripherals_init(void)
>>  	spi_register_board_info(rx51_peripherals_spi_board_info,
>>  				ARRAY_SIZE(rx51_peripherals_spi_board_info));
>>  	omap2_hsmmc_init(mmc);
>> +	platform_device_register(&rx51_charger_device);
> 
> Maybe
> 
>   platform_device_register_simple("isp1704_charger", -1, NULL, 0);

I guess it's enough in this case. Ameya, Roger, any objections?

-- 
heikki

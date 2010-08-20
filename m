Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0HTQYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:24:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58688 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0HTQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f7xkV8CYdwoq111b8caGGl6/yOdhwV4j6wBRZqMw6gvt14c2usYWlQM3gKX8Dblm+h
         uSKWA6n783xzWbzRDf7o3occ/R8Mr7NnMsshckJPWFyMIhsnvdh3r8q1M7wvFDT6vbh+
         AahePnc9W344GdwV3EPhM2mY7i4eLSa/rTXe0=
Date: Fri, 20 Aug 2010 20:24:40 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tony Lindgren <tony@atomide.com>
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
Message-ID: <20100820162440.GA31661@oksana.dev.rtsoft.ru>
References: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
 <1282219777-17657-3-git-send-email-ext-heikki.krogerus@nokia.com>
 <20100819124042.GA15837@oksana.dev.rtsoft.ru>
 <20100819130937.GC4363@esdhcp041123.research.nokia.com>
 <4C6D3EED.7040703@nokia.com>
 <20100820072525.GJ25742@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100820072525.GJ25742@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:25:26AM +0300, Tony Lindgren wrote:
> Hi,
> 
> * Roger Quadros <roger.quadros@nokia.com> [100819 17:17]:
> > On 08/19/2010 04:09 PM, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> > >On Thu, Aug 19, 2010 at 02:40:42PM +0200, ext Anton Vorontsov wrote:
> > >>On Thu, Aug 19, 2010 at 03:09:37PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> > >>>@@ -909,5 +913,6 @@ void __init rx51_peripherals_init(void)
> > >>>  	spi_register_board_info(rx51_peripherals_spi_board_info,
> > >>>  				ARRAY_SIZE(rx51_peripherals_spi_board_info));
> > >>>  	omap2_hsmmc_init(mmc);
> > >>>+	platform_device_register(&rx51_charger_device);
> > >>
> > >>Maybe
> > >>
> > >>   platform_device_register_simple("isp1704_charger", -1, NULL, 0);
> > >
> > >I guess it's enough in this case. Ameya, Roger, any objections?
> > >
> > I'm fine with the current approach. No need to re-spin.
> 
> Just checking.. Anton, can you please queue up this 2/2 patch too to
> keep them together? Here's my ack:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Sure thing, applied.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0INHBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:01:45 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:60150 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751574Ab0INHBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:01:43 -0400
Date: Tue, 14 Sep 2010 09:00:29 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Maxim Osipov <maxim.osipov@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] AT91: Add flexibity board support
Message-ID: <20100914070029.GG2138@game.jcrosoft.org>
References: <4C8DFA84.4040501@gmail.com>
 <4C8E8F31.2050108@bluewatersys.com>
 <AANLkTi=-n0_uFMKGED-aOtuLEfUyVeMcm5FWX5xM_BT1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=-n0_uFMKGED-aOtuLEfUyVeMcm5FWX5xM_BT1@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2146528172763491298
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:57 Tue 14 Sep     , Maxim Osipov wrote:
> Please see my comments below...
> 
> On Tue, Sep 14, 2010 at 12:53 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> > On 09/13/2010 10:18 PM, Maxim Osipov wrote:
> >
> >> +static void __init flexibity_board_init(void)
> >> +{
> >> +     /* Serial */
> >> +     at91_add_device_serial();
> >> +     /* USB Host */
> >> +     at91_add_device_usbh(&flexibity_usbh_data);
> >> +     /* USB Device */
> >> +     at91_add_device_udc(&flexibity_udc_data);
> >> +     /* SPI */
> >> +     at91_add_device_spi(flexibity_spi_devices,
> >> +             ARRAY_SIZE(flexibity_spi_devices));
> >> +     /* MMC */
> >> +     at91_add_device_mmc(0, &flexibity_mmc_data);
> >> +     /* LEDs */
> >> +     at91_gpio_leds(flexibity_leds, ARRAY_SIZE(flexibity_leds));
> >
> > Can we drop all the comments inside this function please. They don't add
> > any information and they make it harder to read the actual code.
> >
> 
> Ryan, thank you for the review. However I would like to keep these
> comments - for some devices, like UDC - it really provides
> clarification. Reading the code is not a problem with proper
> highlighting scheme.
agreed no need to change

Best Regards,
J.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0INF5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:57:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47378 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0INF52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:57:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JfwrYNPWQfu8m70HN7d0mjiJa1YqzRn+4L1ol3cKlqiUHnfR+yCth6HG0mHgboPrZ2
         DhGOXnuBPM4wGw98BLYfUPwRBc4NRdctmSHPy4OrYUvTUDi+etiqdEM64n/bsJq/n/j1
         djHCUyPod2ItVPLf1thKAtmJWNqY/R+xkCJrs=
MIME-Version: 1.0
In-Reply-To: <4C8E8F31.2050108@bluewatersys.com>
References: <4C8DFA84.4040501@gmail.com>
	<4C8E8F31.2050108@bluewatersys.com>
Date: Tue, 14 Sep 2010 09:57:27 +0400
Message-ID: <AANLkTi=-n0_uFMKGED-aOtuLEfUyVeMcm5FWX5xM_BT1@mail.gmail.com>
Subject: Re: [PATCH v2] AT91: Add flexibity board support
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see my comments below...

On Tue, Sep 14, 2010 at 12:53 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 09/13/2010 10:18 PM, Maxim Osipov wrote:
>
>> +static void __init flexibity_board_init(void)
>> +{
>> +     /* Serial */
>> +     at91_add_device_serial();
>> +     /* USB Host */
>> +     at91_add_device_usbh(&flexibity_usbh_data);
>> +     /* USB Device */
>> +     at91_add_device_udc(&flexibity_udc_data);
>> +     /* SPI */
>> +     at91_add_device_spi(flexibity_spi_devices,
>> +             ARRAY_SIZE(flexibity_spi_devices));
>> +     /* MMC */
>> +     at91_add_device_mmc(0, &flexibity_mmc_data);
>> +     /* LEDs */
>> +     at91_gpio_leds(flexibity_leds, ARRAY_SIZE(flexibity_leds));
>
> Can we drop all the comments inside this function please. They don't add
> any information and they make it harder to read the actual code.
>

Ryan, thank you for the review. However I would like to keep these
comments - for some devices, like UDC - it really provides
clarification. Reading the code is not a problem with proper
highlighting scheme.

Kind regards,
Maxim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1DUO41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:56:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:16433 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab1DUO40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:56:26 -0400
Message-ID: <4DB04588.9000201@atmel.com>
Date: Thu, 21 Apr 2011 16:56:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-at91: gsia18s board improvements and bug fixes
References: <1303291399-4075-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1303291399-4075-1-git-send-email-plyatov@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

Le 20/04/2011 11:23, Igor Plyatov :
> * AT91_PIN_Pxxx port names replaced by human readable GPO_xxxx, GPI_xxxx,
>   GPIO_xxxx names. This simplify source code and schematic maintenance.

Maybe it simplifies schematic reading because the actual cpu pin names
are not indicated on your schematic... But for code, the AT91 pin names
are required, so, no for this part of the patch.
You may know that there is an effort ongoing to minimize the amount of
not needed / duplicated information in the kernel, I am afraid but I
think this renaming is not needed.

Moreover, I think that the "Buttons" part of the file:
arch/arm/mach-at91/include/mach/gsia18s.h
should be removed.

> * Active logic levels and default states corrected for GPOs.

Ok for this.

> * Replace small functions which use platform_register_device() by its direct
>   calls.

Ok for this.

> * Remove GPIO_CARD_UNMOUNT_1 gpio_keys_button, because it not used.

Ok for this.

> * debounce_interval added for critical buttons.

Ok for this.

> * Remove unneeded GPI setup code for buttons, because this done by corresponding
>   driver.

I do not see this, can you elaborate?

> * pcf8574x_0x20_setup() and pcf8574x_0x20_teardown functions small refactoring.

Ok for this.

> Signed-off-by: Igor Plyatov <plyatov@gmail.com>

So, can you please rewrite your patch, we will be pleased to integrate
it in a "fix" update of at91 Linux.

Thanks, best regards,
-- 
Nicolas Ferre


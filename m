Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1HXKLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:11:44 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33254 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab1HXKLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110802095604.GA22637@linux-mips.org>
References: <1312216934-29710-1-git-send-email-paul.gortmaker@windriver.com> <20110802095604.GA22637@linux-mips.org>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 24 Aug 2011 18:11:14 +0800
X-Google-Sender-Auth: t1LnCBbFcf-QTyO9LuczqzNKO-c
Message-ID: <CAK5ve-L+ZZFD3rQMwp638V+NfrHqth2dAXGEeK+iBzFP-EHOzg@mail.gmail.com>
Subject: Re: [PATCH] arm: fix compile failure in orion5x/dns323-setup.c
To: Paul Gortmaker <paul.gortmaker@windriver.com>, rob.herring@calxeda.com,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

I guess you can add your Ack to Paul's patch here.

Arnd, could you please add this patch into your tree, as it's a
obvious right fixing.

Thanks,
-Bryan

On Tue, Aug 2, 2011 at 5:56 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Mon, Aug 01, 2011 at 12:42:14PM -0400, Paul Gortmaker wrote:
>
>> index a6eddae..c105556 100644
>> --- a/arch/arm/mach-orion5x/dns323-setup.c
>> +++ b/arch/arm/mach-orion5x/dns323-setup.c
>> @@ -77,7 +77,7 @@ static int __init dns323_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>>       /*
>>        * Check for devices with hard-wired IRQs.
>>        */
>> -     irq = orion5x_pci_map_irq(const dev, slot, pin);
>> +     irq = orion5x_pci_map_irq(dev, slot, pin);
>
> Very obviously correct ...
>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
>
>  Ralf
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

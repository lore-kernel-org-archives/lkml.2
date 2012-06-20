Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2FTJMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:12:08 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44056 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2FTJMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120618102003.GB12029@n2100.arm.linux.org.uk>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-9-git-send-email-lee.jones@linaro.org>
	<20120614183231.GA30185@sirena.org.uk>
	<4FDEEEBD.5070108@linaro.org>
	<20120618102003.GB12029@n2100.arm.linux.org.uk>
Date: Wed, 20 Jun 2012 11:12:05 +0200
Message-ID: <CACRpkdZDVDZYKsT9Lxg3_ef6YKgmcWFa7-o+2PAmYpy47JDysw@mail.gmail.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        Mattias WALLIN <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 12:20 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 18, 2012 at 10:02:53AM +0100, Lee Jones wrote:
>> @@ -361,7 +362,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
>>  static void ab8500_irq_mask(struct irq_data *data)
>>  {
>>       struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
>> -     int offset = data->irq - ab8500->irq_base;
>> +     int offset = data->irq;
>
> Are you sure this is right?  I thought irq_data->irq was the Linux IRQ
> number, irq_data->hwirq was the interrupt number inside the domain.

Agree, this need to be fixed and respin...

Yours,
Linus Walleij

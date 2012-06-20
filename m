Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2FTNAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:00:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63301 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2FTNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:00:07 -0400
Message-ID: <4FE1C952.5000306@linaro.org>
Date: Wed, 20 Jun 2012 14:00:02 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-9-git-send-email-lee.jones@linaro.org> <20120614183231.GA30185@sirena.org.uk> <4FDEEEBD.5070108@linaro.org> <20120618102003.GB12029@n2100.arm.linux.org.uk> <20120618185638.GY3974@opensource.wolfsonmicro.com>
In-Reply-To: <20120618185638.GY3974@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/12 19:56, Mark Brown wrote:
> On Mon, Jun 18, 2012 at 11:20:03AM +0100, Russell King - ARM Linux wrote:
>
>>> +	int offset = data->irq;
>
>> Are you sure this is right?  I thought irq_data->irq was the Linux IRQ
>> number, irq_data->hwirq was the interrupt number inside the domain.

Thanks. Good catch. I have just sent a new patch-set to the mailing list 
where I have sent the fixed- up patch again.

> Yes, that's correct.  I'm surprised the code runs without crashing...

Oddly the code ran perfectly.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

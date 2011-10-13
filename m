Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab1JMRTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:19:40 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:48223 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab1JMRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <20111013144515.GD21648@n2100.arm.linux.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-5-git-send-email-mturquette@ti.com> <20111013144515.GD21648@n2100.arm.linux.org.uk>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 13 Oct 2011 10:18:31 -0700
Message-ID: <CAJOA=zMikM=0UT1_qJZ_Tz2dpVLRnqQU2gOCCuhnxqjNPSwWPg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quiinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 7:45 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Sep 22, 2011 at 03:26:59PM -0700, Mike Turquette wrote:
>> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
>> new file mode 100644
>> index 0000000..a1d8e79
>> --- /dev/null
>> +++ b/drivers/clk/clk-gate.c
>> @@ -0,0 +1,78 @@
>> +/*
>> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * Simple clk gate implementation
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/module.h>
>> +#include <asm/io.h>
>
> linux/io.h please.
>

Will roll into v3.

Thanks for reviewing,
Mike

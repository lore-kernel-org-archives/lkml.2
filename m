Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1DSIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:16:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34917 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1DSIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:16:58 -0400
Message-ID: <4DAD44F6.1030801@monstr.eu>
Date: Tue, 19 Apr 2011 10:16:54 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <20110418160658.GD23814@pengutronix.de>
In-Reply-To: <20110418160658.GD23814@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> Hi,
> 
>> For example with "uio" compatible string:
>> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>> 	{ .compatible = "uio", },
>> 	{ /* empty for now */ },
>> };
> 
> Please use a proper example with "vendor,device".
> (And after that it won't be empty anymore)
> 
>> +		/* Multiple IRQs are not supported */
>> +		irq = platform_get_irq(pdev, 0);
>> +		if (irq < 0) {
>> +			uioinfo->irq = UIO_IRQ_NONE;
>> +			dev_info(&pdev->dev, "no IRQ found\n");
>> +		} else {
>> +			uioinfo->irq = irq;
>> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
>> +		}
> 
> Come to think of it, the driver so far does not print any dev_info messages,
> only err and warn. So, I'd think these messages should go, too, but this is up
> to Hans.

I used that because I wanted to see more information about UIO in bootlog. If 
you and Hans want to remove it, I will do it.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

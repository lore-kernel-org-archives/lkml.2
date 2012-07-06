Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2GFIKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:10:18 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:49718 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867Ab2GFIKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:10:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkNAAGd9k9bdWOb/2dsb2JhbABFrnsiiBuBB4IYAQEEAScLAQUdIwEFCwsYCRYPCQMCAQIBRQYNAQcBAYgCCbpCizmGJgOVN5ADgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="539371913"
Message-ID: <4FF69D52.4010201@igalia.com>
Date: Fri, 06 Jul 2012 10:09:54 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/19] Staging: xgifb: Improve debug strings.
References: <cover.1341498465.git.magomez@igalia.com> <8e9d31bda6a900ef71ba4a19014624939540455c.1341498465.git.magomez@igalia.com> <20120705174240.GB4519@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20120705174240.GB4519@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Thu, Jul 05, 2012 at 04:45:48PM +0200, Miguel Gómez wrote:
>>   	if (!htotal || !vtotal) {
>> -		pr_debug("XGIfb: Invalid 'var' information\n");
>> +		pr_debug("Invalid 'var' information\n");
> [...]
>> -		pr_err("xgifb: invalid value for option: %s\n", fullopt);
>> +		pr_err("Invalid value for option: %s\n", fullopt);
> [...]
>> -	pr_info("xgifb: options: %s\n", options);
>> +	pr_info("Options: %s\n", options);
>
> Can you really remove the driver prefix?

As the pr format is defined as

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

it will include the module name for free.

>>   	if (reg1 != 0xa1) { /*I/O error */
>> -		dev_err(&pdev->dev, "I/O error!!!");
>> +		dev_err(&pdev->dev, "I/O error!!!\n");
>
> Those exclamation marks are just redundant noise.

Written down for the next round ;)

>> -		dev_err(&pdev->dev, "unable request memory size %x\n",
>> +		dev_err(&pdev->dev, "Unable request memory size %x\n",
> [...]
>> -		dev_err(&pdev->dev, "no supported video mode found\n");
>> +		dev_err(&pdev->dev, "No supported video mode found\n");
> [...]
>> -		dev_info(&pdev->dev, "added MTRR\n");
>> +		dev_info(&pdev->dev, "Added MTRR\n");
> [...]
>> -		dev_err(&pdev->dev, "video BIOS not available\n");
>> +		dev_err(&pdev->dev, "Video BIOS not available\n");
> [...]
>> -	dev_err(&pdev->dev, "video BIOS corrupted\n");
>> +	dev_err(&pdev->dev, "Video BIOS corrupted\n");
>
> What is the improvement?

Capitalizing the first letter, just to keep coherency. It's not the most 
important change in the world, but it's nice :)

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com


